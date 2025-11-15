import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/components/signup_btn.dart';
import 'package:myapp/components/my_textfield.dart';
import 'package:myapp/components/signup_arc_painter.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dbHelper = DatabaseHelper();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    if (!mounted) return;

    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms of Service.')),
      );
      return;
    }

    final password = _passwordController.text;
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$',
    );

    if (!passwordRegex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must be 8+ chars, contain uppercase, lowercase, and a number.',
          ),
        ),
      );
      return;
    }

    final bytes = utf8.encode(password);
    final hashedPassword = sha256.convert(bytes).toString();

    final user = User(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      middleName: _middleNameController.text,
      phoneNumber: _phoneNumberController.text,
      email: _emailController.text,
      password: hashedPassword,
    );

    try {
      final result = await _dbHelper.saveUser(user);

      if (!mounted) return;

      if (result != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Welcome to Herlife.'),
          ),
        );
        context.go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaHeight =
        MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6A1452), Color(0xFFFFB3AE)],
              ),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: SignupArcPainter())),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => context.go('/welcome'),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(minHeight: safeAreaHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),
                    Image.asset('lib/images/logo.png', width: 100),
                    const SizedBox(height: 30),

                    const Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: 20, // Larger font for emphasis
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // White text for better contrast
                      ),
                    ),

                    const SizedBox(height: 10),

                    _buildTextField('First Name', _firstNameController),
                    const SizedBox(height: 10),
                    _buildTextField('Last Name', _lastNameController),
                    const SizedBox(height: 10),
                    _buildTextField(
                      'Middle Name (Optional)',
                      _middleNameController,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      'Phone Number',
                      _phoneNumberController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      'Email',
                      _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      'Password',
                      _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      'Confirm Password',
                      _confirmPasswordController,
                      obscureText: true,
                    ),

                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _termsAccepted,
                            onChanged: (v) => setState(() {
                              _termsAccepted = v!;
                            }),
                          ),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text: 'I accept the ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        final uri = Uri.parse(
                                          'https://sites.google.com/view/herlifelegal/home',
                                        );
                                        if (!await launchUrl(
                                          uri,
                                          mode: LaunchMode.externalApplication,
                                        )) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Could not open link',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: SignupButton(
                        onTap: _registerUser,
                        text: 'Get Started',
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: MyTextField(
        controller: controller,
        hintText: label.replaceAll(' (Optional)', ''),
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }
}
