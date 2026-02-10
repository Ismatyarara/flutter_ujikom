import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

// ==================== CONSTANTS ====================
class AppColors {
  static const primaryBlue = Color(0xFF0077C2);
  static const accentPink = Color(0xFFE91E63);
  static const bgGrey = Color(0xFFF8F9FA);
  static const textMain = Color(0xFF2D2D2D);
  static const white = Colors.white;
}

class AppSizes {
  static const double paddingDefault = 16.0;
  static const double paddingSmall = 8.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double iconSize = 26.0;
  static const double categoryIconSize = 56.0;
}

// ==================== MAIN VIEW ====================
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: const _HomeBody(),
    );
  }

  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0.5,
      titleSpacing: 20,
      title: Image.network(
        'https://upload.wikimedia.org/wikipedia/en/thumb/e/e5/Halodoc_Logo.svg/1200px-Halodoc_Logo.svg.png',
        height: 24,
        errorBuilder: (context, error, stackTrace) => const Text(
          'HealthTrack',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout_rounded,
            color: Colors.grey,
            size: 22,
          ),
          onPressed: _showLogoutDialog,
        ),
        const SizedBox(width: AppSizes.paddingSmall),
      ],
    );
  }

  // ==================== LOGOUT DIALOG ====================
  void _showLogoutDialog() {
    Get.defaultDialog(
      title: "Konfirmasi Logout",
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      middleText: "Apakah Anda yakin ingin keluar?",
      contentPadding: const EdgeInsets.all(20),
      radius: 15,
      cancel: OutlinedButton(
        onPressed: () => Get.back(),
        child: const Text("Batal"),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          elevation: 0,
        ),
        onPressed: () {
          Get.back();
          // TODO: Implement logout logic
          // controller.logout();
        },
        child: const Text(
          "Logout",
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }
}

// ==================== HOME BODY ====================
class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SearchBar(),
          const SizedBox(height: AppSizes.paddingDefault),
          const _HealthSolutionsSection(),
          const SizedBox(height: AppSizes.paddingLarge),
          const _PopularCategoriesSection(),
          const SizedBox(height: AppSizes.paddingDefault),
          const _RecommendedProductsSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ==================== SEARCH BAR ====================
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingDefault),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSizes.paddingDefault),
        decoration: BoxDecoration(
          color: AppColors.bgGrey,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.search, color: AppColors.primaryBlue),
            hintText: 'Cari obat, dokter, atau artikel...',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

// ==================== HEALTH SOLUTIONS ====================
class _HealthSolutionsSection extends StatelessWidget {
  const _HealthSolutionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Solusi Kesehatan'),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.paddingDefault),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: const [
              _ServiceCard(
                title: 'Chat Dokter',
                subtitle: 'Tersedia 24 Jam',
                icon: Icons.chat_bubble_outline,
                color: Colors.blue,
              ),
              _ServiceCard(
                title: 'Toko Kesehatan',
                subtitle: 'Produk Original',
                icon: Icons.shopping_bag_outlined,
                color: Colors.red,
              ),
              _ServiceCard(
                title: 'Buat Janji',
                subtitle: 'RS & Klinik',
                icon: Icons.calendar_today_outlined,
                color: Colors.green,
              ),
              _ServiceCard(
                title: 'Layanan Homecare',
                subtitle: 'Tes Lab & Vaksin',
                icon: Icons.home_outlined,
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== POPULAR CATEGORIES ====================
class _PopularCategoriesSection extends StatelessWidget {
  const _PopularCategoriesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Kategori Populer'),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.paddingDefault),
            children: [
              _CircularCategory(
                label: 'Kulit',
                icon: Icons.face_retouching_natural,
                bgColor: Colors.orange.shade50,
                iconColor: Colors.orange,
              ),
              _CircularCategory(
                label: 'Mental',
                icon: Icons.psychology_outlined,
                bgColor: Colors.blue.shade50,
                iconColor: Colors.blue,
              ),
              _CircularCategory(
                label: 'Ibu & Anak',
                icon: Icons.child_care,
                bgColor: Colors.pink.shade50,
                iconColor: Colors.pink,
              ),
              _CircularCategory(
                label: 'Diabetes',
                icon: Icons.bloodtype_outlined,
                bgColor: Colors.red.shade50,
                iconColor: Colors.red,
              ),
              _CircularCategory(
                label: 'Jantung',
                icon: Icons.favorite_border,
                bgColor: Colors.purple.shade50,
                iconColor: Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== RECOMMENDED PRODUCTS ====================
class _RecommendedProductsSection extends StatelessWidget {
  const _RecommendedProductsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingDefault,
            vertical: AppSizes.paddingSmall,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rekomendasi Obat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all products
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: AppColors.accentPink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.paddingDefault),
            children: const [
              _ProductCard(
                name: 'Imunped Drops 15ml',
                price: 'Rp 73.500',
              ),
              _ProductCard(
                name: 'Neurobion Forte',
                price: 'Rp 48.000',
              ),
              _ProductCard(
                name: 'Sangobion 10 Caps',
                price: 'Rp 22.000',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== REUSABLE WIDGETS ====================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingDefault,
        0,
        AppSizes.paddingDefault,
        12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textMain,
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to service
      },
      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: AppSizes.iconSize),
            const SizedBox(width: AppSizes.paddingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularCategory extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _CircularCategory({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category
        },
        borderRadius: BorderRadius.circular(AppSizes.categoryIconSize / 2),
        child: Column(
          children: [
            Container(
              height: AppSizes.categoryIconSize,
              width: AppSizes.categoryIconSize,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final String price;

  const _ProductCard({
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: AppSizes.paddingDefault),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          side: BorderSide(color: Colors.grey.shade100),
        ),
        child: InkWell(
          onTap: () {
            // TODO: Navigate to product detail
          },
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: double.infinity,
                      child: const Icon(
                        Icons.medication,
                        size: 50,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Add to cart
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.accentPink),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Beli',
                      style: TextStyle(
                        color: AppColors.accentPink,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
