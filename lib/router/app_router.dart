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

final GoRouter router = GoRouter(
  initialLocation: '/', 
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (BuildContext context, GoRouterState state) => const Welcome(),
    ),

    //acc
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) => const SignupPage(),
    ),
    GoRoute(
      path: '/password',
      builder: (BuildContext context, GoRouterState state) => const PasswordPage(),
    ),



    //bottom navigator
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
    ),
    GoRoute(
      path: '/notification',
      builder: (BuildContext context, GoRouterState state) => const NotificationPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) => const ProfilePage(userId: '',),
    ),
    


    //center
    GoRoute(
      path: '/hotline',
      builder: (BuildContext context, GoRouterState state) => const HotlinesPage(),
    ),
    GoRoute(
      path: '/tips',
      builder: (BuildContext context, GoRouterState state) => const QuickTips(),
    ),



    //help and support
    GoRoute(
      path: '/about',
      builder: (BuildContext context, GoRouterState state) => const AboutUsPage(),
    ),
    GoRoute(
      path: '/demo',
      builder: (BuildContext context, GoRouterState state) => const Demo(),
    ),
    GoRoute(
      path: '/feedback',
      builder: (BuildContext context, GoRouterState state) => const FeedbackPage(),
    ),
  ],
);
