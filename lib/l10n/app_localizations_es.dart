// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'FoodArt';

  @override
  String get welcome => 'Bienvenido a FoodArt';

  @override
  String get welcomeSubtitle =>
      'Digitaliza el menú de tu restaurante con videos impulsados por IA';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get noAccount => '¿No tienes una cuenta?';

  @override
  String get hasAccount => '¿Ya tienes una cuenta?';

  @override
  String get signUp => 'Registrarse';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get sendMagicLink => 'Enviar Enlace Mágico';

  @override
  String get checkEmail =>
      '¡Revisa tu correo para el enlace de inicio de sesión!';

  @override
  String get dashboard => 'Panel de Control';

  @override
  String get menu => 'Menú';

  @override
  String get orders => 'Pedidos';

  @override
  String get tables => 'Mesas';

  @override
  String get analytics => 'Análisis';

  @override
  String get settings => 'Configuración';

  @override
  String get todaysSales => 'Ventas de Hoy';

  @override
  String get activeOrders => 'Pedidos Activos';

  @override
  String get totalOrders => 'Pedidos Totales';

  @override
  String get averageOrderValue => 'Valor Promedio del Pedido';

  @override
  String get categories => 'Categorías';

  @override
  String get addCategory => 'Agregar Categoría';

  @override
  String get editCategory => 'Editar Categoría';

  @override
  String get deleteCategory => 'Eliminar Categoría';

  @override
  String get categoryName => 'Nombre de Categoría';

  @override
  String get menuItems => 'Elementos del Menú';

  @override
  String get addItem => 'Agregar Elemento';

  @override
  String get editItem => 'Editar Elemento';

  @override
  String get deleteItem => 'Eliminar Elemento';

  @override
  String get itemName => 'Nombre del Elemento';

  @override
  String get itemDescription => 'Descripción';

  @override
  String get itemPrice => 'Precio';

  @override
  String get itemImage => 'Imagen';

  @override
  String get generateVideo => 'Generar Video IA';

  @override
  String get videoCredits => 'Créditos de Video';

  @override
  String get videoProcessing => 'Generando video...';

  @override
  String get videoReady => '¡Video listo!';

  @override
  String get allergens => 'Alérgenos';

  @override
  String get dietaryTags => 'Etiquetas Dietéticas';

  @override
  String get vegetarian => 'Vegetariano';

  @override
  String get vegan => 'Vegano';

  @override
  String get glutenFree => 'Sin Gluten';

  @override
  String get halal => 'Halal';

  @override
  String get kosher => 'Kosher';

  @override
  String get spicy => 'Picante';

  @override
  String get table => 'Mesa';

  @override
  String get addTable => 'Agregar Mesa';

  @override
  String get tableNumber => 'Número de Mesa';

  @override
  String get capacity => 'Capacidad';

  @override
  String get generateQR => 'Generar Código QR';

  @override
  String get downloadQR => 'Descargar Código QR';

  @override
  String get printQR => 'Imprimir Código QR';

  @override
  String get order => 'Pedido';

  @override
  String orderNumber(int number) {
    return 'Pedido #$number';
  }

  @override
  String get pending => 'Pendiente';

  @override
  String get confirmed => 'Confirmado';

  @override
  String get preparing => 'Preparando';

  @override
  String get ready => 'Listo';

  @override
  String get served => 'Servido';

  @override
  String get completed => 'Completado';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get confirmOrder => 'Confirmar Pedido';

  @override
  String get markReady => 'Marcar como Listo';

  @override
  String get markServed => 'Marcar como Servido';

  @override
  String get cancelOrder => 'Cancelar Pedido';

  @override
  String get payment => 'Pago';

  @override
  String get unpaid => 'Sin Pagar';

  @override
  String get paid => 'Pagado';

  @override
  String get payWithCard => 'Pagar con Tarjeta';

  @override
  String get payAtTable => 'Pagar en Mesa';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get tax => 'Impuesto';

  @override
  String get closeTable => 'Cerrar Mesa';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get viewMenu => 'Ver Menú';

  @override
  String get addToCart => 'Agregar al Carrito';

  @override
  String get cart => 'Carrito';

  @override
  String get emptyCart => 'Tu carrito está vacío';

  @override
  String get placeOrder => 'Realizar Pedido';

  @override
  String get orderPlaced => '¡Pedido Realizado!';

  @override
  String get orderStatus => 'Estado del Pedido';

  @override
  String get specialRequests => 'Solicitudes Especiales';

  @override
  String get quantity => 'Cantidad';

  @override
  String get restaurant => 'Restaurante';

  @override
  String get restaurantName => 'Nombre del Restaurante';

  @override
  String get branch => 'Sucursal';

  @override
  String get branches => 'Sucursales';

  @override
  String get addBranch => 'Agregar Sucursal';

  @override
  String get subscription => 'Suscripción';

  @override
  String get currentPlan => 'Plan Actual';

  @override
  String get upgradePlan => 'Mejorar Plan';

  @override
  String get starter => 'Inicial';

  @override
  String get professional => 'Profesional';

  @override
  String get enterprise => 'Empresarial';

  @override
  String get perMonth => '/mes';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get done => 'Hecho';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get retry => 'Reintentar';

  @override
  String get noResults => 'No se encontraron resultados';

  @override
  String get searchPlaceholder => 'Buscar...';

  @override
  String get profile => 'Perfil';

  @override
  String get account => 'Cuenta';

  @override
  String get language => 'Idioma';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get help => 'Ayuda y Soporte';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get privacyPolicy => 'Política de Privacidad';

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
  String get welcomeBack => '¡Bienvenido de nuevo!';

  @override
  String get dashboardSubtitle =>
      'Esto es lo que está pasando en tu restaurante hoy.';

  @override
  String get todaysOverview => 'Resumen de Hoy';

  @override
  String get quickActions => 'Acciones Rápidas';

  @override
  String get recentOrders => 'Pedidos Recientes';

  @override
  String get viewAll => 'Ver Todo';

  @override
  String get aiInsights => 'Insights de IA';

  @override
  String get aiRecommendations => 'Recomendaciones de IA';

  @override
  String get customers => 'Clientes';

  @override
  String get avgRating => 'Calificación Prom.';

  @override
  String get tablesOccupied => 'Mesas Ocupadas';

  @override
  String get aiMenuCreator => 'Creador de Menú IA';

  @override
  String get newAiMenuCreator => '✨ NUEVO: Creador de Menú IA';

  @override
  String get createMenuInSeconds => '¡Crea tu menú en segundos!';

  @override
  String get uploadMenuDescription =>
      'Sube fotos de tu menú existente y nuestra IA:';

  @override
  String get aiFeature1 =>
      '📸 Extraerá todos los artículos y precios automáticamente';

  @override
  String get aiFeature2 => '🌍 Traducirá a 8 idiomas al instante';

  @override
  String get aiFeature3 => '📁 Organizará en categorías';

  @override
  String get tryAiMenuCreator => 'Probar Creador de Menú IA';

  @override
  String get aiMenu => 'Menú IA';

  @override
  String get qrCodes => 'Códigos QR';

  @override
  String get newStatus => 'Nuevo';

  @override
  String trendingDish(String dishName) {
    return 'Tu \"$dishName\" está en tendencia. ¡Considera agregar platos similares!';
  }

  @override
  String peakHours(String hours) {
    return 'Horas pico hoy: $hours. Prepara personal adicional.';
  }

  @override
  String noVideosHint(int count) {
    return '$count elementos del menú no tienen videos. Agrega videos para aumentar pedidos en 25%.';
  }

  @override
  String get staffAndAccess => 'Personal y Acceso';

  @override
  String get staffMembers => 'Miembros del Personal';

  @override
  String get manageStaffAccounts => 'Gestionar cuentas de personal';

  @override
  String get rolesAndPermissions => 'Roles y Permisos';

  @override
  String get configureAccessLevels => 'Configurar niveles de acceso';

  @override
  String get ordersAndMenu => 'Pedidos y Menú';

  @override
  String get orderSettings => 'Configuración de Pedidos';

  @override
  String get notificationsConfirmationMode =>
      'Notificaciones, modo confirmación';

  @override
  String get menuLanguages => 'Idiomas del Menú';

  @override
  String languagesEnabled(int count) {
    return '$count idiomas habilitados';
  }

  @override
  String get payments => 'Pagos';

  @override
  String get paymentMethods => 'Métodos de Pago';

  @override
  String get stripeConnect => 'Stripe Connect';

  @override
  String get active => 'Activo';

  @override
  String get aiVideos => 'Videos IA';

  @override
  String pricePerVideo(String price) {
    return '$price por video';
  }

  @override
  String videosGenerated(int count) {
    return '$count generados';
  }

  @override
  String get pushEmailSms => 'Push, email, SMS';

  @override
  String get faqContactUs => 'FAQ, contáctanos';

  @override
  String get manageRestaurantLocations =>
      'Gestionar ubicaciones del restaurante';

  @override
  String get requireStaffConfirmation => 'Requerir Confirmación del Personal';

  @override
  String get staffMustConfirmOrders =>
      'El personal debe confirmar los pedidos antes de prepararlos';

  @override
  String get newOrderSound => 'Sonido de Nuevo Pedido';

  @override
  String get playOrderSound =>
      'Reproducir sonido cuando llegue un nuevo pedido';

  @override
  String get autoAcceptOrders => 'Aceptar Pedidos Automáticamente';

  @override
  String get autoAcceptDescription =>
      'Aceptar automáticamente los nuevos pedidos';

  @override
  String get selectMenuLanguages =>
      'Selecciona los idiomas disponibles para tu menú';

  @override
  String get paymentSettings => 'Configuración de Pagos';

  @override
  String get stripeConnected => 'Stripe Conectado';

  @override
  String get paymentsBeingProcessed => 'Los pagos se están procesando';

  @override
  String get platformFee => 'Comisión de Plataforma';

  @override
  String get stripeFee => 'Comisión de Stripe';

  @override
  String get openStripeDashboard => 'Abrir Panel de Stripe';

  @override
  String get proPlan => 'Plan Pro';

  @override
  String nextBilling(String date) {
    return 'Próxima facturación: $date';
  }

  @override
  String get planFeatures => 'Características del Plan:';

  @override
  String upToBranches(int count) {
    return 'Hasta $count sucursales';
  }

  @override
  String get unlimitedMenuItems => 'Elementos de menú ilimitados';

  @override
  String get unlimitedOrders => 'Pedidos ilimitados';

  @override
  String get advancedAnalytics => 'Analíticas avanzadas';

  @override
  String get prioritySupport => 'Soporte prioritario';

  @override
  String get changePlan => 'Cambiar Plan';

  @override
  String get signOutConfirmTitle => 'Cerrar Sesión';

  @override
  String get signOutConfirmMessage =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get restaurantProfile => 'Perfil del Restaurante';

  @override
  String get urlSlug => 'URL Slug';

  @override
  String get description => 'Descripción';

  @override
  String get phone => 'Teléfono';

  @override
  String get address => 'Dirección';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get filterOrders => 'Filtrar Pedidos';

  @override
  String get today => 'Hoy';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get byTable => 'Por Mesa';

  @override
  String noOrdersWithStatus(String status) {
    return 'No hay pedidos $status';
  }

  @override
  String items(int count) {
    return '$count artículos';
  }

  @override
  String get reject => 'Rechazar';

  @override
  String get acceptAndStart => 'Aceptar e Iniciar';

  @override
  String get markAsReady => 'Marcar Listo';

  @override
  String get complete => 'Completar';

  @override
  String get rejectOrder => 'Rechazar Pedido';

  @override
  String rejectOrderConfirm(String orderNumber) {
    return '¿Estás seguro de que quieres rechazar el pedido #$orderNumber?';
  }

  @override
  String orderRejected(String orderNumber) {
    return 'Pedido #$orderNumber rechazado';
  }

  @override
  String orderStatusUpdated(String orderNumber) {
    return 'Estado del pedido #$orderNumber actualizado';
  }

  @override
  String get orderDetails => 'Detalles del Pedido';

  @override
  String note(String note) {
    return 'Nota: $note';
  }

  @override
  String get acceptAndStartPreparing => 'Aceptar y Comenzar Preparación';
}
