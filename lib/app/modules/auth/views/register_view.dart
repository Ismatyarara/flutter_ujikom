import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_project/app/modules/auth/controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  RegisterView({super.key});

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final agreeTerms = false.obs;

  static const _navy = Color(0xFF0C1D3B);
  static const _blue = Color(0xFF1A56DB);
  static const _softBlue = Color(0xFFEBF2FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: Stack(
        children: [
          const _GlowCircle(
            size: 340,
            color: Color(0x381A56DB),
            alignment: Alignment.topRight,
            offset: Offset(120, -120),
          ),
          const _GlowCircle(
            size: 280,
            color: Color(0x241A56DB),
            alignment: Alignment.bottomLeft,
            offset: Offset(-100, 100),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x59000000),
                          blurRadius: 36,
                          offset: Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                            gradient: const LinearGradient(
                              colors: [_blue, Color(0xFF60A5FA), _blue],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _logo(),
                                const SizedBox(height: 24),
                                _stepper(),
                                const SizedBox(height: 24),
                                const Center(
                                  child: Text(
                                    'Buat Akun Baru',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: _navy,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Center(
                                  child: Text(
                                    'Daftar akun baru untuk mengakses dashboard kesehatan',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blueGrey.shade500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 26),
                                _label('Nama Lengkap'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: nameC,
                                  decoration: _inputDecoration(
                                    hint: 'Nama lengkap kamu',
                                    icon: Icons.person_outline_rounded,
                                  ),
                                  validator: (v) => (v == null || v.isEmpty) ? 'Nama tidak boleh kosong' : null,
                                ),
                                const SizedBox(height: 16),
                                _label('Alamat Email'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: emailC,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: _inputDecoration(
                                    hint: 'nama@email.com',
                                    icon: Icons.mail_outline_rounded,
                                  ),
                                  validator: (v) => (v == null || v.isEmpty) ? 'Email tidak boleh kosong' : null,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _label('Password'),
                                          const SizedBox(height: 8),
                                          Obx(
                                            () => TextFormField(
                                              controller: passwordC,
                                              obscureText: controller.isPasswordHidden.value,
                                              decoration: _inputDecoration(
                                                hint: 'Buat password',
                                                icon: Icons.lock_outline_rounded,
                                                suffix: IconButton(
                                                  icon: Icon(
                                                    controller.isPasswordHidden.value
                                                        ? Icons.visibility_off_outlined
                                                        : Icons.visibility_outlined,
                                                    color: Colors.blueGrey.shade300,
                                                  ),
                                                  onPressed: controller.togglePasswordVisibility,
                                                ),
                                              ),
                                              validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _label('Konfirmasi'),
                                          const SizedBox(height: 8),
                                          Obx(
                                            () => TextFormField(
                                              controller: confirmPasswordC,
                                              obscureText: controller.isPasswordHidden.value,
                                              decoration: _inputDecoration(
                                                hint: 'Ulangi password',
                                                icon: Icons.lock_outline_rounded,
                                              ),
                                              validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Obx(
                                  () => Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: agreeTerms.value,
                                        onChanged: (v) => agreeTerms.value = v ?? false,
                                        activeColor: _blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 12),
                                          child: Text.rich(
                                            TextSpan(
                                              text: 'Saya setuju dengan ',
                                              style: TextStyle(
                                                color: Colors.blueGrey.shade500,
                                                height: 1.45,
                                              ),
                                              children: const [
                                                TextSpan(
                                                  text: 'Syarat & Ketentuan',
                                                  style: TextStyle(color: _blue, fontWeight: FontWeight.w700),
                                                ),
                                                TextSpan(text: ' dan '),
                                                TextSpan(
                                                  text: 'Kebijakan Privasi',
                                                  style: TextStyle(color: _blue, fontWeight: FontWeight.w700),
                                                ),
                                                TextSpan(text: ' HealTack'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Obx(
                                  () => SizedBox(
                                    width: double.infinity,
                                    height: 54,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _blue,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
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
                                                if (passwordC.text != confirmPasswordC.text) {
                                                  Get.snackbar(
                                                    'Error',
                                                    'Password tidak cocok',
                                                    backgroundColor: Colors.redAccent,
                                                    colorText: Colors.white,
                                                  );
                                                  return;
                                                }
                                                controller.register(
                                                  nameC.text.trim(),
                                                  emailC.text.trim(),
                                                  passwordC.text,
                                                  confirmPasswordC.text,
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
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.4,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Daftar Sekarang',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                Center(
                                  child: GestureDetector(
                                    onTap: Get.back,
                                    child: const Text.rich(
                                      TextSpan(
                                        text: 'Sudah punya akun? ',
                                        style: TextStyle(color: Colors.black54),
                                        children: [
                                          TextSpan(
                                            text: 'Masuk di sini',
                                            style: TextStyle(color: _blue, fontWeight: FontWeight.w800),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _softBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.health_and_safety_rounded, color: _blue, size: 28),
          ),
          const SizedBox(width: 12),
          const Text.rich(
            TextSpan(
              text: 'Heal',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: _navy),
              children: [
                TextSpan(text: 'Tack', style: TextStyle(color: _blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepper() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepDot('1', active: true),
          Container(width: 56, height: 2, color: const Color(0xFFE2E8F0)),
          _stepDot('2', active: false),
        ],
      ),
    );
  }

  Widget _stepDot(String text, {required bool active}) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: active ? _blue : const Color(0xFFE2E8F0),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.blueGrey.shade300,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF374151)),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.blueGrey.shade300),
      prefixIcon: Icon(icon, color: Colors.blueGrey.shade300, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _blue, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.size,
    required this.color,
    required this.alignment,
    required this.offset,
  });

  final double size;
  final Color color;
  final Alignment alignment;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }
}
