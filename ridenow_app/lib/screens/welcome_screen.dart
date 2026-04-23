import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black, // Dark theme
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.95),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Back Button (Only show if can pop)
          if (Navigator.canPop(context))
            Positioned(
              top: 50,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

          // Stylized "R" Logo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Center(
                    child: Text(
                      "R",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Welcome to",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  "RideNow",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          // Get Started Button
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              height: 62,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(62),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Get Started",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
