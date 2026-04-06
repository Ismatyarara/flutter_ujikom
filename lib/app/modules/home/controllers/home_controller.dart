import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final _box = GetStorage();

  // ─── User (dari GetStorage hasil login) ───────────────────────────
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userRole = ''.obs;
  final RxString userAvatar = ''.obs;
  final RxString kodePasien = ''.obs;

  // ─── Sidebar ───────────────────────────────────────────────────────
  final RxBool isSidebarOpen = false.obs;
  final RxBool isProfileExpanded = false.obs;
  final RxBool isTokoExpanded = false.obs;
  final RxString activeMenu = 'dashboard'.obs;

  // ─── Bottom Nav ────────────────────────────────────────────────────
  final RxInt bottomNavIndex = 0.obs;

  // ─── Promo Slider ──────────────────────────────────────────────────
  final RxInt currentPromoIndex = 0.obs;
  final List<Map<String, String>> promos = [
    {
      'title': 'Chat Dokter Kulit\nTepercaya',
      'discount': '30%',
      'code': 'PROGRESNYATA'
    },
    {
      'title': 'Konsultasi Umum\nHemat Hari Ini',
      'discount': '20%',
      'code': 'HEALTODAY'
    },
    {
      'title': 'Lab & Vaksinasi\ndi Rumah',
      'discount': '15%',
      'code': 'LABHEMAT'
    },
  ];

  // ─── Quick Menu ────────────────────────────────────────────────────
  final List<Map<String, String>> quickMenus = [
    {'label': 'Chat With\nDoctor', 'route': '/consultation'},
    {'label': 'Health\nStore', 'route': '/toko'},
    {'label': 'Book Offline\nAppointments', 'route': '/appointment'},
    {'label': 'Home Lab &\nVaccinations', 'route': '/lab'},
    {'label': 'My\nInsurance', 'route': '/insurance'},
    {'label': 'Mental\nHealth', 'route': '/mental'},
    {'label': 'Subscription', 'route': '/subscription'},
    {'label': 'See All', 'route': '/all'},
  ];

  // ─── Family Care ───────────────────────────────────────────────────
  final List<Map<String, String>> familyCare = [
    {'label': 'Skin Care'},
    {'label': 'Child Health'},
    {'label': 'Nutrition'},
    {'label': 'Mental Health'},
  ];

  // ─── onInit ────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _startPromoAutoSlide();
  }

  /// Baca data user yang disimpan AuthController saat login
  void _loadUser() {
    final user = _box.read<Map<String, dynamic>>('user');
    if (user != null) {
      userName.value = user['name'] ?? '';
      userEmail.value = user['email'] ?? '';
      userRole.value = user['role'] ?? 'user';
      userAvatar.value = user['avatar'] ?? '';
      kodePasien.value = user['kode_pasien'] ?? '';
    }
  }

  // ─── Sidebar ───────────────────────────────────────────────────────
  void toggleSidebar() => isSidebarOpen.toggle();

  void setActiveMenu(String menu) {
    activeMenu.value = menu;
    if (menu != 'profile') isProfileExpanded.value = false;
    if (menu != 'toko') isTokoExpanded.value = false;
  }

  void toggleProfileMenu() => isProfileExpanded.toggle();
  void toggleTokoMenu() => isTokoExpanded.toggle();

  void onSidebarMenuTap(String route) {
    isSidebarOpen.value = false;
    Get.toNamed(route);
  }

  void onLogout() {
    _box.remove('token');
    _box.remove('user');
    Get.offAllNamed('/login');
  }

  // ─── General ───────────────────────────────────────────────────────
  void setBottomNav(int index) => bottomNavIndex.value = index;
  void setPromoIndex(int index) => currentPromoIndex.value = index;
  void onQuickMenuTap(String route) => Get.toNamed(route);

  void _startPromoAutoSlide() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!isClosed) {
        currentPromoIndex.value = (currentPromoIndex.value + 1) % promos.length;
        _startPromoAutoSlide();
      }
    });
  }
}
