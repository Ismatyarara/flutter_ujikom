import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_project/app/modules/auth/controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameC = TextEditingController();
    final emailC = TextEditingController();
    final passwordC = TextEditingController();
    final confirmPasswordC = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final agreeTerms = false.obs;

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
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _stepCircle(1, active: true),
                        Container(
                            width: 60, height: 2, color: Colors.grey.shade300),
                        _stepCircle(2, active: false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'Buat Akun Baru',
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
                      'Daftar hanya membutuhkan beberapa langkah',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _fieldLabel('Nama Lengkap'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameC,
                    decoration: _inputDecoration(
                        'Nama lengkap kamu', Icons.person_outline),
                    validator: (v) =>
                        v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  _fieldLabel('Alamat Email'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        _inputDecoration('nama@email.com', Icons.mail_outline),
                    validator: (v) =>
                        v!.isEmpty ? 'Email tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('Password'),
                            const SizedBox(height: 8),
                            Obx(() => TextFormField(
                                  controller: passwordC,
                                  obscureText:
                                      controller.isPasswordHidden.value,
                                  decoration: _inputDecoration(
                                      '••••••••', Icons.lock_outline),
                                  validator: (v) =>
                                      v!.isEmpty ? 'Wajib diisi' : null,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('Konfirmasi'),
                            const SizedBox(height: 8),
                            Obx(() => TextFormField(
                                  controller: confirmPasswordC,
                                  obscureText:
                                      controller.isPasswordHidden.value,
                                  decoration: _inputDecoration(
                                      '••••••••', Icons.lock_outline),
                                  validator: (v) =>
                                      v!.isEmpty ? 'Wajib diisi' : null,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: agreeTerms.value,
                            onChanged: (v) => agreeTerms.value = v!,
                            activeColor: const Color(0xFF1565C0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Saya setuju dengan ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text: 'Syarat & Ketentuan',
                                      style: TextStyle(
                                          color: Color(0xFF1565C0),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(text: ' dan '),
                                    TextSpan(
                                      text: 'Kebijakan Privasi',
                                      style: TextStyle(
                                          color: Color(0xFF1565C0),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(text: ' HealTack'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
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
                                  if (!agreeTerms.value) {
                                    Get.snackbar(
                                      'Peringatan',
                                      'Harap setujui syarat & ketentuan',
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }
                                  if (formKey.currentState!.validate()) {
                                    if (passwordC.text !=
                                        confirmPasswordC.text) {
                                      Get.snackbar(
                                        'Error',
                                        'Password tidak cocok',
                                        backgroundColor: Colors.redAccent,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }
                                    controller.register(
                                      nameC.text,
                                      emailC.text,
                                      passwordC.text,
                                      onSuccess: () {
                                        nameC.clear();
                                        emailC.clear();
                                        passwordC.clear();
                                        confirmPasswordC.clear();
                                        agreeTerms.value = false;
                                      },
                                    );
                                  }
                                },
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Buat Akun',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                        ),
                      )),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Sudah punya akun? ',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Login Sekarang',
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

  Widget _stepCircle(int step, {required bool active}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF1565C0) : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$step',
        style: TextStyle(
          color: active ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
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

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
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
