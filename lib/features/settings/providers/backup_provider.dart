import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/daos/backup_dao.dart';
import '../../../core/providers/database_provider.dart';

part 'backup_provider.g.dart';

@riverpod
BackupDao backupDao(BackupDaoRef ref) =>
    ref.watch(appDatabaseProvider).backupDao;

@riverpod
class BackupNotifier extends _$BackupNotifier {
  @override
  void build() {}

  static final _dtFmt = DateFormat('dd-MM-yyyy HH:mm:ss');

  // ── Backup ────────────────────────────────────────────────────────────────

  /// Builds the .moonbak.zip archive and returns its local file path.
  /// The caller is responsible for sharing or saving the file.
  Future<String> backup() async {
    final dao = ref.read(backupDaoProvider);
    final data = await dao.exportAll();

    final tempDir = await getTemporaryDirectory();
    final workDir = Directory(p.join(tempDir.path, 'moonpos_backup_work'));
    if (workDir.existsSync()) workDir.deleteSync(recursive: true);
    workDir.createSync();
    final imgDir = Directory(p.join(workDir.path, 'images'))..createSync();

    // Rewrite product image paths to relative, copy files into imgDir
    final productsList =
        (data['products'] as List).cast<Map<String, dynamic>>();
    for (var i = 0; i < productsList.length; i++) {
      final prod = Map<String, dynamic>.from(productsList[i]);
      final id = prod['id'];
      prod['avatarPath'] =
          _copyImage(prod['avatarPath'] as String?, imgDir, 'product_${id}_avatar')
          ?? prod['avatarPath'];

      // images is a JSON-encoded list of paths stored as a String in DB
      final rawImgs = prod['images'] as String? ?? '[]';
      final imgPaths = (jsonDecode(rawImgs) as List).cast<String>();
      final newImgPaths = <String>[];
      for (var j = 0; j < imgPaths.length; j++) {
        newImgPaths.add(
            _copyImage(imgPaths[j], imgDir, 'product_${id}_img_$j') ??
                imgPaths[j]);
      }
      prod['images'] = jsonEncode(newImgPaths);
      prod['createdAt'] = _dtFmt.format(
          DateTime.fromMillisecondsSinceEpoch((prod['createdAt'] as num).toInt()).toLocal());
      productsList[i] = prod;
    }
    data['products'] = productsList;

    // Rewrite category image paths
    final categoriesList =
        (data['categories'] as List).cast<Map<String, dynamic>>();
    for (var i = 0; i < categoriesList.length; i++) {
      final cat = Map<String, dynamic>.from(categoriesList[i]);
      cat['imagePath'] =
          _copyImage(cat['imagePath'] as String?, imgDir, 'category_${cat['id']}')
          ?? cat['imagePath'];
      categoriesList[i] = cat;
    }
    data['categories'] = categoriesList;

    // Rewrite sub-product avatar paths
    final subList =
        (data['subProducts'] as List).cast<Map<String, dynamic>>();
    for (var i = 0; i < subList.length; i++) {
      final sub = Map<String, dynamic>.from(subList[i]);
      sub['avatarPath'] =
          _copyImage(sub['avatarPath'] as String?, imgDir, 'sub_${sub['id']}_avatar')
          ?? sub['avatarPath'];
      subList[i] = sub;
    }
    data['subProducts'] = subList;

    // Reformat customer createdAt
    final customersList =
        (data['customers'] as List).cast<Map<String, dynamic>>();
    for (var i = 0; i < customersList.length; i++) {
      final c = Map<String, dynamic>.from(customersList[i]);
      c['createdAt'] = _dtFmt.format(
          DateTime.fromMillisecondsSinceEpoch((c['createdAt'] as num).toInt()).toLocal());
      customersList[i] = c;
    }
    data['customers'] = customersList;

    // Reformat order createdAt
    final ordersList =
        (data['orders'] as List).cast<Map<String, dynamic>>();
    for (var i = 0; i < ordersList.length; i++) {
      final o = Map<String, dynamic>.from(ordersList[i]);
      o['createdAt'] = _dtFmt.format(
          DateTime.fromMillisecondsSinceEpoch((o['createdAt'] as num).toInt()).toLocal());
      ordersList[i] = o;
    }
    data['orders'] = ordersList;

    // Write backup.json
    final jsonFile = File(p.join(workDir.path, 'backup.json'))
      ..writeAsStringSync(jsonEncode(data));

    // Build ZIP archive
    final archive = Archive();
    _addToArchive(archive, jsonFile, 'backup.json');
    for (final file in imgDir.listSync().whereType<File>()) {
      _addToArchive(archive, file, 'images/${p.basename(file.path)}');
    }

    final ts = DateTime.now()
        .toIso8601String()
        .replaceAll(RegExp(r'[:\-T.]'), '')
        .substring(0, 14);
    final zipPath = p.join(tempDir.path, 'moonpos_backup_$ts.moonbak.zip');
    File(zipPath).writeAsBytesSync(ZipEncoder().encode(archive)!);

    workDir.deleteSync(recursive: true);

    return zipPath;
  }

  // ── Restore ───────────────────────────────────────────────────────────────

