// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sizesStreamHash() => r'a10f14d405c8d9584c88eaef031e1f34fb74386c';

/// See also [sizesStream].
@ProviderFor(sizesStream)
final sizesStreamProvider = AutoDisposeStreamProvider<List<Size>>.internal(
  sizesStream,
  name: r'sizesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sizesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SizesStreamRef = AutoDisposeStreamProviderRef<List<Size>>;
String _$iceLevelsStreamHash() => r'5004cb4114cee7e55a73c69f299506fbf49431cf';

/// See also [iceLevelsStream].
@ProviderFor(iceLevelsStream)
final iceLevelsStreamProvider =
    AutoDisposeStreamProvider<List<IceLevel>>.internal(
      iceLevelsStream,
      name: r'iceLevelsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$iceLevelsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IceLevelsStreamRef = AutoDisposeStreamProviderRef<List<IceLevel>>;
String _$sweetLevelsStreamHash() => r'953e022c22b4360f4acd88e0d6c8c2a67ebf527e';

/// See also [sweetLevelsStream].
@ProviderFor(sweetLevelsStream)
final sweetLevelsStreamProvider =
    AutoDisposeStreamProvider<List<SweetLevel>>.internal(
      sweetLevelsStream,
      name: r'sweetLevelsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sweetLevelsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SweetLevelsStreamRef = AutoDisposeStreamProviderRef<List<SweetLevel>>;
String _$productSizesStreamHash() =>
    r'b33e3aa3993822e01cf45a100c55d29cf8191d4d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [productSizesStream].
@ProviderFor(productSizesStream)
const productSizesStreamProvider = ProductSizesStreamFamily();

/// See also [productSizesStream].
class ProductSizesStreamFamily extends Family<AsyncValue<List<Size>>> {
  /// See also [productSizesStream].
  const ProductSizesStreamFamily();

  /// See also [productSizesStream].
  ProductSizesStreamProvider call(int productId) {
    return ProductSizesStreamProvider(productId);
  }

  @override
  ProductSizesStreamProvider getProviderOverride(
    covariant ProductSizesStreamProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productSizesStreamProvider';
}

/// See also [productSizesStream].
class ProductSizesStreamProvider extends AutoDisposeStreamProvider<List<Size>> {
  /// See also [productSizesStream].
  ProductSizesStreamProvider(int productId)
    : this._internal(
        (ref) => productSizesStream(ref as ProductSizesStreamRef, productId),
        from: productSizesStreamProvider,
        name: r'productSizesStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productSizesStreamHash,
        dependencies: ProductSizesStreamFamily._dependencies,
        allTransitiveDependencies:
            ProductSizesStreamFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductSizesStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final int productId;

  @override
  Override overrideWith(
    Stream<List<Size>> Function(ProductSizesStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductSizesStreamProvider._internal(
        (ref) => create(ref as ProductSizesStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Size>> createElement() {
    return _ProductSizesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductSizesStreamProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductSizesStreamRef on AutoDisposeStreamProviderRef<List<Size>> {
  /// The parameter `productId` of this provider.
  int get productId;
}

class _ProductSizesStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Size>>
    with ProductSizesStreamRef {
  _ProductSizesStreamProviderElement(super.provider);

  @override
  int get productId => (origin as ProductSizesStreamProvider).productId;
}

String _$productIceLevelsStreamHash() =>
    r'04d2e740803b05cfd7443bd45f8f2ffea92b6168';

/// See also [productIceLevelsStream].
@ProviderFor(productIceLevelsStream)
const productIceLevelsStreamProvider = ProductIceLevelsStreamFamily();

/// See also [productIceLevelsStream].
class ProductIceLevelsStreamFamily extends Family<AsyncValue<List<IceLevel>>> {
  /// See also [productIceLevelsStream].
  const ProductIceLevelsStreamFamily();

  /// See also [productIceLevelsStream].
  ProductIceLevelsStreamProvider call(int productId) {
    return ProductIceLevelsStreamProvider(productId);
  }

  @override
  ProductIceLevelsStreamProvider getProviderOverride(
    covariant ProductIceLevelsStreamProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productIceLevelsStreamProvider';
}

/// See also [productIceLevelsStream].
class ProductIceLevelsStreamProvider
    extends AutoDisposeStreamProvider<List<IceLevel>> {
  /// See also [productIceLevelsStream].
  ProductIceLevelsStreamProvider(int productId)
    : this._internal(
        (ref) =>
            productIceLevelsStream(ref as ProductIceLevelsStreamRef, productId),
        from: productIceLevelsStreamProvider,
        name: r'productIceLevelsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productIceLevelsStreamHash,
        dependencies: ProductIceLevelsStreamFamily._dependencies,
        allTransitiveDependencies:
            ProductIceLevelsStreamFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductIceLevelsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final int productId;

  @override
  Override overrideWith(
    Stream<List<IceLevel>> Function(ProductIceLevelsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductIceLevelsStreamProvider._internal(
        (ref) => create(ref as ProductIceLevelsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<IceLevel>> createElement() {
    return _ProductIceLevelsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductIceLevelsStreamProvider &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductIceLevelsStreamRef
    on AutoDisposeStreamProviderRef<List<IceLevel>> {
  /// The parameter `productId` of this provider.
  int get productId;
}

class _ProductIceLevelsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<IceLevel>>
    with ProductIceLevelsStreamRef {
  _ProductIceLevelsStreamProviderElement(super.provider);

  @override
  int get productId => (origin as ProductIceLevelsStreamProvider).productId;
}

String _$productSweetLevelsStreamHash() =>
    r'd4f13b4738d8ccac4a15bf72fca9781325c22f2b';

/// See also [productSweetLevelsStream].
@ProviderFor(productSweetLevelsStream)
const productSweetLevelsStreamProvider = ProductSweetLevelsStreamFamily();

/// See also [productSweetLevelsStream].
class ProductSweetLevelsStreamFamily
    extends Family<AsyncValue<List<SweetLevel>>> {
  /// See also [productSweetLevelsStream].
  const ProductSweetLevelsStreamFamily();

  /// See also [productSweetLevelsStream].
  ProductSweetLevelsStreamProvider call(int productId) {
    return ProductSweetLevelsStreamProvider(productId);
  }

  @override
  ProductSweetLevelsStreamProvider getProviderOverride(
    covariant ProductSweetLevelsStreamProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productSweetLevelsStreamProvider';
}

/// See also [productSweetLevelsStream].
class ProductSweetLevelsStreamProvider
    extends AutoDisposeStreamProvider<List<SweetLevel>> {
  /// See also [productSweetLevelsStream].
  ProductSweetLevelsStreamProvider(int productId)
    : this._internal(
        (ref) => productSweetLevelsStream(
          ref as ProductSweetLevelsStreamRef,
          productId,
        ),
        from: productSweetLevelsStreamProvider,
        name: r'productSweetLevelsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productSweetLevelsStreamHash,
        dependencies: ProductSweetLevelsStreamFamily._dependencies,
        allTransitiveDependencies:
            ProductSweetLevelsStreamFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductSweetLevelsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final int productId;

  @override
  Override overrideWith(
    Stream<List<SweetLevel>> Function(ProductSweetLevelsStreamRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductSweetLevelsStreamProvider._internal(
        (ref) => create(ref as ProductSweetLevelsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<SweetLevel>> createElement() {
    return _ProductSweetLevelsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductSweetLevelsStreamProvider &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductSweetLevelsStreamRef
    on AutoDisposeStreamProviderRef<List<SweetLevel>> {
  /// The parameter `productId` of this provider.
  int get productId;
}

class _ProductSweetLevelsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<SweetLevel>>
    with ProductSweetLevelsStreamRef {
  _ProductSweetLevelsStreamProviderElement(super.provider);

  @override
  int get productId => (origin as ProductSweetLevelsStreamProvider).productId;
}

String _$sizesNotifierHash() => r'241106c4a0ffc3cdb75fff3609c97d36a2849319';

/// See also [SizesNotifier].
@ProviderFor(SizesNotifier)
final sizesNotifierProvider =
    AutoDisposeNotifierProvider<SizesNotifier, void>.internal(
      SizesNotifier.new,
      name: r'sizesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sizesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SizesNotifier = AutoDisposeNotifier<void>;
String _$iceLevelsNotifierHash() => r'5e9dda3e153821602c41b2a7409b8fe5122baa99';

/// See also [IceLevelsNotifier].
@ProviderFor(IceLevelsNotifier)
final iceLevelsNotifierProvider =
    AutoDisposeNotifierProvider<IceLevelsNotifier, void>.internal(
      IceLevelsNotifier.new,
      name: r'iceLevelsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$iceLevelsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$IceLevelsNotifier = AutoDisposeNotifier<void>;
String _$sweetLevelsNotifierHash() =>
    r'ed09c1650d502cb43d37bc6bdb01ebfa516246e8';

/// See also [SweetLevelsNotifier].
@ProviderFor(SweetLevelsNotifier)
final sweetLevelsNotifierProvider =
    AutoDisposeNotifierProvider<SweetLevelsNotifier, void>.internal(
      SweetLevelsNotifier.new,
      name: r'sweetLevelsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sweetLevelsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SweetLevelsNotifier = AutoDisposeNotifier<void>;
String _$productOptionsNotifierHash() =>
    r'c4ce0fa7fe50bd5b1b3bd1b05790a714b4f2c4f1';

/// See also [ProductOptionsNotifier].
@ProviderFor(ProductOptionsNotifier)
final productOptionsNotifierProvider =
    AutoDisposeNotifierProvider<ProductOptionsNotifier, void>.internal(
      ProductOptionsNotifier.new,
      name: r'productOptionsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$productOptionsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProductOptionsNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
