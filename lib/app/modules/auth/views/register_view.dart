import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "DAFTAR AKUN",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Buat akun Healtack",
              style: TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  _buildInput(
                    label: "Nama Lengkap",
                    icon: Icons.person_outline,
                    hint: "Nama lengkap",
                  ),
                  const SizedBox(height: 20),
                  _buildInput(
                    label: "Email",
                    icon: Icons.alternate_email_rounded,
                    hint: "email@healtack.com",
                  ),
                  const SizedBox(height: 20),
                  _buildInput(
                    label: "Password",
                    icon: Icons.lock_outline,
                    hint: "••••••••",
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  _buildInput(
                    label: "Konfirmasi Password",
                    icon: Icons.lock_reset_outlined,
                    hint: "••••••••",
                    isPassword: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[800]!],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: proses register
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  "DAFTAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Sudah punya akun? Login",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.blue[400]),
            filled: true,
            fillColor: const Color(0xFFF8FAFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFE3F2FD)),
            ),
          ),
        ),
      ],
    );
  }
}
