import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  bool rememberMe = true;

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

                // Welcome Header
                Positioned(
                  top: 151,
                  left: 20,
                  right: 20,
                  child: Text(
                    "Welcome Back\nReady to hit the road.",
                    style: GoogleFonts.roboto(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                ),

                // Form Fields
                Positioned(
                  top: 261,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      _buildTextField(emailController, "Email/Phone Number"),
                      const SizedBox(height: 18),
                      _buildPasswordField(),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                activeColor: Colors.black,
                                onChanged: (val) => setState(() => rememberMe = val!),
                              ),
                              const Text("Remember Me", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password", style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      // Login Button
                      _buildButton("Login", Colors.black, Colors.white, () async {
                        setState(() => isLoading = true);
                        bool success = await Provider.of<AuthProvider>(context, listen: false)
                            .login(emailController.text.trim(), passwordController.text.trim());
                        setState(() => isLoading = false);
                        if (success) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login failed!")));
                        }
                      }),
                      const SizedBox(height: 16),
                      // Sign Up Button
                      _buildOutlineButton("Sign up", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                      }),
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
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: passwordController,
              obscureText: !showPassword,
              decoration: const InputDecoration(hintText: "Password", border: InputBorder.none),
            ),
          ),
          IconButton(
            icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
            onPressed: () => setState(() => showPassword = !showPassword),
          ),
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
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: textCol,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
          elevation: 0,
        ),
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
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}