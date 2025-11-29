import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh')
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'FoodArt'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FoodArt'**
  String get welcome;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Digitize your restaurant menu with AI-powered videos'**
  String get welcomeSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get hasAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @sendMagicLink.
  ///
  /// In en, this message translates to:
  /// **'Send Magic Link'**
  String get sendMagicLink;

  /// No description provided for @checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email for a login link!'**
  String get checkEmail;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @tables.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get tables;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @todaysSales.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get todaysSales;

  /// No description provided for @activeOrders.
  ///
  /// In en, this message translates to:
  /// **'Active Orders'**
  String get activeOrders;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// No description provided for @averageOrderValue.
  ///
  /// In en, this message translates to:
  /// **'Avg. Order Value'**
  String get averageOrderValue;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @menuItems.
  ///
  /// In en, this message translates to:
  /// **'Menu Items'**
  String get menuItems;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @itemDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get itemDescription;

  /// No description provided for @itemPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get itemPrice;

  /// No description provided for @itemImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get itemImage;

  /// No description provided for @generateVideo.
  ///
  /// In en, this message translates to:
  /// **'Generate AI Video'**
  String get generateVideo;

  /// No description provided for @videoCredits.
  ///
  /// In en, this message translates to:
  /// **'Video Credits'**
  String get videoCredits;

  /// No description provided for @videoProcessing.
  ///
  /// In en, this message translates to:
  /// **'Video is being generated...'**
  String get videoProcessing;

  /// No description provided for @videoReady.
  ///
  /// In en, this message translates to:
  /// **'Video ready!'**
  String get videoReady;

  /// No description provided for @allergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get allergens;

  /// No description provided for @dietaryTags.
  ///
  /// In en, this message translates to:
  /// **'Dietary Tags'**
  String get dietaryTags;

  /// No description provided for @vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get vegetarian;

  /// No description provided for @vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get vegan;

  /// No description provided for @glutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten-Free'**
  String get glutenFree;

  /// No description provided for @halal.
  ///
  /// In en, this message translates to:
  /// **'Halal'**
  String get halal;

  /// No description provided for @kosher.
  ///
  /// In en, this message translates to:
  /// **'Kosher'**
  String get kosher;

  /// No description provided for @spicy.
  ///
  /// In en, this message translates to:
  /// **'Spicy'**
  String get spicy;

  /// No description provided for @table.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get table;

  /// No description provided for @addTable.
  ///
  /// In en, this message translates to:
  /// **'Add Table'**
  String get addTable;

  /// No description provided for @tableNumber.
  ///
  /// In en, this message translates to:
  /// **'Table Number'**
  String get tableNumber;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @generateQR.
  ///
  /// In en, this message translates to:
  /// **'Generate QR Code'**
  String get generateQR;

  /// No description provided for @downloadQR.
  ///
  /// In en, this message translates to:
  /// **'Download QR Code'**
  String get downloadQR;

  /// No description provided for @printQR.
  ///
  /// In en, this message translates to:
  /// **'Print QR Code'**
  String get printQR;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{number}'**
  String orderNumber(int number);

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get preparing;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @served.
  ///
  /// In en, this message translates to:
  /// **'Served'**
  String get served;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @markReady.
  ///
  /// In en, this message translates to:
  /// **'Mark as Ready'**
  String get markReady;

  /// No description provided for @markServed.
  ///
  /// In en, this message translates to:
  /// **'Mark as Served'**
  String get markServed;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @payWithCard.
  ///
  /// In en, this message translates to:
  /// **'Pay with Card'**
  String get payWithCard;

  /// No description provided for @payAtTable.
  ///
  /// In en, this message translates to:
  /// **'Pay at Table'**
  String get payAtTable;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @closeTable.
  ///
  /// In en, this message translates to:
  /// **'Close Table'**
  String get closeTable;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @viewMenu.
  ///
  /// In en, this message translates to:
  /// **'View Menu'**
  String get viewMenu;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @orderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order Placed!'**
  String get orderPlaced;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatus;

  /// No description provided for @specialRequests.
  ///
  /// In en, this message translates to:
  /// **'Special Requests'**
  String get specialRequests;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurant;

  /// No description provided for @restaurantName.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Name'**
  String get restaurantName;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branches;

  /// No description provided for @addBranch.
  ///
  /// In en, this message translates to:
  /// **'Add Branch'**
  String get addBranch;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @upgradePlan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get upgradePlan;

  /// No description provided for @starter.
  ///
  /// In en, this message translates to:
  /// **'Starter'**
  String get starter;

  /// No description provided for @professional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get professional;

  /// No description provided for @enterprise.
  ///
  /// In en, this message translates to:
  /// **'Enterprise'**
  String get enterprise;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get perMonth;

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

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchPlaceholder;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @orderNotes.
  ///
  /// In en, this message translates to:
  /// **'Order Notes'**
  String get orderNotes;

  /// No description provided for @orderNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any special instructions for your order...'**
  String get orderNotesHint;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your Cart is Empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add some delicious items from the menu'**
  String get cartEmptyDescription;

  /// No description provided for @browseMenu.
  ///
  /// In en, this message translates to:
  /// **'Browse Menu'**
  String get browseMenu;

  /// No description provided for @confirmOrderDescription.
  ///
  /// In en, this message translates to:
  /// **'Please confirm you want to place this order'**
  String get confirmOrderDescription;

  /// No description provided for @confirmAndOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Order'**
  String get confirmAndOrder;

  /// No description provided for @placingOrder.
  ///
  /// In en, this message translates to:
  /// **'Placing your order...'**
  String get placingOrder;

  /// No description provided for @orderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to place order'**
  String get orderFailed;

  /// No description provided for @specialRequestsHint.
  ///
  /// In en, this message translates to:
  /// **'E.g., no onions, extra sauce...'**
  String get specialRequestsHint;

  /// No description provided for @orderNotFound.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get orderNotFound;

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'Order Items'**
  String get orderItems;

  /// No description provided for @payAtCounter.
  ///
  /// In en, this message translates to:
  /// **'Pay at Counter'**
  String get payAtCounter;

  /// No description provided for @newOrder.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get newOrder;

  /// No description provided for @orderPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order has been received and is waiting for confirmation.'**
  String get orderPendingMessage;

  /// No description provided for @orderConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Great! The kitchen has confirmed your order.'**
  String get orderConfirmedMessage;

  /// No description provided for @orderPreparingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your delicious food is being prepared!'**
  String get orderPreparingMessage;

  /// No description provided for @orderReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order is ready! It will be served shortly.'**
  String get orderReadyMessage;

  /// No description provided for @orderServedMessage.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your meal! Thank you for ordering with us.'**
  String get orderServedMessage;

  /// No description provided for @orderCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'This order has been cancelled.'**
  String get orderCancelledMessage;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @activeTableCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Active'**
  String activeTableCount(int count);

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Items'**
  String itemCount(int count);

  /// No description provided for @noOrdersToday.
  ///
  /// In en, this message translates to:
  /// **'No orders yet today'**
  String get noOrdersToday;

  /// No description provided for @startProcessingOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders will appear here as customers place them'**
  String get startProcessingOrders;

  /// No description provided for @allOrdersProcessed.
  ///
  /// In en, this message translates to:
  /// **'All orders have been processed'**
  String get allOrdersProcessed;

  /// No description provided for @greatWork.
  ///
  /// In en, this message translates to:
  /// **'Great work! Check back for new orders.'**
  String get greatWork;

  /// No description provided for @noTablesYet.
  ///
  /// In en, this message translates to:
  /// **'No tables configured'**
  String get noTablesYet;

  /// No description provided for @addTablesDescription.
  ///
  /// In en, this message translates to:
  /// **'Add tables and generate QR codes for your restaurant'**
  String get addTablesDescription;

  /// No description provided for @seats.
  ///
  /// In en, this message translates to:
  /// **'{count} seats'**
  String seats(int count);

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @branchRequired.
  ///
  /// In en, this message translates to:
  /// **'Please create a branch first to add tables'**
  String get branchRequired;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s what\'s happening at your restaurant today.'**
  String get dashboardSubtitle;

  /// No description provided for @todaysOverview.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Overview'**
  String get todaysOverview;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @recentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recentOrders;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @aiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get aiInsights;

  /// No description provided for @aiRecommendations.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendations'**
  String get aiRecommendations;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @avgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg. Rating'**
  String get avgRating;

  /// No description provided for @tablesOccupied.
  ///
  /// In en, this message translates to:
  /// **'Tables Occupied'**
  String get tablesOccupied;

  /// No description provided for @aiMenuCreator.
  ///
  /// In en, this message translates to:
  /// **'AI Menu Creator'**
  String get aiMenuCreator;

  /// No description provided for @newAiMenuCreator.
  ///
  /// In en, this message translates to:
  /// **'✨ NEW: AI Menu Creator'**
  String get newAiMenuCreator;

  /// No description provided for @createMenuInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Create your menu in seconds!'**
  String get createMenuInSeconds;

  /// No description provided for @uploadMenuDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload photos of your existing menu and our AI will:'**
  String get uploadMenuDescription;

  /// No description provided for @aiFeature1.
  ///
  /// In en, this message translates to:
  /// **'📸 Extract all items & prices automatically'**
  String get aiFeature1;

  /// No description provided for @aiFeature2.
  ///
  /// In en, this message translates to:
  /// **'🌍 Translate to 8 languages instantly'**
  String get aiFeature2;

  /// No description provided for @aiFeature3.
  ///
  /// In en, this message translates to:
  /// **'📁 Organize into categories'**
  String get aiFeature3;

  /// No description provided for @tryAiMenuCreator.
  ///
  /// In en, this message translates to:
  /// **'Try AI Menu Creator'**
  String get tryAiMenuCreator;

  /// No description provided for @aiMenu.
  ///
  /// In en, this message translates to:
  /// **'AI Menu'**
  String get aiMenu;

  /// No description provided for @qrCodes.
  ///
  /// In en, this message translates to:
  /// **'QR Codes'**
  String get qrCodes;

  /// No description provided for @newStatus.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newStatus;

  /// No description provided for @trendingDish.
  ///
  /// In en, this message translates to:
  /// **'Your \"{dishName}\" is trending! Consider adding similar dishes.'**
  String trendingDish(String dishName);

  /// No description provided for @peakHours.
  ///
  /// In en, this message translates to:
  /// **'Peak hours today: {hours}. Prepare extra staff.'**
  String peakHours(String hours);

  /// No description provided for @noVideosHint.
  ///
  /// In en, this message translates to:
  /// **'{count} menu items don\'t have videos. Add videos to increase orders by 25%.'**
  String noVideosHint(int count);

  /// No description provided for @staffAndAccess.
  ///
  /// In en, this message translates to:
  /// **'Staff & Access'**
  String get staffAndAccess;

  /// No description provided for @staffMembers.
  ///
  /// In en, this message translates to:
  /// **'Staff Members'**
  String get staffMembers;

  /// No description provided for @manageStaffAccounts.
  ///
  /// In en, this message translates to:
  /// **'Manage staff accounts'**
  String get manageStaffAccounts;

  /// No description provided for @rolesAndPermissions.
  ///
  /// In en, this message translates to:
  /// **'Roles & Permissions'**
  String get rolesAndPermissions;

  /// No description provided for @configureAccessLevels.
  ///
  /// In en, this message translates to:
  /// **'Configure access levels'**
  String get configureAccessLevels;

  /// No description provided for @ordersAndMenu.
  ///
  /// In en, this message translates to:
  /// **'Orders & Menu'**
  String get ordersAndMenu;

  /// No description provided for @orderSettings.
  ///
  /// In en, this message translates to:
  /// **'Order Settings'**
  String get orderSettings;

  /// No description provided for @notificationsConfirmationMode.
  ///
  /// In en, this message translates to:
  /// **'Notifications, confirmation mode'**
  String get notificationsConfirmationMode;

  /// No description provided for @menuLanguages.
  ///
  /// In en, this message translates to:
  /// **'Menu Languages'**
  String get menuLanguages;

  /// No description provided for @languagesEnabled.
  ///
  /// In en, this message translates to:
  /// **'{count} languages enabled'**
  String languagesEnabled(int count);

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @stripeConnect.
  ///
  /// In en, this message translates to:
  /// **'Stripe Connect'**
  String get stripeConnect;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @aiVideos.
  ///
  /// In en, this message translates to:
  /// **'AI Videos'**
  String get aiVideos;

  /// No description provided for @pricePerVideo.
  ///
  /// In en, this message translates to:
  /// **'{price} per video'**
  String pricePerVideo(String price);

  /// No description provided for @videosGenerated.
  ///
  /// In en, this message translates to:
  /// **'{count} generated'**
  String videosGenerated(int count);

  /// No description provided for @pushEmailSms.
  ///
  /// In en, this message translates to:
  /// **'Push, email, SMS'**
  String get pushEmailSms;

  /// No description provided for @faqContactUs.
  ///
  /// In en, this message translates to:
  /// **'FAQ, contact us'**
  String get faqContactUs;

  /// No description provided for @manageRestaurantLocations.
  ///
  /// In en, this message translates to:
  /// **'Manage restaurant locations'**
  String get manageRestaurantLocations;

  /// No description provided for @requireStaffConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Require Staff Confirmation'**
  String get requireStaffConfirmation;

  /// No description provided for @staffMustConfirmOrders.
  ///
  /// In en, this message translates to:
  /// **'Staff must confirm orders before preparing'**
  String get staffMustConfirmOrders;

  /// No description provided for @newOrderSound.
  ///
  /// In en, this message translates to:
  /// **'New Order Sound'**
  String get newOrderSound;

  /// No description provided for @playOrderSound.
  ///
  /// In en, this message translates to:
  /// **'Play sound when new order arrives'**
  String get playOrderSound;

  /// No description provided for @autoAcceptOrders.
  ///
  /// In en, this message translates to:
  /// **'Auto-accept Orders'**
  String get autoAcceptOrders;

  /// No description provided for @autoAcceptDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically accept new orders'**
  String get autoAcceptDescription;

  /// No description provided for @selectMenuLanguages.
  ///
  /// In en, this message translates to:
  /// **'Select languages available for your menu'**
  String get selectMenuLanguages;

  /// No description provided for @paymentSettings.
  ///
  /// In en, this message translates to:
  /// **'Payment Settings'**
  String get paymentSettings;

  /// No description provided for @stripeConnected.
  ///
  /// In en, this message translates to:
  /// **'Stripe Connected'**
  String get stripeConnected;

  /// No description provided for @paymentsBeingProcessed.
  ///
  /// In en, this message translates to:
  /// **'Payments are being processed'**
  String get paymentsBeingProcessed;

  /// No description provided for @platformFee.
  ///
  /// In en, this message translates to:
  /// **'Platform Fee'**
  String get platformFee;

  /// No description provided for @stripeFee.
  ///
  /// In en, this message translates to:
  /// **'Stripe Fee'**
  String get stripeFee;

  /// No description provided for @openStripeDashboard.
  ///
  /// In en, this message translates to:
  /// **'Open Stripe Dashboard'**
  String get openStripeDashboard;

  /// No description provided for @proPlan.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan'**
  String get proPlan;

  /// No description provided for @nextBilling.
  ///
  /// In en, this message translates to:
  /// **'Next billing: {date}'**
  String nextBilling(String date);

  /// No description provided for @planFeatures.
  ///
  /// In en, this message translates to:
  /// **'Plan Features:'**
  String get planFeatures;

  /// No description provided for @upToBranches.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} branches'**
  String upToBranches(int count);

  /// No description provided for @unlimitedMenuItems.
  ///
  /// In en, this message translates to:
  /// **'Unlimited menu items'**
  String get unlimitedMenuItems;

  /// No description provided for @unlimitedOrders.
  ///
  /// In en, this message translates to:
  /// **'Unlimited orders'**
  String get unlimitedOrders;

  /// No description provided for @advancedAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Advanced analytics'**
  String get advancedAnalytics;

  /// No description provided for @prioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority support'**
  String get prioritySupport;

  /// No description provided for @changePlan.
  ///
  /// In en, this message translates to:
  /// **'Change Plan'**
  String get changePlan;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmMessage;

  /// No description provided for @restaurantProfile.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Profile'**
  String get restaurantProfile;

  /// No description provided for @urlSlug.
  ///
  /// In en, this message translates to:
  /// **'URL Slug'**
  String get urlSlug;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'ru',
        'tr',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
