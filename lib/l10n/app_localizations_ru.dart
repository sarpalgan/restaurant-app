// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'FoodArt';

  @override
  String get welcome => 'Добро пожаловать в FoodArt';

  @override
  String get welcomeSubtitle =>
      'Оцифруйте меню вашего ресторана с помощью видео на базе ИИ';

  @override
  String get login => 'Войти';

  @override
  String get register => 'Регистрация';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get noAccount => 'Нет аккаунта?';

  @override
  String get hasAccount => 'Уже есть аккаунт?';

  @override
  String get signUp => 'Зарегистрироваться';

  @override
  String get signIn => 'Войти';

  @override
  String get signOut => 'Выйти';

  @override
  String get sendMagicLink => 'Отправить ссылку для входа';

  @override
  String get checkEmail => 'Проверьте почту для ссылки входа!';

  @override
  String get dashboard => 'Панель управления';

  @override
  String get menu => 'Меню';

  @override
  String get orders => 'Заказы';

  @override
  String get tables => 'Столы';

  @override
  String get analytics => 'Аналитика';

  @override
  String get settings => 'Настройки';

  @override
  String get todaysSales => 'Продажи сегодня';

  @override
  String get activeOrders => 'Активные заказы';

  @override
  String get totalOrders => 'Всего заказов';

  @override
  String get averageOrderValue => 'Средний чек';

  @override
  String get categories => 'Категории';

  @override
  String get addCategory => 'Добавить категорию';

  @override
  String get editCategory => 'Редактировать категорию';

  @override
  String get deleteCategory => 'Удалить категорию';

  @override
  String get categoryName => 'Название категории';

  @override
  String get menuItems => 'Позиции меню';

  @override
  String get addItem => 'Добавить позицию';

  @override
  String get editItem => 'Редактировать позицию';

  @override
  String get deleteItem => 'Удалить позицию';

  @override
  String get itemName => 'Название';

  @override
  String get itemDescription => 'Описание';

  @override
  String get itemPrice => 'Цена';

  @override
  String get itemImage => 'Изображение';

  @override
  String get generateVideo => 'Создать ИИ-видео';

  @override
  String get videoCredits => 'Видео кредиты';

  @override
  String get videoProcessing => 'Видео создаётся...';

  @override
  String get videoReady => 'Видео готово!';

  @override
  String get allergens => 'Аллергены';

  @override
  String get dietaryTags => 'Диетические метки';

  @override
  String get vegetarian => 'Вегетарианское';

  @override
  String get vegan => 'Веганское';

  @override
  String get glutenFree => 'Без глютена';

  @override
  String get halal => 'Халяль';

  @override
  String get kosher => 'Кошерное';

  @override
  String get spicy => 'Острое';

  @override
  String get table => 'Стол';

  @override
  String get addTable => 'Добавить стол';

  @override
  String get tableNumber => 'Номер стола';

  @override
  String get capacity => 'Вместимость';

  @override
  String get generateQR => 'Создать QR-код';

  @override
  String get downloadQR => 'Скачать QR-код';

  @override
  String get printQR => 'Распечатать QR-код';

  @override
  String get order => 'Заказ';

  @override
  String orderNumber(int number) {
    return 'Заказ #$number';
  }

  @override
  String get pending => 'Ожидает';

  @override
  String get confirmed => 'Подтверждён';

  @override
  String get preparing => 'Готовится';

  @override
  String get ready => 'Готов';

  @override
  String get served => 'Подан';

  @override
  String get completed => 'Завершён';

  @override
  String get cancelled => 'Отменён';

  @override
  String get confirmOrder => 'Подтвердить заказ';

  @override
  String get markReady => 'Отметить готовым';

  @override
  String get markServed => 'Отметить поданным';

  @override
  String get cancelOrder => 'Отменить заказ';

  @override
  String get payment => 'Оплата';

  @override
  String get unpaid => 'Не оплачено';

  @override
  String get paid => 'Оплачено';

  @override
  String get payWithCard => 'Оплатить картой';

  @override
  String get payAtTable => 'Оплатить за столом';

  @override
  String get total => 'Итого';

  @override
  String get subtotal => 'Подытог';

  @override
  String get tax => 'Налог';

  @override
  String get closeTable => 'Закрыть стол';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get viewMenu => 'Просмотреть меню';

  @override
  String get addToCart => 'Добавить в корзину';

  @override
  String get cart => 'Корзина';

  @override
  String get emptyCart => 'Корзина пуста';

  @override
  String get placeOrder => 'Оформить заказ';

  @override
  String get orderPlaced => 'Заказ оформлен!';

  @override
  String get orderStatus => 'Статус заказа';

  @override
  String get specialRequests => 'Особые пожелания';

  @override
  String get quantity => 'Количество';

  @override
  String get restaurant => 'Ресторан';

  @override
  String get restaurantName => 'Название ресторана';

  @override
  String get branch => 'Филиал';

  @override
  String get branches => 'Филиалы';

  @override
  String get addBranch => 'Добавить филиал';

  @override
  String get subscription => 'Подписка';

  @override
  String get currentPlan => 'Текущий план';

  @override
  String get upgradePlan => 'Улучшить план';

  @override
  String get starter => 'Стартовый';

  @override
  String get professional => 'Профессиональный';

  @override
  String get enterprise => 'Корпоративный';

  @override
  String get perMonth => '/месяц';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get close => 'Закрыть';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get done => 'Готово';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String get success => 'Успешно';

  @override
  String get retry => 'Повторить';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String get searchPlaceholder => 'Поиск...';

  @override
  String get profile => 'Профиль';

  @override
  String get account => 'Аккаунт';

  @override
  String get language => 'Язык';

  @override
  String get notifications => 'Уведомления';

  @override
  String get help => 'Помощь и поддержка';

  @override
  String get about => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

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
  String get welcomeBack => 'С возвращением!';

  @override
  String get dashboardSubtitle =>
      'Вот что происходит в вашем ресторане сегодня.';

  @override
  String get todaysOverview => 'Обзор за Сегодня';

  @override
  String get quickActions => 'Быстрые Действия';

  @override
  String get recentOrders => 'Недавние Заказы';

  @override
  String get viewAll => 'Смотреть Все';

  @override
  String get aiInsights => 'Аналитика ИИ';

  @override
  String get aiRecommendations => 'Рекомендации ИИ';

  @override
  String get customers => 'Клиенты';

  @override
  String get avgRating => 'Средний Рейтинг';

  @override
  String get tablesOccupied => 'Занято Столов';

  @override
  String get aiMenuCreator => 'ИИ Создатель Меню';

  @override
  String get newAiMenuCreator => '✨ НОВИНКА: ИИ Создатель Меню';

  @override
  String get createMenuInSeconds => 'Создайте меню за секунды!';

  @override
  String get uploadMenuDescription => 'Загрузите фото вашего меню и наш ИИ:';

  @override
  String get aiFeature1 => '📸 Автоматически извлечёт все позиции и цены';

  @override
  String get aiFeature2 => '🌍 Мгновенно переведёт на 8 языков';

  @override
  String get aiFeature3 => '📁 Организует по категориям';

  @override
  String get tryAiMenuCreator => 'Попробовать ИИ Создатель Меню';

  @override
  String get aiMenu => 'ИИ Меню';

  @override
  String get qrCodes => 'QR-коды';

  @override
  String get newStatus => 'Новый';

  @override
  String trendingDish(String dishName) {
    return 'Ваш \"$dishName\" в тренде! Рассмотрите добавление похожих блюд.';
  }

  @override
  String peakHours(String hours) {
    return 'Часы пик сегодня: $hours. Подготовьте дополнительный персонал.';
  }

  @override
  String noVideosHint(int count) {
    return '$count позиций меню без видео. Добавьте видео, чтобы увеличить заказы на 25%.';
  }

  @override
  String get staffAndAccess => 'Персонал и Доступ';

  @override
  String get staffMembers => 'Сотрудники';

  @override
  String get manageStaffAccounts => 'Управление аккаунтами сотрудников';

  @override
  String get rolesAndPermissions => 'Роли и Права';

  @override
  String get configureAccessLevels => 'Настройка уровней доступа';

  @override
  String get ordersAndMenu => 'Заказы и Меню';

  @override
  String get orderSettings => 'Настройки Заказов';

  @override
  String get notificationsConfirmationMode =>
      'Уведомления, режим подтверждения';

  @override
  String get menuLanguages => 'Языки Меню';

  @override
  String languagesEnabled(int count) {
    return '$count языков включено';
  }

  @override
  String get payments => 'Платежи';

  @override
  String get paymentMethods => 'Способы Оплаты';

  @override
  String get stripeConnect => 'Stripe Connect';

  @override
  String get active => 'Активен';

  @override
  String get aiVideos => 'ИИ-Видео';

  @override
  String pricePerVideo(String price) {
    return '$price за видео';
  }

  @override
  String videosGenerated(int count) {
    return '$count создано';
  }

  @override
  String get pushEmailSms => 'Push, email, SMS';

  @override
  String get faqContactUs => 'FAQ, связаться с нами';

  @override
  String get manageRestaurantLocations =>
      'Управление местоположениями ресторана';

  @override
  String get requireStaffConfirmation => 'Требовать Подтверждение Персонала';

  @override
  String get staffMustConfirmOrders =>
      'Персонал должен подтвердить заказы перед приготовлением';

  @override
  String get newOrderSound => 'Звук Нового Заказа';

  @override
  String get playOrderSound =>
      'Воспроизводить звук при поступлении нового заказа';

  @override
  String get autoAcceptOrders => 'Автоприём Заказов';

  @override
  String get autoAcceptDescription => 'Автоматически принимать новые заказы';

  @override
  String get selectMenuLanguages => 'Выберите языки для вашего меню';

  @override
  String get paymentSettings => 'Настройки Платежей';

  @override
  String get stripeConnected => 'Stripe Подключен';

  @override
  String get paymentsBeingProcessed => 'Платежи обрабатываются';

  @override
  String get platformFee => 'Комиссия Платформы';

  @override
  String get stripeFee => 'Комиссия Stripe';

  @override
  String get openStripeDashboard => 'Открыть Панель Stripe';

  @override
  String get proPlan => 'Pro План';

  @override
  String nextBilling(String date) {
    return 'Следующий платёж: $date';
  }

  @override
  String get planFeatures => 'Возможности Плана:';

  @override
  String upToBranches(int count) {
    return 'До $count филиалов';
  }

  @override
  String get unlimitedMenuItems => 'Неограниченные позиции меню';

  @override
  String get unlimitedOrders => 'Неограниченные заказы';

  @override
  String get advancedAnalytics => 'Расширенная аналитика';

  @override
  String get prioritySupport => 'Приоритетная поддержка';

  @override
  String get changePlan => 'Изменить План';

  @override
  String get signOutConfirmTitle => 'Выход';

  @override
  String get signOutConfirmMessage => 'Вы уверены, что хотите выйти?';

  @override
  String get restaurantProfile => 'Профиль Ресторана';

  @override
  String get urlSlug => 'URL Slug';

  @override
  String get description => 'Описание';

  @override
  String get phone => 'Телефон';

  @override
  String get address => 'Адрес';

  @override
  String get saveChanges => 'Сохранить Изменения';

  @override
  String get profileUpdated => 'Профиль обновлён';

  @override
  String get filterOrders => 'Фильтровать Заказы';

  @override
  String get today => 'Сегодня';

  @override
  String get thisWeek => 'На Этой Неделе';

  @override
  String get byTable => 'По Столику';

  @override
  String noOrdersWithStatus(String status) {
    return 'Нет заказов со статусом $status';
  }

  @override
  String items(int count) {
    return '$count позиций';
  }

  @override
  String get reject => 'Отклонить';

  @override
  String get acceptAndStart => 'Принять и Начать';

  @override
  String get markAsReady => 'Отметить Готовым';

  @override
  String get complete => 'Завершить';

  @override
  String get rejectOrder => 'Отклонить Заказ';

  @override
  String rejectOrderConfirm(String orderNumber) {
    return 'Вы уверены, что хотите отклонить заказ #$orderNumber?';
  }

  @override
  String orderRejected(String orderNumber) {
    return 'Заказ #$orderNumber отклонён';
  }

  @override
  String orderStatusUpdated(String orderNumber) {
    return 'Статус заказа #$orderNumber обновлён';
  }

  @override
  String get orderDetails => 'Детали Заказа';

  @override
  String note(String note) {
    return 'Примечание: $note';
  }

  @override
  String get acceptAndStartPreparing => 'Принять и Начать Приготовление';
}
