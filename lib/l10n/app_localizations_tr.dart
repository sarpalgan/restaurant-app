// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'FoodArt';

  @override
  String get welcome => 'FoodArt\'a Hoş Geldiniz';

  @override
  String get welcomeSubtitle =>
      'Yapay zeka destekli videolarla restoran menünüzü dijitalleştirin';

  @override
  String get login => 'Giriş Yap';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get confirmPassword => 'Şifreyi Onayla';

  @override
  String get forgotPassword => 'Şifremi Unuttum';

  @override
  String get noAccount => 'Hesabınız yok mu?';

  @override
  String get hasAccount => 'Zaten hesabınız var mı?';

  @override
  String get signUp => 'Kayıt Ol';

  @override
  String get signIn => 'Giriş Yap';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get sendMagicLink => 'Giriş Linki Gönder';

  @override
  String get checkEmail => 'Giriş linki için e-postanızı kontrol edin!';

  @override
  String get dashboard => 'Kontrol Paneli';

  @override
  String get menu => 'Menü';

  @override
  String get orders => 'Siparişler';

  @override
  String get tables => 'Masalar';

  @override
  String get analytics => 'Analizler';

  @override
  String get settings => 'Ayarlar';

  @override
  String get todaysSales => 'Bugünkü Satışlar';

  @override
  String get activeOrders => 'Aktif Siparişler';

  @override
  String get totalOrders => 'Toplam Sipariş';

  @override
  String get averageOrderValue => 'Ort. Sipariş Değeri';

  @override
  String get categories => 'Kategoriler';

  @override
  String get addCategory => 'Kategori Ekle';

  @override
  String get editCategory => 'Kategori Düzenle';

  @override
  String get deleteCategory => 'Kategori Sil';

  @override
  String get categoryName => 'Kategori Adı';

  @override
  String get menuItems => 'Menü Öğeleri';

  @override
  String get addItem => 'Öğe Ekle';

  @override
  String get editItem => 'Öğe Düzenle';

  @override
  String get deleteItem => 'Öğe Sil';

  @override
  String get itemName => 'Öğe Adı';

  @override
  String get itemDescription => 'Açıklama';

  @override
  String get itemPrice => 'Fiyat';

  @override
  String get itemImage => 'Görsel';

  @override
  String get generateVideo => 'AI Video Oluştur';

  @override
  String get videoCredits => 'Video Kredileri';

  @override
  String get videoProcessing => 'Video oluşturuluyor...';

  @override
  String get videoReady => 'Video hazır!';

  @override
  String get allergens => 'Alerjenler';

  @override
  String get dietaryTags => 'Diyet Etiketleri';

  @override
  String get vegetarian => 'Vejetaryen';

  @override
  String get vegan => 'Vegan';

  @override
  String get glutenFree => 'Glutensiz';

  @override
  String get halal => 'Helal';

  @override
  String get kosher => 'Koşer';

  @override
  String get spicy => 'Acılı';

  @override
  String get table => 'Masa';

  @override
  String get addTable => 'Masa Ekle';

  @override
  String get tableNumber => 'Masa Numarası';

  @override
  String get capacity => 'Kapasite';

  @override
  String get generateQR => 'QR Kod Oluştur';

  @override
  String get downloadQR => 'QR Kodu İndir';

  @override
  String get printQR => 'QR Kodu Yazdır';

  @override
  String get order => 'Sipariş';

  @override
  String orderNumber(int number) {
    return 'Sipariş #$number';
  }

  @override
  String get pending => 'Beklemede';

  @override
  String get confirmed => 'Onaylandı';

  @override
  String get preparing => 'Hazırlanıyor';

  @override
  String get ready => 'Hazır';

  @override
  String get served => 'Servis Edildi';

  @override
  String get completed => 'Tamamlandı';

  @override
  String get cancelled => 'İptal Edildi';

  @override
  String get confirmOrder => 'Siparişi Onayla';

  @override
  String get markReady => 'Hazır Olarak İşaretle';

  @override
  String get markServed => 'Servis Edildi İşaretle';

  @override
  String get cancelOrder => 'Siparişi İptal Et';

  @override
  String get payment => 'Ödeme';

  @override
  String get unpaid => 'Ödenmedi';

  @override
  String get paid => 'Ödendi';

  @override
  String get payWithCard => 'Kartla Öde';

  @override
  String get payAtTable => 'Masada Öde';

  @override
  String get total => 'Toplam';

  @override
  String get subtotal => 'Ara Toplam';

  @override
  String get tax => 'Vergi';

  @override
  String get closeTable => 'Masayı Kapat';

  @override
  String get selectLanguage => 'Dil Seçin';

  @override
  String get viewMenu => 'Menüyü Görüntüle';

  @override
  String get addToCart => 'Sepete Ekle';

  @override
  String get cart => 'Sepet';

  @override
  String get emptyCart => 'Sepetiniz boş';

  @override
  String get placeOrder => 'Sipariş Ver';

  @override
  String get orderPlaced => 'Sipariş Verildi!';

  @override
  String get orderStatus => 'Sipariş Durumu';

  @override
  String get specialRequests => 'Özel İstekler';

  @override
  String get quantity => 'Miktar';

  @override
  String get restaurant => 'Restoran';

  @override
  String get restaurantName => 'Restoran Adı';

  @override
  String get branch => 'Şube';

  @override
  String get branches => 'Şubeler';

  @override
  String get addBranch => 'Şube Ekle';

  @override
  String get subscription => 'Abonelik';

  @override
  String get currentPlan => 'Mevcut Plan';

  @override
  String get upgradePlan => 'Planı Yükselt';

  @override
  String get starter => 'Başlangıç';

  @override
  String get professional => 'Profesyonel';

  @override
  String get enterprise => 'Kurumsal';

  @override
  String get perMonth => '/ay';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get edit => 'Düzenle';

  @override
  String get confirm => 'Onayla';

  @override
  String get close => 'Kapat';

  @override
  String get back => 'Geri';

  @override
  String get next => 'İleri';

  @override
  String get done => 'Tamam';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get error => 'Hata';

  @override
  String get success => 'Başarılı';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get noResults => 'Sonuç bulunamadı';

  @override
  String get searchPlaceholder => 'Ara...';

  @override
  String get profile => 'Profil';

  @override
  String get account => 'Hesap';

  @override
  String get language => 'Dil';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get help => 'Yardım ve Destek';

  @override
  String get about => 'Hakkında';

  @override
  String get version => 'Sürüm';

  @override
  String get termsOfService => 'Kullanım Koşulları';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

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
  String get welcomeBack => 'Tekrar Hoş Geldiniz!';

  @override
  String get dashboardSubtitle => 'Bugün restoranınızda neler oluyor.';

  @override
  String get todaysOverview => 'Bugünün Özeti';

  @override
  String get quickActions => 'Hızlı İşlemler';

  @override
  String get recentOrders => 'Son Siparişler';

  @override
  String get viewAll => 'Tümünü Gör';

  @override
  String get aiInsights => 'AI Öngörüleri';

  @override
  String get aiRecommendations => 'AI Önerileri';

  @override
  String get customers => 'Müşteriler';

  @override
  String get avgRating => 'Ort. Puan';

  @override
  String get tablesOccupied => 'Dolu Masalar';

  @override
  String get aiMenuCreator => 'AI Menü Oluşturucu';

  @override
  String get newAiMenuCreator => '✨ YENİ: AI Menü Oluşturucu';

  @override
  String get createMenuInSeconds => 'Menünüzü saniyeler içinde oluşturun!';

  @override
  String get uploadMenuDescription =>
      'Mevcut menünüzün fotoğraflarını yükleyin ve AI\'mız:';

  @override
  String get aiFeature1 => '📸 Tüm öğeleri ve fiyatları otomatik çıkaracak';

  @override
  String get aiFeature2 => '🌍 Anında 8 dile çevirecek';

  @override
  String get aiFeature3 => '📁 Kategorilere ayıracak';

  @override
  String get tryAiMenuCreator => 'AI Menü Oluşturucuyu Dene';

  @override
  String get aiMenu => 'AI Menü';

  @override
  String get qrCodes => 'QR Kodları';

  @override
  String get newStatus => 'Yeni';

  @override
  String trendingDish(String dishName) {
    return '\"$dishName\" trend oluyor! Benzer yemekler eklemeyi düşünün.';
  }

  @override
  String peakHours(String hours) {
    return 'Bugün yoğun saatler: $hours. Ekstra personel hazırlayın.';
  }

  @override
  String noVideosHint(int count) {
    return '$count menü öğesinde video yok. Siparişleri %25 artırmak için video ekleyin.';
  }

  @override
  String get staffAndAccess => 'Personel ve Erişim';

  @override
  String get staffMembers => 'Personel Üyeleri';

  @override
  String get manageStaffAccounts => 'Personel hesaplarını yönet';

  @override
  String get rolesAndPermissions => 'Roller ve İzinler';

  @override
  String get configureAccessLevels => 'Erişim seviyelerini yapılandır';

  @override
  String get ordersAndMenu => 'Siparişler ve Menü';

  @override
  String get orderSettings => 'Sipariş Ayarları';

  @override
  String get notificationsConfirmationMode => 'Bildirimler, onay modu';

  @override
  String get menuLanguages => 'Menü Dilleri';

  @override
  String languagesEnabled(int count) {
    return '$count dil etkin';
  }

  @override
  String get payments => 'Ödemeler';

  @override
  String get paymentMethods => 'Ödeme Yöntemleri';

  @override
  String get stripeConnect => 'Stripe Connect';

  @override
  String get active => 'Aktif';

  @override
  String get aiVideos => 'AI Videoları';

  @override
  String pricePerVideo(String price) {
    return 'Video başına $price';
  }

  @override
  String videosGenerated(int count) {
    return '$count oluşturuldu';
  }

  @override
  String get pushEmailSms => 'Push, e-posta, SMS';

  @override
  String get faqContactUs => 'SSS, bize ulaşın';

  @override
  String get manageRestaurantLocations => 'Restoran lokasyonlarını yönet';

  @override
  String get requireStaffConfirmation => 'Personel Onayı Gerekli';

  @override
  String get staffMustConfirmOrders =>
      'Personel hazırlamadan önce siparişleri onaylamalı';

  @override
  String get newOrderSound => 'Yeni Sipariş Sesi';

  @override
  String get playOrderSound => 'Yeni sipariş geldiğinde ses çal';

  @override
  String get autoAcceptOrders => 'Siparişleri Otomatik Kabul Et';

  @override
  String get autoAcceptDescription => 'Yeni siparişleri otomatik kabul et';

  @override
  String get selectMenuLanguages => 'Menünüz için mevcut dilleri seçin';

  @override
  String get paymentSettings => 'Ödeme Ayarları';

  @override
  String get stripeConnected => 'Stripe Bağlı';

  @override
  String get paymentsBeingProcessed => 'Ödemeler işleniyor';

  @override
  String get platformFee => 'Platform Ücreti';

  @override
  String get stripeFee => 'Stripe Ücreti';

  @override
  String get openStripeDashboard => 'Stripe Panelini Aç';

  @override
  String get proPlan => 'Pro Plan';

  @override
  String nextBilling(String date) {
    return 'Sonraki fatura: $date';
  }

  @override
  String get planFeatures => 'Plan Özellikleri:';

  @override
  String upToBranches(int count) {
    return '$count şubeye kadar';
  }

  @override
  String get unlimitedMenuItems => 'Sınırsız menü öğesi';

  @override
  String get unlimitedOrders => 'Sınırsız sipariş';

  @override
  String get advancedAnalytics => 'Gelişmiş analitik';

  @override
  String get prioritySupport => 'Öncelikli destek';

  @override
  String get changePlan => 'Plan Değiştir';

  @override
  String get signOutConfirmTitle => 'Çıkış Yap';

  @override
  String get signOutConfirmMessage =>
      'Çıkış yapmak istediğinizden emin misiniz?';

  @override
  String get restaurantProfile => 'Restoran Profili';

  @override
  String get urlSlug => 'URL Slug';

  @override
  String get description => 'Açıklama';

  @override
  String get phone => 'Telefon';

  @override
  String get address => 'Adres';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get profileUpdated => 'Profil güncellendi';
}
