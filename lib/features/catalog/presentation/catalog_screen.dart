import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../categories/presentation/categories_screen.dart';
import '../products/presentation/products_screen.dart';
import '../sub_products/presentation/sub_products_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          scrolledUnderElevation: 1,
          shadowColor: AppColors.shadow,
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.tabCategories),
              Tab(text: l10n.tabProducts),
              Tab(text: l10n.tabToppings),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CategoriesScreen(),
            ProductsScreen(),
            SubProductsScreen(),
          ],
        ),
      ),
    );
  }
}
