import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_project/app/modules/auth/controllers/auth_controller.dart';
import 'package:ujikom_project/app/routes/app_pages.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailC = TextEditingController();
    final passwordC = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final rememberMe = false.obs;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(36),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 32),
                  const Center(
                    child: Text(
                      'Selamat Datang Kembali!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      'Masuk untuk melanjutkan ke dashboard',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _fieldLabel('Alamat Email'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                        'admin@healtack.com', Icons.mail_outline),
                    validator: (v) =>
                        v!.isEmpty ? 'Email tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 20),
                  _fieldLabel('Password'),
                  const SizedBox(height: 8),
                  Obx(() => TextFormField(
                        controller: passwordC,
                        obscureText: controller.isPasswordHidden.value,
                        decoration: _inputDecoration(
                          '••••••••',
                          Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(
                              controller.isPasswordHidden.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: controller.isPasswordHidden.toggle,
                          ),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? 'Password tidak boleh kosong' : null,
                      )),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(() => Checkbox(
                                value: rememberMe.value,
                                onChanged: (v) => rememberMe.value = v!,
                                activeColor: const Color(0xFF1565C0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              )),
                          const Text('Ingat Saya',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Lupa Password?',
                            style: TextStyle(
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    controller.login(
                                      emailC.text,
                                      passwordC.text,
                                      onSuccess: () {
                                        emailC.clear();
                                        passwordC.clear();
                                      },
                                    );
                                  }
                                },
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Masuk',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                        ),
                      )),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('atau masuk dengan',
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 13)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(Routes.REGISTER),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Belum punya akun? ',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Daftar Sekarang',
                              style: TextStyle(
                                  color: Color(0xFF1565C0),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.health_and_safety,
                color: Color(0xFF1565C0), size: 24),
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Heal',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E)),
                ),
                TextSpan(
                  text: 'Tack',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A237E)),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF0F4FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
