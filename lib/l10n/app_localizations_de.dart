// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'FoodArt';

  @override
  String get welcome => 'Willkommen bei FoodArt';

  @override
  String get welcomeSubtitle =>
      'Digitalisieren Sie Ihre Speisekarte mit KI-generierten Videos';

  @override
  String get login => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get noAccount => 'Noch kein Konto?';

  @override
  String get hasAccount => 'Bereits ein Konto?';

  @override
  String get signUp => 'Registrieren';

  @override
  String get signIn => 'Anmelden';

  @override
  String get signOut => 'Abmelden';

  @override
  String get sendMagicLink => 'Magic Link senden';

  @override
  String get checkEmail => 'Überprüfen Sie Ihre E-Mail für den Login-Link!';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get menu => 'Speisekarte';

  @override
  String get orders => 'Bestellungen';

  @override
  String get tables => 'Tische';

  @override
  String get analytics => 'Analysen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get todaysSales => 'Heutige Umsätze';

  @override
  String get activeOrders => 'Aktive Bestellungen';

  @override
  String get totalOrders => 'Gesamtbestellungen';

  @override
  String get averageOrderValue => 'Durchschn. Bestellwert';

  @override
  String get categories => 'Kategorien';

  @override
  String get addCategory => 'Kategorie hinzufügen';

  @override
  String get editCategory => 'Kategorie bearbeiten';

  @override
  String get deleteCategory => 'Kategorie löschen';

  @override
  String get categoryName => 'Kategoriename';

  @override
  String get menuItems => 'Menüpunkte';

  @override
  String get addItem => 'Artikel hinzufügen';

  @override
  String get editItem => 'Artikel bearbeiten';

  @override
  String get deleteItem => 'Artikel löschen';

  @override
  String get itemName => 'Artikelname';

  @override
  String get itemDescription => 'Beschreibung';

  @override
  String get itemPrice => 'Preis';

  @override
  String get itemImage => 'Bild';

  @override
  String get generateVideo => 'KI-Video generieren';

  @override
  String get videoCredits => 'Video-Guthaben';

  @override
  String get videoProcessing => 'Video wird generiert...';

  @override
  String get videoReady => 'Video fertig!';

  @override
  String get allergens => 'Allergene';

  @override
  String get dietaryTags => 'Ernährungshinweise';

  @override
  String get vegetarian => 'Vegetarisch';

  @override
  String get vegan => 'Vegan';

  @override
  String get glutenFree => 'Glutenfrei';

  @override
  String get halal => 'Halal';

  @override
  String get kosher => 'Koscher';

  @override
  String get spicy => 'Scharf';

  @override
  String get table => 'Tisch';

  @override
  String get addTable => 'Tisch hinzufügen';

  @override
  String get tableNumber => 'Tischnummer';

  @override
  String get capacity => 'Kapazität';

  @override
  String get generateQR => 'QR-Code generieren';

  @override
  String get downloadQR => 'QR-Code herunterladen';

  @override
  String get printQR => 'QR-Code drucken';

  @override
  String get order => 'Bestellung';

  @override
  String orderNumber(int number) {
    return 'Bestellung #$number';
  }

  @override
  String get pending => 'Ausstehend';

  @override
  String get confirmed => 'Bestätigt';

  @override
  String get preparing => 'In Zubereitung';

  @override
  String get ready => 'Fertig';

  @override
  String get served => 'Serviert';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get cancelled => 'Storniert';

  @override
  String get confirmOrder => 'Bestellung bestätigen';

  @override
  String get markReady => 'Als fertig markieren';

  @override
  String get markServed => 'Als serviert markieren';

  @override
  String get cancelOrder => 'Bestellung stornieren';

  @override
  String get payment => 'Zahlung';

  @override
  String get unpaid => 'Unbezahlt';

  @override
  String get paid => 'Bezahlt';

  @override
  String get payWithCard => 'Mit Karte bezahlen';

  @override
  String get payAtTable => 'Am Tisch bezahlen';

  @override
  String get total => 'Gesamt';

  @override
  String get subtotal => 'Zwischensumme';

  @override
  String get tax => 'MwSt.';

  @override
  String get closeTable => 'Tisch abschließen';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get viewMenu => 'Speisekarte ansehen';

  @override
  String get addToCart => 'In den Warenkorb';

  @override
  String get cart => 'Warenkorb';

  @override
  String get emptyCart => 'Ihr Warenkorb ist leer';

  @override
  String get placeOrder => 'Bestellen';

  @override
  String get orderPlaced => 'Bestellung aufgegeben!';

  @override
  String get orderStatus => 'Bestellstatus';

  @override
  String get specialRequests => 'Besondere Wünsche';

  @override
  String get quantity => 'Menge';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get restaurantName => 'Restaurantname';

  @override
  String get branch => 'Filiale';

  @override
  String get branches => 'Filialen';

  @override
  String get addBranch => 'Filiale hinzufügen';

  @override
  String get subscription => 'Abonnement';

  @override
  String get currentPlan => 'Aktueller Plan';

  @override
  String get upgradePlan => 'Plan upgraden';

  @override
  String get starter => 'Starter';

  @override
  String get professional => 'Professional';

  @override
  String get enterprise => 'Enterprise';

  @override
  String get perMonth => '/Monat';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get close => 'Schließen';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get done => 'Fertig';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get retry => 'Wiederholen';

  @override
  String get noResults => 'Keine Ergebnisse gefunden';

  @override
  String get searchPlaceholder => 'Suchen...';

  @override
  String get profile => 'Profil';

  @override
  String get account => 'Konto';

  @override
  String get language => 'Sprache';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get help => 'Hilfe & Support';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

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
  String get welcomeBack => 'Willkommen zurück!';

  @override
  String get dashboardSubtitle => 'Das passiert heute in Ihrem Restaurant.';

  @override
  String get todaysOverview => 'Heute im Überblick';

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get recentOrders => 'Neueste Bestellungen';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get aiInsights => 'KI-Einblicke';

  @override
  String get aiRecommendations => 'KI-Empfehlungen';

  @override
  String get customers => 'Kunden';

  @override
  String get avgRating => 'Durchschn. Bewertung';

  @override
  String get tablesOccupied => 'Besetzte Tische';

  @override
  String get aiMenuCreator => 'KI-Menü-Ersteller';

  @override
  String get newAiMenuCreator => '✨ NEU: KI-Menü-Ersteller';

  @override
  String get createMenuInSeconds => 'Erstellen Sie Ihr Menü in Sekunden!';

  @override
  String get uploadMenuDescription =>
      'Laden Sie Fotos Ihres bestehenden Menüs hoch und unsere KI wird:';

  @override
  String get aiFeature1 => '📸 Alle Artikel & Preise automatisch extrahieren';

  @override
  String get aiFeature2 => '🌍 Sofort in 8 Sprachen übersetzen';

  @override
  String get aiFeature3 => '📁 In Kategorien organisieren';

  @override
  String get tryAiMenuCreator => 'KI-Menü-Ersteller ausprobieren';

  @override
  String get aiMenu => 'KI-Menü';

  @override
  String get qrCodes => 'QR-Codes';

  @override
  String get newStatus => 'Neu';

  @override
  String trendingDish(String dishName) {
    return 'Ihr \"$dishName\" ist im Trend! Erwägen Sie, ähnliche Gerichte hinzuzufügen.';
  }

  @override
  String peakHours(String hours) {
    return 'Stoßzeiten heute: $hours. Bereiten Sie zusätzliches Personal vor.';
  }

  @override
  String noVideosHint(int count) {
    return '$count Menüpunkte haben keine Videos. Fügen Sie Videos hinzu, um Bestellungen um 25% zu steigern.';
  }

  @override
  String get staffAndAccess => 'Personal & Zugang';

  @override
  String get staffMembers => 'Mitarbeiter';

  @override
  String get manageStaffAccounts => 'Mitarbeiterkonten verwalten';

  @override
  String get rolesAndPermissions => 'Rollen & Berechtigungen';

  @override
  String get configureAccessLevels => 'Zugriffsebenen konfigurieren';

  @override
  String get ordersAndMenu => 'Bestellungen & Menü';

  @override
  String get orderSettings => 'Bestellungseinstellungen';

  @override
  String get notificationsConfirmationMode =>
      'Benachrichtigungen, Bestätigungsmodus';

  @override
  String get menuLanguages => 'Menüsprachen';

  @override
  String languagesEnabled(int count) {
    return '$count Sprachen aktiviert';
  }

  @override
  String get payments => 'Zahlungen';

  @override
  String get paymentMethods => 'Zahlungsmethoden';

  @override
  String get stripeConnect => 'Stripe Connect';

  @override
  String get active => 'Aktiv';

  @override
  String get aiVideos => 'KI-Videos';

  @override
  String pricePerVideo(String price) {
    return '$price pro Video';
  }

  @override
  String videosGenerated(int count) {
    return '$count generiert';
  }

  @override
  String get pushEmailSms => 'Push, E-Mail, SMS';

  @override
  String get faqContactUs => 'FAQ, Kontakt';

  @override
  String get manageRestaurantLocations => 'Restaurantstandorte verwalten';

  @override
  String get requireStaffConfirmation => 'Mitarbeiterbestätigung erforderlich';

  @override
  String get staffMustConfirmOrders =>
      'Mitarbeiter müssen Bestellungen vor der Zubereitung bestätigen';

  @override
  String get newOrderSound => 'Neue Bestellung Ton';

  @override
  String get playOrderSound => 'Ton abspielen bei neuer Bestellung';

  @override
  String get autoAcceptOrders => 'Bestellungen automatisch akzeptieren';

  @override
  String get autoAcceptDescription =>
      'Neue Bestellungen automatisch akzeptieren';

  @override
  String get selectMenuLanguages => 'Wählen Sie Sprachen für Ihr Menü';

  @override
  String get paymentSettings => 'Zahlungseinstellungen';

  @override
  String get stripeConnected => 'Stripe verbunden';

  @override
  String get paymentsBeingProcessed => 'Zahlungen werden verarbeitet';

  @override
  String get platformFee => 'Plattformgebühr';

  @override
  String get stripeFee => 'Stripe-Gebühr';

  @override
  String get openStripeDashboard => 'Stripe-Dashboard öffnen';

  @override
  String get proPlan => 'Pro-Plan';

  @override
  String nextBilling(String date) {
    return 'Nächste Abrechnung: $date';
  }

  @override
  String get planFeatures => 'Plan-Funktionen:';

  @override
  String upToBranches(int count) {
    return 'Bis zu $count Filialen';
  }

  @override
  String get unlimitedMenuItems => 'Unbegrenzte Menüpunkte';

  @override
  String get unlimitedOrders => 'Unbegrenzte Bestellungen';

  @override
  String get advancedAnalytics => 'Erweiterte Analysen';

  @override
  String get prioritySupport => 'Prioritärer Support';

  @override
  String get changePlan => 'Plan ändern';

  @override
  String get signOutConfirmTitle => 'Abmelden';

  @override
  String get signOutConfirmMessage => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get restaurantProfile => 'Restaurantprofil';

  @override
  String get urlSlug => 'URL-Slug';

  @override
  String get description => 'Beschreibung';

  @override
  String get phone => 'Telefon';

  @override
  String get address => 'Adresse';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get profileUpdated => 'Profil aktualisiert';

  @override
  String get filterOrders => 'Bestellungen filtern';

  @override
  String get today => 'Heute';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get byTable => 'Nach Tisch';

  @override
  String noOrdersWithStatus(String status) {
    return 'Keine $status Bestellungen';
  }

  @override
  String items(int count) {
    return '$count Artikel';
  }

  @override
  String get reject => 'Ablehnen';

  @override
  String get acceptAndStart => 'Annehmen & Starten';

  @override
  String get markAsReady => 'Als fertig markieren';

  @override
  String get complete => 'Abschließen';

  @override
  String get rejectOrder => 'Bestellung ablehnen';

  @override
  String rejectOrderConfirm(String orderNumber) {
    return 'Möchten Sie Bestellung #$orderNumber wirklich ablehnen?';
  }

  @override
  String orderRejected(String orderNumber) {
    return 'Bestellung #$orderNumber abgelehnt';
  }

  @override
  String orderStatusUpdated(String orderNumber) {
    return 'Status von Bestellung #$orderNumber aktualisiert';
  }

  @override
  String get orderDetails => 'Bestelldetails';

  @override
  String note(String note) {
    return 'Hinweis: $note';
  }

  @override
  String get acceptAndStartPreparing => 'Annehmen und Zubereitung starten';
}
