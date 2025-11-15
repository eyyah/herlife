import 'package:flutter/material.dart';
import 'package:myapp/components/arc_painter.dart';
import 'package:myapp/components/login_btn.dart';
import 'package:myapp/components/my_textfield.dart';
import 'package:myapp/services/database_helper.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dbHelper = DatabaseHelper();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUserIn() async {
    if (!mounted) return; // Check if the widget is still in the tree

    final user = await _dbHelper.getUser(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return; // Check again after the async operation

    if (user != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sign in successful!')));
      context.go('/home'); // Navigate to home on success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Positioned(
            top: 40,
            left: 5,
            child: GestureDetector(
              onTap: () => context.go('/welcome'),
              child: Image.asset('lib/images/arrow.png', width: 100),
            ),
          ),
          CustomPaint(
            painter: ArcPainter(),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset('lib/images/logo.png', width: 100),
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Username',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            MyTextField(
                              controller: _usernameController,
                              hintText: 'Username',
                              obscureText: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            MyTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      LogInButton(onTap: _signUserIn, text: 'Get Started'),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => context.go('/'),
                        child: const Text(
                          "Forget Password?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
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
}
