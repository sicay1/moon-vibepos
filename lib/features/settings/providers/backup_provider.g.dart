// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$backupDaoHash() => r'ad15b62b8102434ba7b15d59a6471b3ffa48fe12';

/// See also [backupDao].
@ProviderFor(backupDao)
final backupDaoProvider = AutoDisposeProvider<BackupDao>.internal(
  backupDao,
  name: r'backupDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BackupDaoRef = AutoDisposeProviderRef<BackupDao>;
String _$backupNotifierHash() => r'addb8cf9a3ca69710513fb3a481d9c95dcee1ab5';

/// See also [BackupNotifier].
@ProviderFor(BackupNotifier)
final backupNotifierProvider =
    AutoDisposeNotifierProvider<BackupNotifier, void>.internal(
      BackupNotifier.new,
      name: r'backupNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$backupNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BackupNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
