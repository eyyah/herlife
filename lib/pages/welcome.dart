import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/components/signup_btn.dart'; 
import 'package:myapp/components/arc_painter.dart'; 
import 'package:myapp/components/login_btn.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

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
          CustomPaint(
            painter: ArcPainter(),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('lib/images/logo.png', width: 100),
                    const SizedBox(height: 60),
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 32, 
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 50),
                    SignupButton(
                      onTap: () => context.go('/signup'), 
                      text: 'Create Account',
                    ),
                    const SizedBox(height: 15),
                    LogInButton(
                      onTap: () => context.go('/login'), 
                      text: 'Log In',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
