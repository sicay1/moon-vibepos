// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suppliers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$suppliersStreamHash() => r'218dbd1ee1256292e469f2a2bb167b06134257d8';

/// See also [suppliersStream].
@ProviderFor(suppliersStream)
final suppliersStreamProvider =
    AutoDisposeStreamProvider<List<Supplier>>.internal(
      suppliersStream,
      name: r'suppliersStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$suppliersStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SuppliersStreamRef = AutoDisposeStreamProviderRef<List<Supplier>>;
String _$suppliersNotifierHash() => r'f5334b1233b63ce95c7967523431174c0e329f2a';

/// See also [SuppliersNotifier].
@ProviderFor(SuppliersNotifier)
final suppliersNotifierProvider =
    AutoDisposeNotifierProvider<SuppliersNotifier, void>.internal(
      SuppliersNotifier.new,
      name: r'suppliersNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$suppliersNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SuppliersNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
