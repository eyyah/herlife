import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/pages/signup_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/', // Start at the login page
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) => const SignupPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
    ),
  ],
);
