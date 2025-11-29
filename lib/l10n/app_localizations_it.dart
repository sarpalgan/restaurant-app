// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'FoodArt';

  @override
  String get welcome => 'Benvenuto su FoodArt';

  @override
  String get welcomeSubtitle =>
      'Digitalizza il menu del tuo ristorante con video generati dall\'IA';

  @override
  String get login => 'Accedi';

  @override
  String get register => 'Registrati';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Conferma Password';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get noAccount => 'Non hai un account?';

  @override
  String get hasAccount => 'Hai già un account?';

  @override
  String get signUp => 'Registrati';

  @override
  String get signIn => 'Accedi';

  @override
  String get signOut => 'Esci';

  @override
  String get sendMagicLink => 'Invia Link Magico';

  @override
  String get checkEmail => 'Controlla la tua email per il link di accesso!';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get menu => 'Menu';

  @override
  String get orders => 'Ordini';

  @override
  String get tables => 'Tavoli';

  @override
  String get analytics => 'Analisi';

  @override
  String get settings => 'Impostazioni';

  @override
  String get todaysSales => 'Vendite di Oggi';

  @override
  String get activeOrders => 'Ordini Attivi';

  @override
  String get totalOrders => 'Ordini Totali';

  @override
  String get averageOrderValue => 'Valore Medio Ordine';

  @override
  String get categories => 'Categorie';

  @override
  String get addCategory => 'Aggiungi Categoria';

  @override
  String get editCategory => 'Modifica Categoria';

  @override
  String get deleteCategory => 'Elimina Categoria';

  @override
  String get categoryName => 'Nome Categoria';

  @override
  String get menuItems => 'Elementi del Menu';

  @override
  String get addItem => 'Aggiungi Elemento';

  @override
  String get editItem => 'Modifica Elemento';

  @override
  String get deleteItem => 'Elimina Elemento';

  @override
  String get itemName => 'Nome Elemento';

  @override
  String get itemDescription => 'Descrizione';

  @override
  String get itemPrice => 'Prezzo';

  @override
  String get itemImage => 'Immagine';

  @override
  String get generateVideo => 'Genera Video IA';

  @override
  String get videoCredits => 'Crediti Video';

  @override
  String get videoProcessing => 'Video in generazione...';

  @override
  String get videoReady => 'Video pronto!';

  @override
  String get allergens => 'Allergeni';

  @override
  String get dietaryTags => 'Tag Dietetici';

  @override
  String get vegetarian => 'Vegetariano';

  @override
  String get vegan => 'Vegano';

  @override
  String get glutenFree => 'Senza Glutine';

  @override
  String get halal => 'Halal';

  @override
  String get kosher => 'Kosher';

  @override
  String get spicy => 'Piccante';

  @override
  String get table => 'Tavolo';

  @override
  String get addTable => 'Aggiungi Tavolo';

  @override
  String get tableNumber => 'Numero Tavolo';

  @override
  String get capacity => 'Capacità';

  @override
  String get generateQR => 'Genera Codice QR';

  @override
  String get downloadQR => 'Scarica Codice QR';

  @override
  String get printQR => 'Stampa Codice QR';

  @override
  String get order => 'Ordine';

  @override
  String orderNumber(int number) {
    return 'Ordine #$number';
  }

  @override
  String get pending => 'In Attesa';

  @override
  String get confirmed => 'Confermato';

  @override
  String get preparing => 'In Preparazione';

  @override
  String get ready => 'Pronto';

  @override
  String get served => 'Servito';

  @override
  String get completed => 'Completato';

  @override
  String get cancelled => 'Annullato';

  @override
  String get confirmOrder => 'Conferma Ordine';

  @override
  String get markReady => 'Segna come Pronto';

  @override
  String get markServed => 'Segna come Servito';

  @override
  String get cancelOrder => 'Annulla Ordine';

  @override
  String get payment => 'Pagamento';

  @override
  String get unpaid => 'Non Pagato';

  @override
  String get paid => 'Pagato';

  @override
  String get payWithCard => 'Paga con Carta';

  @override
  String get payAtTable => 'Paga al Tavolo';

  @override
  String get total => 'Totale';

  @override
  String get subtotal => 'Subtotale';

  @override
  String get tax => 'IVA';

  @override
  String get closeTable => 'Chiudi Tavolo';

  @override
  String get selectLanguage => 'Seleziona Lingua';

  @override
  String get viewMenu => 'Visualizza Menu';

  @override
  String get addToCart => 'Aggiungi al Carrello';

  @override
  String get cart => 'Carrello';

  @override
  String get emptyCart => 'Il carrello è vuoto';

  @override
  String get placeOrder => 'Effettua Ordine';

  @override
  String get orderPlaced => 'Ordine Effettuato!';

  @override
  String get orderStatus => 'Stato Ordine';

  @override
  String get specialRequests => 'Richieste Speciali';

  @override
  String get quantity => 'Quantità';

  @override
  String get restaurant => 'Ristorante';

  @override
  String get restaurantName => 'Nome Ristorante';

  @override
  String get branch => 'Filiale';

  @override
  String get branches => 'Filiali';

  @override
  String get addBranch => 'Aggiungi Filiale';

  @override
  String get subscription => 'Abbonamento';

  @override
  String get currentPlan => 'Piano Attuale';

  @override
  String get upgradePlan => 'Aggiorna Piano';

  @override
  String get starter => 'Base';

  @override
  String get professional => 'Professionale';

  @override
  String get enterprise => 'Enterprise';

  @override
  String get perMonth => '/mese';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get edit => 'Modifica';

  @override
  String get confirm => 'Conferma';

  @override
  String get close => 'Chiudi';

  @override
  String get back => 'Indietro';

  @override
  String get next => 'Avanti';

  @override
  String get done => 'Fatto';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String get success => 'Successo';

  @override
  String get retry => 'Riprova';

  @override
  String get noResults => 'Nessun risultato trovato';

  @override
  String get searchPlaceholder => 'Cerca...';

  @override
  String get profile => 'Profilo';

  @override
  String get account => 'Account';

  @override
  String get language => 'Lingua';

  @override
  String get notifications => 'Notifiche';

  @override
  String get help => 'Aiuto e Supporto';

  @override
  String get about => 'Informazioni';

  @override
  String get version => 'Versione';

  @override
  String get termsOfService => 'Termini di Servizio';

  @override
  String get privacyPolicy => 'Informativa sulla Privacy';

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
  String get welcomeBack => 'Bentornato!';

  @override
  String get dashboardSubtitle =>
      'Ecco cosa sta succedendo nel tuo ristorante oggi.';

  @override
  String get todaysOverview => 'Panoramica di Oggi';

  @override
  String get quickActions => 'Azioni Rapide';

  @override
  String get recentOrders => 'Ordini Recenti';

  @override
  String get viewAll => 'Vedi Tutto';

  @override
  String get aiInsights => 'Approfondimenti IA';

  @override
  String get aiRecommendations => 'Raccomandazioni IA';

  @override
  String get customers => 'Clienti';

  @override
  String get avgRating => 'Valutazione Media';

  @override
  String get tablesOccupied => 'Tavoli Occupati';

  @override
  String get aiMenuCreator => 'Creatore Menu IA';

  @override
  String get newAiMenuCreator => '✨ NUOVO: Creatore Menu IA';

  @override
  String get createMenuInSeconds => 'Crea il tuo menu in pochi secondi!';

  @override
  String get uploadMenuDescription =>
      'Carica foto del tuo menu esistente e la nostra IA:';

  @override
  String get aiFeature1 =>
      '📸 Estrarrà tutti gli articoli e prezzi automaticamente';

  @override
  String get aiFeature2 => '🌍 Tradurrà in 8 lingue istantaneamente';

  @override
  String get aiFeature3 => '📁 Organizzerà in categorie';

  @override
  String get tryAiMenuCreator => 'Prova il Creatore Menu IA';

  @override
  String get aiMenu => 'Menu IA';

  @override
  String get qrCodes => 'Codici QR';

  @override
  String get newStatus => 'Nuovo';

  @override
  String trendingDish(String dishName) {
    return 'Il tuo \"$dishName\" è di tendenza! Considera di aggiungere piatti simili.';
  }

  @override
  String peakHours(String hours) {
    return 'Ore di punta oggi: $hours. Prepara personale extra.';
  }

  @override
  String noVideosHint(int count) {
    return '$count elementi del menu non hanno video. Aggiungi video per aumentare gli ordini del 25%.';
  }

  @override
  String get staffAndAccess => 'Personale e Accesso';

  @override
  String get staffMembers => 'Membri del Personale';

  @override
  String get manageStaffAccounts => 'Gestisci account del personale';

  @override
  String get rolesAndPermissions => 'Ruoli e Permessi';

  @override
  String get configureAccessLevels => 'Configura livelli di accesso';

  @override
  String get ordersAndMenu => 'Ordini e Menu';

  @override
  String get orderSettings => 'Impostazioni Ordini';

  @override
  String get notificationsConfirmationMode => 'Notifiche, modalità conferma';

  @override
  String get menuLanguages => 'Lingue del Menu';

  @override
  String languagesEnabled(int count) {
    return '$count lingue abilitate';
  }

  @override
  String get payments => 'Pagamenti';

  @override
  String get paymentMethods => 'Metodi di Pagamento';

  @override
  String get stripeConnect => 'Stripe Connect';

  @override
  String get active => 'Attivo';

  @override
  String get aiVideos => 'Video IA';

  @override
  String pricePerVideo(String price) {
    return '$price per video';
  }

  @override
  String videosGenerated(int count) {
    return '$count generati';
  }

  @override
  String get pushEmailSms => 'Push, email, SMS';

  @override
  String get faqContactUs => 'FAQ, contattaci';

  @override
  String get manageRestaurantLocations => 'Gestisci le sedi del ristorante';

  @override
  String get requireStaffConfirmation => 'Richiedi Conferma Personale';

  @override
  String get staffMustConfirmOrders =>
      'Il personale deve confermare gli ordini prima della preparazione';

  @override
  String get newOrderSound => 'Suono Nuovo Ordine';

  @override
  String get playOrderSound => 'Riproduci suono all\'arrivo di un nuovo ordine';

  @override
  String get autoAcceptOrders => 'Accetta Ordini Automaticamente';

  @override
  String get autoAcceptDescription => 'Accetta automaticamente i nuovi ordini';

  @override
  String get selectMenuLanguages =>
      'Seleziona le lingue disponibili per il tuo menu';

  @override
  String get paymentSettings => 'Impostazioni Pagamento';

  @override
  String get stripeConnected => 'Stripe Connesso';

  @override
  String get paymentsBeingProcessed => 'I pagamenti sono in elaborazione';

  @override
  String get platformFee => 'Commissione Piattaforma';

  @override
  String get stripeFee => 'Commissione Stripe';

  @override
  String get openStripeDashboard => 'Apri Dashboard Stripe';

  @override
  String get proPlan => 'Piano Pro';

  @override
  String nextBilling(String date) {
    return 'Prossima fatturazione: $date';
  }

  @override
  String get planFeatures => 'Funzionalità del Piano:';

  @override
  String upToBranches(int count) {
    return 'Fino a $count filiali';
  }

  @override
  String get unlimitedMenuItems => 'Articoli menu illimitati';

  @override
  String get unlimitedOrders => 'Ordini illimitati';

  @override
  String get advancedAnalytics => 'Analisi avanzate';

  @override
  String get prioritySupport => 'Supporto prioritario';

  @override
  String get changePlan => 'Cambia Piano';

  @override
  String get signOutConfirmTitle => 'Esci';

  @override
  String get signOutConfirmMessage => 'Sei sicuro di voler uscire?';

  @override
  String get restaurantProfile => 'Profilo Ristorante';

  @override
  String get urlSlug => 'URL Slug';

  @override
  String get description => 'Descrizione';

  @override
  String get phone => 'Telefono';

  @override
  String get address => 'Indirizzo';

  @override
  String get saveChanges => 'Salva Modifiche';

  @override
  String get profileUpdated => 'Profilo aggiornato';
}
