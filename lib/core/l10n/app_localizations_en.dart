// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MoonPOS';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navOrders => 'Orders';

  @override
  String get navCatalog => 'Manage';

  @override
  String get navContacts => 'Contacts';

  @override
  String get navSettings => 'Settings';

  @override
  String get tabCategories => 'Categories';

  @override
  String get tabProducts => 'Products';

  @override
  String get tabToppings => 'Toppings';

  @override
  String get tabCustomers => 'Customers';

  @override
  String get tabSuppliers => 'Suppliers';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get search => 'Search';

  @override
  String get name => 'Name';

  @override
  String get price => 'Price';

  @override
  String get description => 'Description';

  @override
  String get notes => 'Notes';

  @override
  String get address => 'Address';

  @override
  String get phone => 'Phone';

  @override
  String get avatar => 'Avatar';

  @override
  String get images => 'Images';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get category => 'Category';

  @override
  String get none => 'None';

  @override
  String get deleteConfirmTitle => 'Delete?';

  @override
  String get deleteConfirmMessage => 'This action cannot be undone.';

  @override
  String get emptyList => 'Nothing here yet. Tap + to add.';

  @override
  String get categoryListTitle => 'Categories';

  @override
  String get productListTitle => 'Products';

  @override
  String get toppingListTitle => 'Toppings';

  @override
  String get customerListTitle => 'Customers';

  @override
  String get supplierListTitle => 'Suppliers';

  @override
  String get orderListTitle => 'Orders';

  @override
  String get categoryFormAdd => 'Add Category';

  @override
  String get categoryFormEdit => 'Edit Category';

  @override
  String get productFormAdd => 'Add Product';

  @override
  String get productFormEdit => 'Edit Product';

  @override
  String get toppingFormAdd => 'Add Topping';

  @override
  String get toppingFormEdit => 'Edit Topping';

  @override
  String get customerFormAdd => 'Add Customer';

  @override
  String get customerFormEdit => 'Edit Customer';

  @override
  String get supplierFormAdd => 'Add Supplier';

  @override
  String get supplierFormEdit => 'Edit Supplier';

  @override
  String get parentProduct => 'Parent Product';

  @override
  String get facebook => 'Facebook';

  @override
  String get zalo => 'Zalo';

  @override
  String get googleMap => 'Google Map URL';

  @override
  String get priceNote => 'Price note';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusCompleted => 'Completed';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get newOrder => 'New Order';

  @override
  String get orderCustomerOptional => 'Customer (optional)';

  @override
  String get orderNoCustomer => 'No customer';

  @override
  String get orderTotal => 'Total';

  @override
  String get orderDiscount => 'Discount';

  @override
  String get orderNote => 'Order note';

  @override
  String get orderFinalize => 'Finalize Order';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get quantity => 'Quantity';

  @override
  String get toppings => 'Toppings';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get todaySales => 'Today';

  @override
  String get weekSales => 'This Week';

  @override
  String get monthSales => 'This Month';

  @override
  String get topCustomers => 'Top Customers';

  @override
  String get topCustomersThisMonth => 'Top Customers (This Month)';

  @override
  String get last7DaysRevenue => 'Last 7 Days Revenue';

  @override
  String get bestSelling => 'Best Selling';

  @override
  String get totalOrders => 'Orders';

  @override
  String get revenue => 'Revenue';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLangEn => 'English';

  @override
  String get settingsLangVi => 'Tiếng Việt';

  @override
  String get settingsDatabase => 'Database';

  @override
  String get settingsBackup => 'Backup & Restore';

  @override
  String get backupCreate => 'Create Backup';

  @override
  String get backupCreateSubtitle =>
      'Export all data and images as a .moonbak.zip file';

  @override
  String get backupRestore => 'Restore from Backup';

  @override
  String get backupRestoreSubtitle => 'Import data from a .moonbak.zip file';

  @override
  String get backupRestoreWarning =>
      'This will permanently overwrite ALL current data (orders, customers, catalog, options). This cannot be undone. Continue?';

  @override
  String get backupInProgress => 'Creating backup…';

  @override
  String get backupSuccess => 'Backup created successfully';

  @override
  String get backupSaveToDevice => 'Save to device';

  @override
  String get backupShare => 'Share to app';

  @override
  String get backupFailed => 'Backup failed';

  @override
  String get restoreInProgress => 'Restoring…';

  @override
  String get restoreSuccess => 'Restore completed successfully';

  @override
  String get restoreFailed => 'Restore failed';

  @override
  String get cleanupClearOrders => 'Clear Orders';

  @override
  String get cleanupClearOrdersSubtitle =>
      'Remove order history and order items';

  @override
  String get cleanupClearOrdersAll => 'Clear all orders';

  @override
  String get cleanupClearOrdersAllSubtitle =>
      'Removes every order regardless of date';

  @override
  String get cleanupClearOrdersOlderThan => 'Orders older than…';

  @override
  String get cleanupClearOrdersOlderThanSubtitle => 'Tap to pick a date';

  @override
  String cleanupClearOrdersOlderThanSelected(
    String day,
    String month,
    String year,
  ) {
    return 'Before $day/$month/$year';
  }

  @override
  String get cleanupClearOrdersOlderThanButton =>
      'Clear Orders Older Than Selected Date';

  @override
  String get cleanupClearOrdersAllDesc =>
      'Every order and order item will be permanently deleted.';

  @override
  String cleanupClearOrdersOlderThanDesc(String date) {
    return 'Orders created before $date will be permanently deleted.';
  }

  @override
  String get cleanupClearCustomers => 'Clear Customers';

  @override
  String get cleanupClearCustomersSubtitle => 'Remove all customer records';

  @override
  String get cleanupClearCustomersDesc =>
      'All customer records will be permanently deleted. Orders will remain but without customer info.';

  @override
  String get cleanupClearSuppliers => 'Clear Suppliers';

  @override
  String get cleanupClearSuppliersSubtitle => 'Remove all supplier records';

  @override
  String get cleanupClearSuppliersDesc =>
      'All supplier records will be permanently deleted.';

  @override
  String get cleanupClearCatalog => 'Clear Catalog';

  @override
  String get cleanupClearCatalogSubtitle =>
      'Remove all categories, products, and toppings';

  @override
  String get cleanupClearCatalogDesc =>
      'All categories, products, and toppings will be permanently deleted.';

  @override
  String get cleanupResetOptions => 'Reset Options';

  @override
  String get cleanupResetOptionsSubtitle =>
      'Reset Size / Ice / Sweet to defaults';

  @override
  String get cleanupResetOptionsDesc =>
      'All custom size, ice, and sweet level options will be deleted and replaced with the default seeded values.';

  @override
  String get cleanupFactoryReset => 'Factory Reset';

  @override
  String get cleanupFactoryResetSubtitle => 'Wipe everything and start fresh';

  @override
  String get cleanupFactoryResetDesc =>
      'ALL data will be permanently deleted: orders, customers, suppliers, catalog, and options. Options will be re-seeded with defaults.';

  @override
  String get cleanupConfirmTypeHint => 'Type DELETE to confirm:';

  @override
  String get cleanupConfirmButton => 'Confirm Delete';

  @override
  String cleanupSuccessMessage(String action) {
    return '$action completed';
  }

  @override
  String validationRequired(String field) {
    return '$field is required';
  }

  @override
  String validationPositiveNumber(String field) {
    return '$field must be a positive number';
  }

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutAuthor => 'Author';

  @override
  String get aboutAuthorName => 'VibeCode by Ton Truong';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutOpenSourceLicenses => 'Open Source Licenses';
}
