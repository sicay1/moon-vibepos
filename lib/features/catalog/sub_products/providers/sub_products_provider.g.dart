// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subProductsStreamHash() => r'9a0db64386a007ebb291f5d7473d1e150cf00429';

/// See also [subProductsStream].
@ProviderFor(subProductsStream)
final subProductsStreamProvider =
    AutoDisposeStreamProvider<List<SubProduct>>.internal(
      subProductsStream,
      name: r'subProductsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subProductsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubProductsStreamRef = AutoDisposeStreamProviderRef<List<SubProduct>>;
String _$subProductsNotifierHash() =>
    r'c652b0243728835c7b05cafe54606921ebf3bf98';

/// See also [SubProductsNotifier].
@ProviderFor(SubProductsNotifier)
final subProductsNotifierProvider =
    AutoDisposeNotifierProvider<SubProductsNotifier, void>.internal(
      SubProductsNotifier.new,
      name: r'subProductsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subProductsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SubProductsNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
