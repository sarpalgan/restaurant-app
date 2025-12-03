// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'FoodArt';

  @override
  String get welcome => 'Bienvenue sur FoodArt';

  @override
  String get welcomeSubtitle =>
      'Digitalisez le menu de votre restaurant avec des vidéos générées par IA';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'Inscription';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get noAccount => 'Pas de compte ?';

  @override
  String get hasAccount => 'Déjà un compte ?';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get sendMagicLink => 'Envoyer le lien magique';

  @override
  String get checkEmail => 'Vérifiez votre e-mail pour le lien de connexion !';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get menu => 'Menu';

  @override
  String get orders => 'Commandes';

  @override
  String get tables => 'Tables';

  @override
  String get analytics => 'Analyses';

  @override
  String get settings => 'Paramètres';

  @override
  String get todaysSales => 'Ventes du jour';

  @override
  String get activeOrders => 'Commandes actives';

  @override
  String get totalOrders => 'Total des commandes';

  @override
  String get averageOrderValue => 'Valeur moyenne commande';

  @override
  String get categories => 'Catégories';

  @override
  String get addCategory => 'Ajouter une catégorie';

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get deleteCategory => 'Supprimer la catégorie';

  @override
  String get categoryName => 'Nom de la catégorie';

  @override
  String get menuItems => 'Articles du menu';

  @override
  String get addItem => 'Ajouter un article';

  @override
  String get editItem => 'Modifier l\'article';

  @override
  String get deleteItem => 'Supprimer l\'article';

  @override
  String get itemName => 'Nom de l\'article';

  @override
  String get itemDescription => 'Description';

  @override
  String get itemPrice => 'Prix';

  @override
  String get itemImage => 'Image';

  @override
  String get generateVideo => 'Générer vidéo IA';

  @override
  String get videoCredits => 'Crédits vidéo';

  @override
  String get videoProcessing => 'Vidéo en cours de génération...';

  @override
  String get videoReady => 'Vidéo prête !';

  @override
  String get allergens => 'Allergènes';

  @override
  String get dietaryTags => 'Régimes alimentaires';

  @override
  String get vegetarian => 'Végétarien';

  @override
  String get vegan => 'Végan';

  @override
  String get glutenFree => 'Sans gluten';

  @override
  String get halal => 'Halal';

  @override
  String get kosher => 'Casher';

  @override
  String get spicy => 'Épicé';

  @override
  String get table => 'Table';

  @override
  String get addTable => 'Ajouter une table';

  @override
  String get tableNumber => 'Numéro de table';

  @override
  String get capacity => 'Capacité';

  @override
  String get generateQR => 'Générer le QR code';

  @override
  String get downloadQR => 'Télécharger le QR code';

  @override
  String get printQR => 'Imprimer le QR code';

  @override
  String get order => 'Commande';

  @override
  String orderNumber(int number) {
    return 'Commande #$number';
  }

  @override
  String get pending => 'En attente';

  @override
  String get confirmed => 'Confirmée';

  @override
  String get preparing => 'En préparation';

  @override
  String get ready => 'Prête';

  @override
  String get served => 'Servie';

  @override
  String get completed => 'Terminée';

  @override
  String get cancelled => 'Annulée';

  @override
  String get confirmOrder => 'Confirmer la commande';

  @override
  String get markReady => 'Marquer comme prête';

  @override
  String get markServed => 'Marquer comme servie';

  @override
  String get cancelOrder => 'Annuler la commande';

  @override
  String get payment => 'Paiement';

  @override
  String get unpaid => 'Non payé';

  @override
  String get paid => 'Payé';

  @override
  String get payWithCard => 'Payer par carte';

  @override
  String get payAtTable => 'Payer à table';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get tax => 'TVA';

  @override
  String get closeTable => 'Clôturer la table';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get viewMenu => 'Voir le menu';

  @override
  String get addToCart => 'Ajouter au panier';

  @override
  String get cart => 'Panier';

  @override
  String get emptyCart => 'Votre panier est vide';

  @override
  String get placeOrder => 'Passer la commande';

  @override
  String get orderPlaced => 'Commande passée !';

  @override
  String get orderStatus => 'Statut de la commande';

  @override
  String get specialRequests => 'Demandes spéciales';

  @override
  String get quantity => 'Quantité';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get restaurantName => 'Nom du restaurant';

  @override
  String get branch => 'Succursale';

  @override
  String get branches => 'Succursales';

  @override
  String get addBranch => 'Ajouter une succursale';

  @override
  String get subscription => 'Abonnement';

  @override
  String get currentPlan => 'Plan actuel';

  @override
  String get upgradePlan => 'Mettre à niveau';

  @override
  String get starter => 'Débutant';

  @override
  String get professional => 'Professionnel';

  @override
  String get enterprise => 'Entreprise';

  @override
  String get perMonth => '/mois';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get confirm => 'Confirmer';

  @override
  String get close => 'Fermer';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get done => 'Terminé';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get retry => 'Réessayer';

  @override
  String get noResults => 'Aucun résultat trouvé';

  @override
  String get searchPlaceholder => 'Rechercher...';

  @override
  String get profile => 'Profil';

  @override
  String get account => 'Compte';

  @override
  String get language => 'Langue';

  @override
  String get notifications => 'Notifications';

  @override
  String get help => 'Aide et support';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

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
  String get welcomeBack => 'Bienvenue !';

  @override
  String get dashboardSubtitle =>
      'Voici ce qui se passe dans votre restaurant aujourd\'hui.';

  @override
  String get todaysOverview => 'Aperçu du Jour';

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String get recentOrders => 'Commandes Récentes';

  @override
  String get viewAll => 'Voir Tout';

  @override
  String get aiInsights => 'Analyses IA';

  @override
  String get aiRecommendations => 'Recommandations IA';

  @override
  String get customers => 'Clients';

  @override
  String get avgRating => 'Note Moy.';

  @override
  String get tablesOccupied => 'Tables Occupées';

  @override
  String get aiMenuCreator => 'Créateur de Menu IA';

  @override
  String get newAiMenuCreator => '✨ NOUVEAU : Créateur de Menu IA';

  @override
  String get createMenuInSeconds => 'Créez votre menu en quelques secondes !';

  @override
  String get uploadMenuDescription =>
      'Téléchargez des photos de votre menu existant et notre IA va :';

  @override
  String get aiFeature1 =>
      '📸 Extraire tous les articles et prix automatiquement';

  @override
  String get aiFeature2 => '🌍 Traduire en 8 langues instantanément';

  @override
  String get aiFeature3 => '📁 Organiser en catégories';

  @override
  String get tryAiMenuCreator => 'Essayer le Créateur de Menu IA';

  @override
  String get aiMenu => 'Menu IA';

  @override
  String get qrCodes => 'Codes QR';

  @override
  String get newStatus => 'Nouveau';

  @override
  String trendingDish(String dishName) {
    return 'Votre \"$dishName\" est tendance ! Envisagez d\'ajouter des plats similaires.';
  }

  @override
  String peakHours(String hours) {
    return 'Heures de pointe aujourd\'hui : $hours. Préparez du personnel supplémentaire.';
  }

  @override
  String noVideosHint(int count) {
    return '$count éléments du menu n\'ont pas de vidéos. Ajoutez des vidéos pour augmenter les commandes de 25%.';
  }

  @override
  String get staffAndAccess => 'Personnel et Accès';

  @override
  String get staffMembers => 'Membres du Personnel';

  @override
  String get manageStaffAccounts => 'Gérer les comptes du personnel';

  @override
  String get rolesAndPermissions => 'Rôles et Permissions';

  @override
  String get configureAccessLevels => 'Configurer les niveaux d\'accès';

  @override
  String get ordersAndMenu => 'Commandes et Menu';

  @override
  String get orderSettings => 'Paramètres des Commandes';

  @override
  String get notificationsConfirmationMode =>
      'Notifications, mode confirmation';

  @override
  String get menuLanguages => 'Langues du Menu';

  @override
  String languagesEnabled(int count) {
    return '$count langues activées';
  }

  @override
  String get payments => 'Paiements';

  @override
  String get paymentMethods => 'Méthodes de Paiement';

  @override
  String get stripeConnect => 'Stripe Connect';

  @override
  String get active => 'Actif';

  @override
  String get aiVideos => 'Vidéos IA';

  @override
  String pricePerVideo(String price) {
    return '$price par vidéo';
  }

  @override
  String videosGenerated(int count) {
    return '$count générées';
  }

  @override
  String get pushEmailSms => 'Push, email, SMS';

  @override
  String get faqContactUs => 'FAQ, nous contacter';

  @override
  String get manageRestaurantLocations =>
      'Gérer les emplacements du restaurant';

  @override
  String get requireStaffConfirmation => 'Exiger la Confirmation du Personnel';

  @override
  String get staffMustConfirmOrders =>
      'Le personnel doit confirmer les commandes avant préparation';

  @override
  String get newOrderSound => 'Son Nouvelle Commande';

  @override
  String get playOrderSound =>
      'Jouer un son à l\'arrivée d\'une nouvelle commande';

  @override
  String get autoAcceptOrders => 'Acceptation Automatique';

  @override
  String get autoAcceptDescription =>
      'Accepter automatiquement les nouvelles commandes';

  @override
  String get selectMenuLanguages =>
      'Sélectionnez les langues disponibles pour votre menu';

  @override
  String get paymentSettings => 'Paramètres de Paiement';

  @override
  String get stripeConnected => 'Stripe Connecté';

  @override
  String get paymentsBeingProcessed =>
      'Les paiements sont en cours de traitement';

  @override
  String get platformFee => 'Frais de Plateforme';

  @override
  String get stripeFee => 'Frais Stripe';

  @override
  String get openStripeDashboard => 'Ouvrir le Tableau de Bord Stripe';

  @override
  String get proPlan => 'Plan Pro';

  @override
  String nextBilling(String date) {
    return 'Prochaine facturation : $date';
  }

  @override
  String get planFeatures => 'Fonctionnalités du Plan :';

  @override
  String upToBranches(int count) {
    return 'Jusqu\'à $count succursales';
  }

  @override
  String get unlimitedMenuItems => 'Articles de menu illimités';

  @override
  String get unlimitedOrders => 'Commandes illimitées';

  @override
  String get advancedAnalytics => 'Analyses avancées';

  @override
  String get prioritySupport => 'Support prioritaire';

  @override
  String get changePlan => 'Changer de Plan';

  @override
  String get signOutConfirmTitle => 'Déconnexion';

  @override
  String get signOutConfirmMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get restaurantProfile => 'Profil du Restaurant';

  @override
  String get urlSlug => 'URL Slug';

  @override
  String get description => 'Description';

  @override
  String get phone => 'Téléphone';

  @override
  String get address => 'Adresse';

  @override
  String get saveChanges => 'Enregistrer les Modifications';

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String get filterOrders => 'Filtrer les Commandes';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get thisWeek => 'Cette Semaine';

  @override
  String get byTable => 'Par Table';

  @override
  String noOrdersWithStatus(String status) {
    return 'Pas de commandes $status';
  }

  @override
  String items(int count) {
    return '$count articles';
  }

  @override
  String get reject => 'Refuser';

  @override
  String get acceptAndStart => 'Accepter et Démarrer';

  @override
  String get markAsReady => 'Marquer Prêt';

  @override
  String get complete => 'Terminer';

  @override
  String get rejectOrder => 'Refuser la Commande';

  @override
  String rejectOrderConfirm(String orderNumber) {
    return 'Êtes-vous sûr de vouloir refuser la commande #$orderNumber ?';
  }

  @override
  String orderRejected(String orderNumber) {
    return 'Commande #$orderNumber refusée';
  }

  @override
  String orderStatusUpdated(String orderNumber) {
    return 'Statut de la commande #$orderNumber mis à jour';
  }

  @override
  String get orderDetails => 'Détails de la Commande';

  @override
  String note(String note) {
    return 'Note : $note';
  }

  @override
  String get acceptAndStartPreparing => 'Accepter et Commencer la Préparation';
}
