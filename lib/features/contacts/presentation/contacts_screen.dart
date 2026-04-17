import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../customers/presentation/customers_screen.dart';
import '../suppliers/presentation/suppliers_screen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          scrolledUnderElevation: 1,
          shadowColor: AppColors.shadow,
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.tabCustomers),
              Tab(text: l10n.tabSuppliers),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CustomersScreen(),
            SuppliersScreen(),
          ],
        ),
      ),
    );
  }
}
