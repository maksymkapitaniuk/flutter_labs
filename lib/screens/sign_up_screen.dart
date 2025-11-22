import 'package:flutter/material.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/primary_button.dart';
import '../data/mock_data.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  const CustomTextField(
                    label: "Email",
                    initialValue: MockData.userEmail,
                  ),
                  const CustomTextField(
                    label: "First name",
                    initialValue: "My first name",
                  ),
                  const CustomTextField(
                    label: "Last Name",
                    initialValue: "My last name",
                  ),
                  const CustomTextField(
                    label: "Password",
                    initialValue: "***************",
                    obscureText: true,
                  ),
                  const CustomTextField(
                    label: "Confirm Password",
                    initialValue: "***************",
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: "Sign Up",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
