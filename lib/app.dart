import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/l10n/app_localizations.dart';

import 'core/providers/shell_nav_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/orders/presentation/orders_screen.dart';
import 'features/catalog/presentation/catalog_screen.dart';
import 'features/contacts/presentation/contacts_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/settings/providers/locale_provider.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  // 0 = Catalog, 1 = Orders, 2 = Contacts
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(localeNotifierProvider.notifier).load());
  }

  static final _tabScreens = [
    CatalogScreen(),
    OrdersScreen(),
    ContactsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeNotifierProvider);
    final nav = ref.watch(shellNavProvider);

    Widget body;
    if (nav.showDashboard) {
      body = const DashboardScreen();
    } else if (nav.showSettings) {
      body = const SettingsScreen();
    } else {
      body = IndexedStack(index: _selectedIndex, children: _tabScreens);
    }

    return MaterialApp(
      title: 'MoonPOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('vi')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: _MainAppBar(
          showDashboard: nav.showDashboard,
          showSettings: nav.showSettings,
          onDashboardTap: () =>
              ref.read(shellNavProvider.notifier).toggleDashboard(),
          onSettingsTap: () =>
              ref.read(shellNavProvider.notifier).toggleSettings(),
        ),
        body: body,
        bottomNavigationBar: _BottomNav(
          selectedIndex: _selectedIndex,
          onTap: (i) {
            ref.read(shellNavProvider.notifier).close();
            setState(() => _selectedIndex = i);
          },
        ),
      ),
    );
  }
}

class _MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showDashboard;
  final bool showSettings;
  final VoidCallback onDashboardTap;
  final VoidCallback onSettingsTap;

  const _MainAppBar({
    required this.showDashboard,
    required this.showSettings,
    required this.onDashboardTap,
    required this.onSettingsTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.shadow,
      elevation: 0,
      // Logo centered via flexibleSpace
      flexibleSpace: SafeArea(
        child: SizedBox(
          height: kToolbarHeight,
          child: Image.asset(
            'assets/images/logo_only.jpg',
            height: 48,
            fit: BoxFit.contain,
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(
          showDashboard ? Icons.dashboard : Icons.dashboard_outlined,
          color: showDashboard ? AppColors.primary : AppColors.onSurfaceVariant,
        ),
        tooltip: 'Dashboard',
        onPressed: onDashboardTap,
      ),
      actions: [
        IconButton(
          icon: Icon(
            showSettings ? Icons.settings : Icons.settings_outlined,
            color: showSettings
                ? AppColors.primary
                : AppColors.onSurfaceVariant,
          ),
          tooltip: 'Settings',
          onPressed: onSettingsTap,
        ),
      ],
    );
  }
}

class _BottomNav extends ConsumerWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.storefront_outlined),
          selectedIcon: const Icon(Icons.storefront),
          label: l10n.navCatalog,
        ),
        NavigationDestination(
          icon: const Icon(Icons.receipt_long_outlined),
          selectedIcon: const Icon(Icons.receipt_long),
          label: l10n.navOrders,
        ),
        NavigationDestination(
          icon: const Icon(Icons.people_outline),
          selectedIcon: const Icon(Icons.people),
          label: l10n.navContacts,
        ),
      ],
    );
  }
}
