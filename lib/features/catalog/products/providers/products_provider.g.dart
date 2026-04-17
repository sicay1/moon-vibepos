// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productsStreamHash() => r'2875ebc6bcf02ad74362689174becd417bd7b96c';

/// See also [productsStream].
@ProviderFor(productsStream)
final productsStreamProvider =
    AutoDisposeStreamProvider<List<Product>>.internal(
      productsStream,
      name: r'productsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$productsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProductsStreamRef = AutoDisposeStreamProviderRef<List<Product>>;
String _$productsNotifierHash() => r'73c951e8b07d25d4b72dddd5005d323d6c919813';

/// See also [ProductsNotifier].
@ProviderFor(ProductsNotifier)
final productsNotifierProvider =
    AutoDisposeNotifierProvider<ProductsNotifier, void>.internal(
      ProductsNotifier.new,
      name: r'productsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$productsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProductsNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
