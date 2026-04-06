import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:ujikom_project/app/utils/api.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const kBlue = Color(0xFF3F51B5);
  static const kBlueSoft = Color(0xFFE8EAF6);
  static const kBg = Color(0xFFF5F7FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Obx(() => Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    _header(),
                    Expanded(child: _body()),
                  ],
                ),
              ),
              if (controller.isSidebarOpen.value) _overlaySidebar(),
              _bottomNav(),
            ],
          )),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: controller.toggleSidebar,
                child: Obx(() => CircleAvatar(
                      radius: 20,
                      backgroundImage: controller.userAvatar.value.isNotEmpty
                          ? NetworkImage(
                              BaseUrl.getImageUrl(controller.userAvatar.value))
                          : null,
                      child: controller.userAvatar.value.isEmpty
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    )),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Good Morning",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                        Text(controller.userName.value,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    )),
              ),
              _notifButton(),
            ],
          ),
          const SizedBox(height: 12),
          _searchBar(),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, size: 18, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notifButton() {
    return Stack(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications, color: Colors.white),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  // ================= BODY =================
  Widget _body() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _quickMenu(),
          const SizedBox(height: 20),
          _promo(),
          const SizedBox(height: 20),
          _familyCare(),
        ],
      ),
    );
  }

  // ================= QUICK MENU =================
  Widget _quickMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.quickMenus.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (_, i) {
          final menu = controller.quickMenus[i];
          return Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 6)
                  ],
                ),
                child: const Icon(Icons.apps, color: kBlue),
              ),
              const SizedBox(height: 6),
              Text(menu['label']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11)),
            ],
          );
        },
      ),
    );
  }

  // ================= PROMO =================
  Widget _promo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text("Ongoing Promos",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.promos.length,
            itemBuilder: (_, i) {
              final promo = controller.promos[i];
              return Container(
                width: 240,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(promo['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text("Hemat ${promo['discount']!}",
                        style: const TextStyle(color: Colors.red)),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  // ================= FAMILY =================
  Widget _familyCare() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(controller.familyCare.length, (i) {
          final item = controller.familyCare[i];
          return Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.favorite, color: kBlue),
                  const SizedBox(height: 6),
                  Text(item['label']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ================= SIDEBAR =================
  Widget _overlaySidebar() {
    return Stack(
      children: [
        GestureDetector(
          onTap: controller.toggleSidebar,
          child: Container(color: Colors.black54),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 250,
            color: Colors.white,
            child: const Center(child: Text("Sidebar Menu")),
          ),
        )
      ],
    );
  }

  // ================= BOTTOM NAV =================
  Widget _bottomNav() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        color: Colors.white,
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (i) {
                return IconButton(
                  icon: Icon(Icons.circle,
                      color: controller.bottomNavIndex.value == i
                          ? kBlue
                          : Colors.grey),
                  onPressed: () => controller.setBottomNav(i),
                );
              }),
            )),
      ),
    );
  }
}
