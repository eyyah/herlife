import 'package:flutter/material.dart';
import 'package:myapp/components/my_button.dart';
import 'package:myapp/components/my_textfield.dart';
import 'package:myapp/components/signup_arc_painter.dart';
//import 'package:myapp/components/square_tile.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/database_helper.dart';
import 'package:sqflite/sqflite.dart'; // Import sqflite

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final dbHelper = DatabaseHelper();

    void registerUser() async {
      if (emailController.text.isEmpty ||
          usernameController.text.isEmpty ||
          passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields.')),
        );
        return;
      }

      final user = User(
        email: emailController.text,
        username: usernameController.text,
        password: passwordController.text, // In a real app, this should be hashed
      );

      try {
        final result = await dbHelper.saveUser(user);
        if (result != 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.pop(context); // Go back to login page
        }
      } on DatabaseException catch (e) {
        if (e.isUniqueConstraintError()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email or username already exists.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background for the top section
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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

          // The white arced container at the bottom
          Positioned.fill(
            child: CustomPaint(
              painter: SignupArcPainter(),
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Form content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100), // Pushes content down into the white area

                    Image.asset(
                      'lib/images/logo.png',
                      width: 100,
                    ),
                    const SizedBox(height: 30),

                    // Email Textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            MyTextField(
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                            ),
                          ],
                        ),
                    ),
                    const SizedBox(height: 20),

                    // Username Textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
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
                    const SizedBox(height: 20),

                    // Password Textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: 
                      Column(
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
                    const SizedBox(height: 35),

                    // Sign Up Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: MyButton(
                        onTap: registerUser,
                        text: 'Sign Up',
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
}
