import 'package:ecomerse_app/auth/firebase_auth_service.dart';
import 'package:ecomerse_app/pages/dashboard_page.dart';
import 'package:ecomerse_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class LauncherPage extends StatefulWidget {
  static final String routeName = '/launcher';
  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void didChangeDependencies() {
    Future.delayed(Duration.zero, () {
      if (FirebaseAuthService.currentUser == null) {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, DashboardPage.routeName);
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
