import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/db/daos/orders_dao.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/services/sheets_sync_service.dart';

part 'sync_provider.g.dart';

// ── Keys ──────────────────────────────────────────────────────────────────────

const _kWebAppUrl = 'sheets_sync_web_app_url';
const _kLastSyncedId = 'sheets_sync_last_order_id';

// ── State ─────────────────────────────────────────────────────────────────────

sealed class SyncState {
  const SyncState();
}

class SyncIdle extends SyncState {
  const SyncIdle();
}

class SyncInProgress extends SyncState {
  const SyncInProgress();
}

class SyncSuccess extends SyncState {
  final int count;
  final DateTime syncedAt;
  const SyncSuccess(this.count, this.syncedAt);
}

class SyncError extends SyncState {
  final String message;
  const SyncError(this.message);
}

// ── Settings provider ─────────────────────────────────────────────────────────

/// Persists the Web App URL and last-synced order ID.
@riverpod
class SyncSettingsNotifier extends _$SyncSettingsNotifier {
  late SharedPreferences _prefs;

  @override
  Future<({String webAppUrl, int lastSyncedId})> build() async {
    _prefs = await SharedPreferences.getInstance();
    return (
      webAppUrl: _prefs.getString(_kWebAppUrl) ?? '',
      lastSyncedId: _prefs.getInt(_kLastSyncedId) ?? 0,
    );
  }

  Future<void> saveWebAppUrl(String url) async {
    await _prefs.setString(_kWebAppUrl, url.trim());
    state = AsyncData((
      webAppUrl: url.trim(),
      lastSyncedId: state.valueOrNull?.lastSyncedId ?? 0,
    ));
  }

  Future<void> _persistLastSyncedId(int id) async {
    await _prefs.setInt(_kLastSyncedId, id);
    state = AsyncData((
      webAppUrl: state.valueOrNull?.webAppUrl ?? '',
      lastSyncedId: id,
    ));
  }
}

// ── Sync notifier ─────────────────────────────────────────────────────────────

@riverpod
class SyncNotifier extends _$SyncNotifier {
  static final _dtFmt = DateFormat('dd-MM-yyyy HH:mm:ss');

  @override
  SyncState build() => const SyncIdle();

  Future<void> sync() async {
    if (state is SyncInProgress) return;
    state = const SyncInProgress();

    try {
      final settings = await ref.read(syncSettingsNotifierProvider.future);
      final webAppUrl = settings.webAppUrl;

      if (webAppUrl.isEmpty) {
        state = const SyncError('Web App URL is not configured.');
        return;
      }

      final lastId = settings.lastSyncedId;
      final dao = ref.read(appDatabaseProvider).ordersDao;

      // Fetch only orders newer than lastSyncedId
      final allOrders = await dao.getAll();
      final newOrders =
          allOrders.where((o) => o.id > lastId).toList();

      if (newOrders.isEmpty) {
        state = SyncSuccess(0, DateTime.now());
        return;
      }

      final summaryRows = <Map<String, dynamic>>[];
      final detailRows = <Map<String, dynamic>>[];

      for (final order in newOrders) {
        summaryRows.add({
          'orderId': order.id,
          'customerId': order.customerId ?? '',
          'total': order.totalAmount,
          'discount': order.discount,
          'note': order.note ?? '',
          'status': order.status,
          'createdAt':
              _dtFmt.format(order.createdAt.toLocal()),
        });

        final items = await dao.getItemsByOrder(order.id);
        for (final item in items) {
          final toppings = await dao.getToppingsByItem(item.id);
          final toppingStr = toppings
              .map((t) => '${t.subProductName} x${t.quantity}')
              .join(', ');

          final itemTotal = (item.unitPrice + (item.sizePrice ?? 0)) *
                  item.quantity +
              toppings.fold<double>(
                  0, (s, t) => s + t.unitPrice * t.quantity);

          detailRows.add({
            'orderId': order.id,
            'itemId': item.id,
            'productName': item.productName,
            'qty': item.quantity,
            'unitPrice': item.unitPrice,
            'size': item.sizeLabel ?? '',
            'iceLevel': item.iceLabel ?? '',
            'sweetLevel': item.sweetLabel ?? '',
            'toppings': toppingStr,
            'itemTotal': itemTotal,
          });
        }
      }

      await postOrdersToSheet(
        webAppUrl: webAppUrl,
        summaryRows: summaryRows,
        detailRows: detailRows,
      );

      // Persist the highest order ID we just synced
      final maxId = newOrders.map((o) => o.id).reduce((a, b) => a > b ? a : b);
      await ref
          .read(syncSettingsNotifierProvider.notifier)
          ._persistLastSyncedId(maxId);

      state = SyncSuccess(newOrders.length, DateTime.now());
    } catch (e) {
      state = SyncError(e.toString());
    }
  }
}
