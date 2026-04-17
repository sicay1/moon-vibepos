import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'MoonPOS'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navCatalog.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get navCatalog;

  /// No description provided for @navContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get navContacts;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @tabCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get tabCategories;

  /// No description provided for @tabProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get tabProducts;

  /// No description provided for @tabToppings.
  ///
  /// In en, this message translates to:
  /// **'Toppings'**
  String get tabToppings;

  /// No description provided for @tabCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get tabCustomers;

  /// No description provided for @tabSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get tabSuppliers;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteConfirmMessage;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet. Tap + to add.'**
  String get emptyList;

  /// No description provided for @categoryListTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoryListTitle;

  /// No description provided for @productListTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productListTitle;

  /// No description provided for @toppingListTitle.
  ///
  /// In en, this message translates to:
  /// **'Toppings'**
  String get toppingListTitle;

  /// No description provided for @customerListTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customerListTitle;

  /// No description provided for @supplierListTitle.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get supplierListTitle;

  /// No description provided for @orderListTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orderListTitle;

  /// No description provided for @categoryFormAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get categoryFormAdd;

  /// No description provided for @categoryFormEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get categoryFormEdit;

  /// No description provided for @productFormAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get productFormAdd;

  /// No description provided for @productFormEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get productFormEdit;

  /// No description provided for @toppingFormAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Topping'**
  String get toppingFormAdd;

  /// No description provided for @toppingFormEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Topping'**
  String get toppingFormEdit;

  /// No description provided for @customerFormAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get customerFormAdd;

  /// No description provided for @customerFormEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get customerFormEdit;

  /// No description provided for @supplierFormAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Supplier'**
  String get supplierFormAdd;

  /// No description provided for @supplierFormEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Supplier'**
  String get supplierFormEdit;

  /// No description provided for @parentProduct.
  ///
  /// In en, this message translates to:
  /// **'Parent Product'**
  String get parentProduct;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @zalo.
  ///
  /// In en, this message translates to:
  /// **'Zalo'**
  String get zalo;

  /// No description provided for @googleMap.
  ///
  /// In en, this message translates to:
  /// **'Google Map URL'**
  String get googleMap;

  /// No description provided for @priceNote.
  ///
  /// In en, this message translates to:
  /// **'Price note'**
  String get priceNote;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @newOrder.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get newOrder;

  /// No description provided for @orderCustomerOptional.
  ///
  /// In en, this message translates to:
  /// **'Customer (optional)'**
  String get orderCustomerOptional;

  /// No description provided for @orderNoCustomer.
  ///
  /// In en, this message translates to:
  /// **'No customer'**
  String get orderNoCustomer;

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderTotal;

  /// No description provided for @orderDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get orderDiscount;

  /// No description provided for @orderNote.
  ///
  /// In en, this message translates to:
  /// **'Order note'**
  String get orderNote;

  /// No description provided for @orderFinalize.
  ///
  /// In en, this message translates to:
  /// **'Finalize Order'**
  String get orderFinalize;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @toppings.
  ///
  /// In en, this message translates to:
  /// **'Toppings'**
  String get toppings;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @todaySales.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todaySales;

  /// No description provided for @weekSales.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get weekSales;

  /// No description provided for @monthSales.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get monthSales;

  /// No description provided for @topCustomers.
  ///
  /// In en, this message translates to:
  /// **'Top Customers'**
  String get topCustomers;

  /// No description provided for @topCustomersThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Top Customers (This Month)'**
  String get topCustomersThisMonth;

  /// No description provided for @last7DaysRevenue.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days Revenue'**
  String get last7DaysRevenue;

  /// No description provided for @bestSelling.
  ///
  /// In en, this message translates to:
  /// **'Best Selling'**
  String get bestSelling;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get totalOrders;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLangEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLangEn;

  /// No description provided for @settingsLangVi.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get settingsLangVi;

  /// No description provided for @settingsDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get settingsDatabase;

  /// No description provided for @settingsBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get settingsBackup;

  /// No description provided for @backupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get backupCreate;

  /// No description provided for @backupCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export all data and images as a .moonbak.zip file'**
  String get backupCreateSubtitle;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from Backup'**
  String get backupRestore;

  /// No description provided for @backupRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import data from a .moonbak.zip file'**
  String get backupRestoreSubtitle;

  /// No description provided for @backupRestoreWarning.
  ///
  /// In en, this message translates to:
  /// **'This will permanently overwrite ALL current data (orders, customers, catalog, options). This cannot be undone. Continue?'**
  String get backupRestoreWarning;

  /// No description provided for @backupInProgress.
  ///
  /// In en, this message translates to:
  /// **'Creating backup…'**
  String get backupInProgress;

  /// No description provided for @backupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup created successfully'**
  String get backupSuccess;

  /// No description provided for @backupSaveToDevice.
  ///
  /// In en, this message translates to:
  /// **'Save to device'**
  String get backupSaveToDevice;

  /// No description provided for @backupShare.
  ///
  /// In en, this message translates to:
  /// **'Share to app'**
  String get backupShare;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed'**
  String get backupFailed;

  /// No description provided for @restoreInProgress.
  ///
  /// In en, this message translates to:
  /// **'Restoring…'**
  String get restoreInProgress;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restore completed successfully'**
  String get restoreSuccess;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed'**
  String get restoreFailed;

  /// No description provided for @cleanupClearOrders.
  ///
  /// In en, this message translates to:
  /// **'Clear Orders'**
  String get cleanupClearOrders;

  /// No description provided for @cleanupClearOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove order history and order items'**
  String get cleanupClearOrdersSubtitle;

  /// No description provided for @cleanupClearOrdersAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all orders'**
  String get cleanupClearOrdersAll;

  /// No description provided for @cleanupClearOrdersAllSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Removes every order regardless of date'**
  String get cleanupClearOrdersAllSubtitle;

  /// No description provided for @cleanupClearOrdersOlderThan.
  ///
  /// In en, this message translates to:
  /// **'Orders older than…'**
  String get cleanupClearOrdersOlderThan;

  /// No description provided for @cleanupClearOrdersOlderThanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick a date'**
  String get cleanupClearOrdersOlderThanSubtitle;

  /// No description provided for @cleanupClearOrdersOlderThanSelected.
  ///
  /// In en, this message translates to:
  /// **'Before {day}/{month}/{year}'**
  String cleanupClearOrdersOlderThanSelected(
    String day,
    String month,
    String year,
  );

  /// No description provided for @cleanupClearOrdersOlderThanButton.
  ///
  /// In en, this message translates to:
  /// **'Clear Orders Older Than Selected Date'**
  String get cleanupClearOrdersOlderThanButton;

  /// No description provided for @cleanupClearOrdersAllDesc.
  ///
  /// In en, this message translates to:
  /// **'Every order and order item will be permanently deleted.'**
  String get cleanupClearOrdersAllDesc;

  /// No description provided for @cleanupClearOrdersOlderThanDesc.
  ///
  /// In en, this message translates to:
  /// **'Orders created before {date} will be permanently deleted.'**
  String cleanupClearOrdersOlderThanDesc(String date);

  /// No description provided for @cleanupClearCustomers.
  ///
  /// In en, this message translates to:
  /// **'Clear Customers'**
  String get cleanupClearCustomers;

  /// No description provided for @cleanupClearCustomersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove all customer records'**
  String get cleanupClearCustomersSubtitle;

  /// No description provided for @cleanupClearCustomersDesc.
  ///
  /// In en, this message translates to:
  /// **'All customer records will be permanently deleted. Orders will remain but without customer info.'**
  String get cleanupClearCustomersDesc;

  /// No description provided for @cleanupClearSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Clear Suppliers'**
  String get cleanupClearSuppliers;

  /// No description provided for @cleanupClearSuppliersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove all supplier records'**
  String get cleanupClearSuppliersSubtitle;

  /// No description provided for @cleanupClearSuppliersDesc.
  ///
  /// In en, this message translates to:
  /// **'All supplier records will be permanently deleted.'**
  String get cleanupClearSuppliersDesc;

  /// No description provided for @cleanupClearCatalog.
  ///
  /// In en, this message translates to:
  /// **'Clear Catalog'**
  String get cleanupClearCatalog;

  /// No description provided for @cleanupClearCatalogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove all categories, products, and toppings'**
  String get cleanupClearCatalogSubtitle;

  /// No description provided for @cleanupClearCatalogDesc.
  ///
  /// In en, this message translates to:
  /// **'All categories, products, and toppings will be permanently deleted.'**
  String get cleanupClearCatalogDesc;

  /// No description provided for @cleanupResetOptions.
  ///
  /// In en, this message translates to:
  /// **'Reset Options'**
  String get cleanupResetOptions;

  /// No description provided for @cleanupResetOptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Size / Ice / Sweet to defaults'**
  String get cleanupResetOptionsSubtitle;

  /// No description provided for @cleanupResetOptionsDesc.
  ///
  /// In en, this message translates to:
  /// **'All custom size, ice, and sweet level options will be deleted and replaced with the default seeded values.'**
  String get cleanupResetOptionsDesc;

  /// No description provided for @cleanupFactoryReset.
  ///
  /// In en, this message translates to:
  /// **'Factory Reset'**
  String get cleanupFactoryReset;

  /// No description provided for @cleanupFactoryResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wipe everything and start fresh'**
  String get cleanupFactoryResetSubtitle;

  /// No description provided for @cleanupFactoryResetDesc.
  ///
  /// In en, this message translates to:
  /// **'ALL data will be permanently deleted: orders, customers, suppliers, catalog, and options. Options will be re-seeded with defaults.'**
  String get cleanupFactoryResetDesc;

  /// No description provided for @cleanupConfirmTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE to confirm:'**
  String get cleanupConfirmTypeHint;

  /// No description provided for @cleanupConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get cleanupConfirmButton;

  /// No description provided for @cleanupSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'{action} completed'**
  String cleanupSuccessMessage(String action);

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String validationRequired(String field);

  /// No description provided for @validationPositiveNumber.
  ///
  /// In en, this message translates to:
  /// **'{field} must be a positive number'**
  String validationPositiveNumber(String field);

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get aboutAuthor;

  /// No description provided for @aboutAuthorName.
  ///
  /// In en, this message translates to:
  /// **'VibeCode by Ton Truong'**
  String get aboutAuthorName;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// No description provided for @aboutOpenSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get aboutOpenSourceLicenses;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
