// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'FoodArt';

  @override
  String get welcome => 'Welcome to FoodArt';

  @override
  String get welcomeSubtitle =>
      'Digitize your restaurant menu with AI-powered videos';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get hasAccount => 'Already have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get signOut => 'Sign Out';

  @override
  String get sendMagicLink => 'Send Magic Link';

  @override
  String get checkEmail => 'Check your email for a login link!';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get menu => 'Menu';

  @override
  String get orders => 'Orders';

  @override
  String get tables => 'Tables';

  @override
  String get analytics => 'Analytics';

  @override
  String get settings => 'Settings';

  @override
  String get todaysSales => 'Today\'s Sales';

  @override
  String get activeOrders => 'Active Orders';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String get averageOrderValue => 'Avg. Order Value';

  @override
  String get categories => 'Categories';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get menuItems => 'Menu Items';

  @override
  String get addItem => 'Add Item';

  @override
  String get editItem => 'Edit Item';

  @override
  String get deleteItem => 'Delete Item';

  @override
  String get itemName => 'Item Name';

  @override
  String get itemDescription => 'Description';

  @override
  String get itemPrice => 'Price';

  @override
  String get itemImage => 'Image';

  @override
  String get generateVideo => 'Generate AI Video';

  @override
  String get videoCredits => 'Video Credits';

  @override
  String get videoProcessing => 'Video is being generated...';

  @override
  String get videoReady => 'Video ready!';

  @override
  String get allergens => 'Allergens';

  @override
  String get dietaryTags => 'Dietary Tags';

  @override
  String get vegetarian => 'Vegetarian';

  @override
  String get vegan => 'Vegan';

  @override
  String get glutenFree => 'Gluten-Free';

  @override
  String get halal => 'Halal';

  @override
  String get kosher => 'Kosher';

  @override
  String get spicy => 'Spicy';

  @override
  String get table => 'Table';

  @override
  String get addTable => 'Add Table';

  @override
  String get tableNumber => 'Table Number';

  @override
  String get capacity => 'Capacity';

  @override
  String get generateQR => 'Generate QR Code';

  @override
  String get downloadQR => 'Download QR Code';

  @override
  String get printQR => 'Print QR Code';

  @override
  String get order => 'Order';

  @override
  String orderNumber(int number) {
    return 'Order #$number';
  }

  @override
  String get pending => 'Pending';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get preparing => 'Preparing';

  @override
  String get ready => 'Ready';

  @override
  String get served => 'Served';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String get markReady => 'Mark as Ready';

  @override
  String get markServed => 'Mark as Served';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String get payment => 'Payment';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get paid => 'Paid';

  @override
  String get payWithCard => 'Pay with Card';

  @override
  String get payAtTable => 'Pay at Table';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get tax => 'Tax';

  @override
  String get closeTable => 'Close Table';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get viewMenu => 'View Menu';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get cart => 'Cart';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get orderPlaced => 'Order Placed!';

  @override
  String get orderStatus => 'Order Status';

  @override
  String get specialRequests => 'Special Requests';

  @override
  String get quantity => 'Quantity';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get restaurantName => 'Restaurant Name';

  @override
  String get branch => 'Branch';

  @override
  String get branches => 'Branches';

  @override
  String get addBranch => 'Add Branch';

  @override
  String get subscription => 'Subscription';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get upgradePlan => 'Upgrade Plan';

  @override
  String get starter => 'Starter';

  @override
  String get professional => 'Professional';

  @override
  String get enterprise => 'Enterprise';

  @override
  String get perMonth => '/month';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get retry => 'Retry';

  @override
  String get noResults => 'No results found';

  @override
  String get searchPlaceholder => 'Search...';

  @override
  String get profile => 'Profile';

  @override
  String get account => 'Account';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get help => 'Help & Support';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get orderNotes => 'Order Notes';

  @override
  String get orderNotesHint => 'Add any special instructions for your order...';

  @override
  String get cartEmpty => 'Your Cart is Empty';

  @override
  String get cartEmptyDescription => 'Add some delicious items from the menu';

  @override
  String get browseMenu => 'Browse Menu';

  @override
  String get confirmOrderDescription =>
      'Please confirm you want to place this order';

  @override
  String get confirmAndOrder => 'Confirm & Order';

  @override
  String get placingOrder => 'Placing your order...';

  @override
  String get orderFailed => 'Failed to place order';

  @override
  String get specialRequestsHint => 'E.g., no onions, extra sauce...';

  @override
  String get orderNotFound => 'Order not found';

  @override
  String get orderItems => 'Order Items';

  @override
  String get payAtCounter => 'Pay at Counter';

  @override
  String get newOrder => 'New Order';

  @override
  String get orderPendingMessage =>
      'Your order has been received and is waiting for confirmation.';

  @override
  String get orderConfirmedMessage =>
      'Great! The kitchen has confirmed your order.';

  @override
  String get orderPreparingMessage => 'Your delicious food is being prepared!';

  @override
  String get orderReadyMessage =>
      'Your order is ready! It will be served shortly.';

  @override
  String get orderServedMessage =>
      'Enjoy your meal! Thank you for ordering with us.';

  @override
  String get orderCancelledMessage => 'This order has been cancelled.';

  @override
  String get revenue => 'Revenue';

  @override
  String activeTableCount(int count) {
    return '$count Active';
  }

  @override
  String itemCount(int count) {
    return '$count Items';
  }

  @override
  String get noOrdersToday => 'No orders yet today';

  @override
  String get startProcessingOrders =>
      'Orders will appear here as customers place them';

  @override
  String get allOrdersProcessed => 'All orders have been processed';

  @override
  String get greatWork => 'Great work! Check back for new orders.';

  @override
  String get noTablesYet => 'No tables configured';

  @override
  String get addTablesDescription =>
      'Add tables and generate QR codes for your restaurant';

  @override
  String seats(int count) {
    return '$count seats';
  }

  @override
  String get inactive => 'Inactive';

  @override
  String get branchRequired => 'Please create a branch first to add tables';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get dashboardSubtitle =>
      'Here\'s what\'s happening at your restaurant today.';

  @override
  String get todaysOverview => 'Today\'s Overview';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get recentOrders => 'Recent Orders';

  @override
  String get viewAll => 'View All';

  @override
  String get aiInsights => 'AI Insights';

  @override
  String get aiRecommendations => 'AI Recommendations';

  @override
  String get customers => 'Customers';

  @override
  String get avgRating => 'Avg. Rating';

  @override
  String get tablesOccupied => 'Tables Occupied';

  @override
  String get aiMenuCreator => 'AI Menu Creator';

  @override
  String get newAiMenuCreator => '✨ NEW: AI Menu Creator';

  @override
  String get createMenuInSeconds => 'Create your menu in seconds!';

  @override
  String get uploadMenuDescription =>
      'Upload photos of your existing menu and our AI will:';

  @override
  String get aiFeature1 => '📸 Extract all items & prices automatically';

  @override
  String get aiFeature2 => '🌍 Translate to 8 languages instantly';

  @override
  String get aiFeature3 => '📁 Organize into categories';

  @override
  String get tryAiMenuCreator => 'Try AI Menu Creator';

  @override
  String get aiMenu => 'AI Menu';

  @override
  String get qrCodes => 'QR Codes';

  @override
  String get newStatus => 'New';

  @override
  String trendingDish(String dishName) {
    return 'Your \"$dishName\" is trending! Consider adding similar dishes.';
  }

  @override
  String peakHours(String hours) {
    return 'Peak hours today: $hours. Prepare extra staff.';
  }

  @override
  String noVideosHint(int count) {
    return '$count menu items don\'t have videos. Add videos to increase orders by 25%.';
  }

  @override
  String get staffAndAccess => 'Staff & Access';

  @override
  String get staffMembers => 'Staff Members';

  @override
  String get manageStaffAccounts => 'Manage staff accounts';

  @override
  String get rolesAndPermissions => 'Roles & Permissions';

  @override
  String get configureAccessLevels => 'Configure access levels';

  @override
  String get ordersAndMenu => 'Orders & Menu';

  @override
  String get orderSettings => 'Order Settings';

  @override
  String get notificationsConfirmationMode =>
      'Notifications, confirmation mode';

  @override
  String get menuLanguages => 'Menu Languages';

  @override
  String languagesEnabled(int count) {
    return '$count languages enabled';
  }

  @override
  String get payments => 'Payments';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get stripeConnect => 'Stripe Connect';

  @override
  String get active => 'Active';

  @override
  String get aiVideos => 'AI Videos';

  @override
  String pricePerVideo(String price) {
    return '$price per video';
  }

  @override
  String videosGenerated(int count) {
    return '$count generated';
  }

  @override
  String get pushEmailSms => 'Push, email, SMS';

  @override
  String get faqContactUs => 'FAQ, contact us';

  @override
  String get manageRestaurantLocations => 'Manage restaurant locations';

  @override
  String get requireStaffConfirmation => 'Require Staff Confirmation';

  @override
  String get staffMustConfirmOrders =>
      'Staff must confirm orders before preparing';

  @override
  String get newOrderSound => 'New Order Sound';

  @override
  String get playOrderSound => 'Play sound when new order arrives';

  @override
  String get autoAcceptOrders => 'Auto-accept Orders';

  @override
  String get autoAcceptDescription => 'Automatically accept new orders';

  @override
  String get selectMenuLanguages => 'Select languages available for your menu';

  @override
  String get paymentSettings => 'Payment Settings';

  @override
  String get stripeConnected => 'Stripe Connected';

  @override
  String get paymentsBeingProcessed => 'Payments are being processed';

  @override
  String get platformFee => 'Platform Fee';

  @override
  String get stripeFee => 'Stripe Fee';

  @override
  String get openStripeDashboard => 'Open Stripe Dashboard';

  @override
  String get proPlan => 'Pro Plan';

  @override
  String nextBilling(String date) {
    return 'Next billing: $date';
  }

  @override
  String get planFeatures => 'Plan Features:';

  @override
  String upToBranches(int count) {
    return 'Up to $count branches';
  }

  @override
  String get unlimitedMenuItems => 'Unlimited menu items';

  @override
  String get unlimitedOrders => 'Unlimited orders';

  @override
  String get advancedAnalytics => 'Advanced analytics';

  @override
  String get prioritySupport => 'Priority support';

  @override
  String get changePlan => 'Change Plan';

  @override
  String get signOutConfirmTitle => 'Sign Out';

  @override
  String get signOutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get restaurantProfile => 'Restaurant Profile';

  @override
  String get urlSlug => 'URL Slug';

  @override
  String get description => 'Description';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Address';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get filterOrders => 'Filter Orders';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get byTable => 'By Table';

  @override
  String noOrdersWithStatus(String status) {
    return 'No $status orders';
  }

  @override
  String items(int count) {
    return '$count items';
  }

  @override
  String get reject => 'Reject';

  @override
  String get acceptAndStart => 'Accept & Start';

  @override
  String get markAsReady => 'Mark Ready';

  @override
  String get complete => 'Complete';

  @override
  String get rejectOrder => 'Reject Order';

  @override
  String rejectOrderConfirm(String orderNumber) {
    return 'Are you sure you want to reject order #$orderNumber?';
  }

  @override
  String orderRejected(String orderNumber) {
    return 'Order #$orderNumber rejected';
  }

  @override
  String orderStatusUpdated(String orderNumber) {
    return 'Order #$orderNumber status updated';
  }

  @override
  String get orderDetails => 'Order Details';

  @override
  String note(String note) {
    return 'Note: $note';
  }

  @override
  String get acceptAndStartPreparing => 'Accept & Start Preparing';
}
