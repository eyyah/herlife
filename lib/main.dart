import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//intro
import 'package:myapp/pages/splash_screen.dart';
import 'package:myapp/pages/welcome.dart';
//account
import 'package:myapp/pages/signup_page.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/pages/forgetpassword.dart';
//nav
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/pages/notification.dart';
import 'package:myapp/pages/profile_page.dart';
//center
import 'package:myapp/pages/hotlines_page.dart';
import 'package:myapp/pages/quick_tips.dart';
//has
import 'package:myapp/pages/about_us.dart';
import 'package:myapp/pages/demo.dart';
import 'package:myapp/pages/feedback.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(MyApp());
}


final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    //intro
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/welcome', builder: (context, state) => const Welcome()),

    //account
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
    GoRoute(path: '/password', builder: (context, state) => const PasswordPage()),

    //bottom navigator    
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/notification', builder: (context, state) => const NotificationPage()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage(userId: '',)),
    
    //center
    GoRoute(path: '/tips', builder: (context, state) => const QuickTips()),
    GoRoute(path: '/hotline', builder: (context, state) => const HotlinesPage()),

    //help and support  
    GoRoute(path: '/demo', builder: (context, state) => const Demo()),
    GoRoute(path: '/about', builder: (context, state) => const AboutUsPage()),
    GoRoute(path: '/feedback', builder: (context, state) => const FeedbackPage()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Herlife',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
