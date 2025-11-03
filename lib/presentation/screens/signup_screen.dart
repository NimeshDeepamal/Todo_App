import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/signup_background.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Text(
                    "ToDoo",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lobster(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 62,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Your To-Do Companion',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(221, 0, 0, 0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 600,
              decoration: BoxDecoration(
                color: const Color.fromARGB(194, 2, 121, 161),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, -10),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 40,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 32,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      TextFormField(decoration: _inputDecoration("Full Name")),
                      const SizedBox(height: 20),

                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration("Email"),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        obscureText: true,
                        decoration: _inputDecoration("Password"),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        obscureText: true,
                        decoration: _inputDecoration("Confirm Password"),
                      ),

                      const SizedBox(height: 40),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            12,
                            45,
                            144,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 140,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: const Color.fromARGB(
                            255,
                            24,
                            152,
                            195,
                          ).withOpacity(0.4),
                          elevation: 6,
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color.fromARGB(221, 235, 235, 235)),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.5),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 9, 45, 74), width: 2),
      ),
      floatingLabelStyle: const TextStyle(
        color: Color.fromARGB(255, 9, 21, 74),
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
