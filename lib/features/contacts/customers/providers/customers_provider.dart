import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/providers/database_provider.dart';

part 'customers_provider.g.dart';

@riverpod
Stream<List<Customer>> customersStream(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.customersDao.watchAll();
}

@riverpod
class CustomersNotifier extends _$CustomersNotifier {
  @override
  void build() {}

  AppDatabase get _db => ref.read(appDatabaseProvider);

  Future<int> add({
    required String name,
    String? phone,
    String? address,
    String? avatarPath,
    String? facebookContact,
    String? zaloContact,
    String? notes,
  }) {
    return _db.customersDao.insertCustomer(
      CustomersCompanion.insert(
        name: name,
        phone: Value(phone),
        address: Value(address),
        avatarPath: Value(avatarPath),
        facebookContact: Value(facebookContact),
        zaloContact: Value(zaloContact),
        notes: Value(notes),
      ),
    );
  }

  Future<bool> update(Customer customer) {
    return _db.customersDao.updateCustomer(
      CustomersCompanion(
        id: Value(customer.id),
        name: Value(customer.name),
        phone: Value(customer.phone),
        address: Value(customer.address),
        avatarPath: Value(customer.avatarPath),
        facebookContact: Value(customer.facebookContact),
        zaloContact: Value(customer.zaloContact),
        notes: Value(customer.notes),
      ),
    );
  }

  Future<int> delete(int id) {
    return _db.customersDao.deleteCustomer(id);
  }
}
