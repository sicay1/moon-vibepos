// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customersStreamHash() => r'6cad175fecbf7254690bc5dcaeea0430051364e1';

/// See also [customersStream].
@ProviderFor(customersStream)
final customersStreamProvider =
    AutoDisposeStreamProvider<List<Customer>>.internal(
      customersStream,
      name: r'customersStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customersStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CustomersStreamRef = AutoDisposeStreamProviderRef<List<Customer>>;
String _$customersNotifierHash() => r'd39929d914eafabfad8b8abc4686cf03b7ad198b';

/// See also [CustomersNotifier].
@ProviderFor(CustomersNotifier)
final customersNotifierProvider =
    AutoDisposeNotifierProvider<CustomersNotifier, void>.internal(
      CustomersNotifier.new,
      name: r'customersNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customersNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CustomersNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
