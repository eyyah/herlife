import 'package:flutter/material.dart';
import 'package:myapp/components/arc_painter.dart';
import 'package:myapp/components/my_button.dart';
import 'package:myapp/components/my_textfield.dart';
import 'package:myapp/components/square_tile.dart';
import 'package:myapp/pages/signup_page.dart'; 
import 'package:myapp/services/database_helper.dart';
import 'package:go_router/go_router.dart'; // Import go_router


class LoginPage extends StatelessWidget {
  LoginPage({super.key});



  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final dbHelper = DatabaseHelper();

  void signUserIn(BuildContext context) async {
    final user = await dbHelper.getUser(
      usernameController.text,
      passwordController.text,
    );
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in successful!')),
      );
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
                colors: [
                  Color(0xFF6A1452),
                  Color(0xFFFFB3AE),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 5,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Image.asset(
                'lib/images/arrow.png',
                width: 70,
              ),
            ),
          ),


          
          CustomPaint(
            painter: ArcPainter(),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView( // Added to prevent overflow
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // logo
                      Image.asset(
                        'lib/images/logo.png',
                        width: 100,
                      ),

                      const SizedBox(height: 60),

                      // username textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Username',
                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            MyTextField(
                              controller: usernameController,
                              hintText: 'Username',
                              obscureText: false,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // password textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Password',
                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            MyTextField(
                              controller: passwordController,
                              hintText: 'Password',
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // sign in button
                      MyButton(
                        onTap: () => signUserIn(context), text: 'Sign In',
                      ),

                      const SizedBox(height: 10),

                      // or continue with
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Or',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // google + apple + facebook sign in buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => (context),
                            child: const SquareTile(imagePath: 'lib/images/google.png'),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => (context),
                            child: const SquareTile(imagePath: 'lib/images/apple.png'),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => (context),
                            child: const SquareTile(imagePath: 'lib/images/facebook.png'),
                          ),
                        ],
                      ),


                      // not a member? register now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignupPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.transparent, // Make ripple effect transparent
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Color(0xFF6A1452),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
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
