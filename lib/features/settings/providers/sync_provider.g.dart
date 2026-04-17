// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncSettingsNotifierHash() =>
    r'7b898f68b45e7478949d7a606e36ad810304d5b0';

/// Persists the Web App URL and last-synced order ID.
///
/// Copied from [SyncSettingsNotifier].
@ProviderFor(SyncSettingsNotifier)
final syncSettingsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      SyncSettingsNotifier,
      ({String webAppUrl, int lastSyncedId})
    >.internal(
      SyncSettingsNotifier.new,
      name: r'syncSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SyncSettingsNotifier =
    AutoDisposeAsyncNotifier<({String webAppUrl, int lastSyncedId})>;
String _$syncNotifierHash() => r'd0bf2045221eda18cefc34caf1e3fe2cf9a11602';

/// See also [SyncNotifier].
@ProviderFor(SyncNotifier)
final syncNotifierProvider =
    AutoDisposeNotifierProvider<SyncNotifier, SyncState>.internal(
      SyncNotifier.new,
      name: r'syncNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SyncNotifier = AutoDisposeNotifier<SyncState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
