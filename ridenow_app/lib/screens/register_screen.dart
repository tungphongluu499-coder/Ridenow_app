import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;

  void handleRegister() async {
    setState(() => isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).register(
        nameCtrl.text.trim(),
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
        "N/A",
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng ký thành công")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lỗi đăng ký!")));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: Stack(
              children: [
                // Back Button (Only show if can pop)
                if (Navigator.canPop(context))
                  Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                // Logo & App Name
                Positioned(
                  top: 54,
                  left: 20,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: const Center(
                          child: Text("R", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "RideNow",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Header
                Positioned(
                  top: 151,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),

                // Fields
                Positioned(
                  top: 226,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      _buildTextField(nameCtrl, "Full Name"),
                      const SizedBox(height: 16),
                      _buildTextField(emailCtrl, "Email Address"),
                      const SizedBox(height: 16),
                      _buildPasswordField(),
                      const SizedBox(height: 16),
                      _buildTextField(countryCtrl, "Country"),
                      const SizedBox(height: 32),
                      _buildButton("Sign up", Colors.black, Colors.white, handleRegister),
                      const SizedBox(height: 16),
                      _buildOutlineButton("Login", () => Navigator.pop(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(controller: ctrl, decoration: InputDecoration(hintText: hint, border: InputBorder.none)),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: TextField(controller: passCtrl, obscureText: !showPassword, decoration: const InputDecoration(hintText: "Password", border: InputBorder.none))),
          IconButton(icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey), onPressed: () => setState(() => showPassword = !showPassword)),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color bg, Color textCol, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: bg, foregroundColor: textCol, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)), elevation: 0),
        child: isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildOutlineButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(foregroundColor: Colors.black, side: const BorderSide(color: Colors.black), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60))),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}