  Future<void> restore(String zipPath) async {
    final zipBytes = File(zipPath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(zipBytes);

    final tempDir = await getTemporaryDirectory();
    final extractDir = Directory(p.join(tempDir.path, 'moonpos_restore'));
    if (extractDir.existsSync()) extractDir.deleteSync(recursive: true);
    extractDir.createSync();

    // Extract all entries
    for (final entry in archive) {
      final filePath = p.join(extractDir.path, entry.name);
      if (entry.isFile) {
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(entry.content as List<int>);
      }
    }

    // Parse backup.json
    final jsonFile = File(p.join(extractDir.path, 'backup.json'));
    if (!jsonFile.existsSync()) {
      throw Exception('Invalid backup file: backup.json not found');
    }
    final data =
        jsonDecode(jsonFile.readAsStringSync()) as Map<String, dynamic>;

    // Copy images to app documents, build relative→absolute map
    final docsDir = await getApplicationDocumentsDirectory();
    final destImgDir =
        Directory(p.join(docsDir.path, 'moonpos_images'))
          ..createSync(recursive: true);

    final relToAbs = <String, String>{};
    final extractedImgDir =
        Directory(p.join(extractDir.path, 'images'));
    if (extractedImgDir.existsSync()) {
      for (final file in extractedImgDir.listSync().whereType<File>()) {
        final fname = p.basename(file.path);
        final destPath = p.join(destImgDir.path, fname);
        file.copySync(destPath);
        relToAbs['images/$fname'] = destPath;
      }
    }

    // Rewrite category image paths back to absolute
    final categoriesList =
        (data['categories'] as List? ?? []).cast<Map<String, dynamic>>();
    for (var i = 0; i < categoriesList.length; i++) {
      final cat = Map<String, dynamic>.from(categoriesList[i]);
      cat['imagePath'] = relToAbs[cat['imagePath']] ?? cat['imagePath'];
      categoriesList[i] = cat;
    }
    data['categories'] = categoriesList;

    // Rewrite product paths back to absolute
    final productsList =
        (data['products'] as List? ?? []).cast<Map<String, dynamic>>();
    for (var i = 0; i < productsList.length; i++) {
      final prod = Map<String, dynamic>.from(productsList[i]);
      prod['avatarPath'] =
          relToAbs[prod['avatarPath']] ?? prod['avatarPath'];

      final rawImgs = prod['images'] as String? ?? '[]';
      final imgPaths = (jsonDecode(rawImgs) as List).cast<String>();
      prod['images'] =
          jsonEncode(imgPaths.map((rel) => relToAbs[rel] ?? rel).toList());
      prod['createdAt'] = _restoreDate(prod['createdAt'] as String);
      productsList[i] = prod;
    }
    data['products'] = productsList;

    final subList =
        (data['subProducts'] as List? ?? []).cast<Map<String, dynamic>>();
    for (var i = 0; i < subList.length; i++) {
      final sub = Map<String, dynamic>.from(subList[i]);
      sub['avatarPath'] =
          relToAbs[sub['avatarPath']] ?? sub['avatarPath'];
      subList[i] = sub;
    }
    data['subProducts'] = subList;

    // Parse customer createdAt back to ISO for Drift
    final customersList =
        (data['customers'] as List? ?? []).cast<Map<String, dynamic>>();
    for (var i = 0; i < customersList.length; i++) {
      final c = Map<String, dynamic>.from(customersList[i]);
      c['createdAt'] = _restoreDate(c['createdAt'] as String);
      customersList[i] = c;
    }
    data['customers'] = customersList;

    // Parse order createdAt back to ISO for Drift
    final ordersList =
        (data['orders'] as List? ?? []).cast<Map<String, dynamic>>();
    for (var i = 0; i < ordersList.length; i++) {
      final o = Map<String, dynamic>.from(ordersList[i]);
      o['createdAt'] = _restoreDate(o['createdAt'] as String);
      ordersList[i] = o;
    }
    data['orders'] = ordersList;

    // Wipe existing data, then import
    await ref.read(appDatabaseProvider).cleanupDao.factoryReset();
    await ref.read(backupDaoProvider).importAll(data);

    extractDir.deleteSync(recursive: true); 
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Parses a `dd-MM-yyyy HH:mm:ss` datetime string back to unix milliseconds
  /// for Drift's [ValueSerializer]. Falls back gracefully for ISO strings or
  /// raw integer strings from older backups.
  int _restoreDate(String s) {
    try {
      return _dtFmt.parseStrict(s).toUtc().millisecondsSinceEpoch;
    } catch (_) {
      try {
        return DateTime.parse(s).millisecondsSinceEpoch;
      } catch (_) {
        return int.tryParse(s) ?? DateTime.now().millisecondsSinceEpoch;
      }
    }
  }

  /// Copies [absPath] into [imgDir] under [baseName]+original-ext.
  /// Returns the relative archive path (`images/<filename>`) or null if
  /// the file doesn't exist / path is null.
  String? _copyImage(String? absPath, Directory imgDir, String baseName) {
    if (absPath == null || absPath.isEmpty) return null;
    final src = File(absPath);
    if (!src.existsSync()) return null;
    final ext =
        p.extension(absPath).isNotEmpty ? p.extension(absPath) : '.jpg';
    final relName = '$baseName$ext';
    src.copySync(p.join(imgDir.path, relName));
    return 'images/$relName';
  }

  void _addToArchive(Archive archive, File file, String archivePath) {
    final bytes = file.readAsBytesSync();
    archive.addFile(ArchiveFile(archivePath, bytes.length, bytes));
  }
}
