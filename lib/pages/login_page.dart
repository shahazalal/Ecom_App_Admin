import 'package:ecomerse_app/auth/firebase_auth_service.dart';
import 'package:ecomerse_app/utils/constant.dart';
import 'package:flutter/material.dart';

import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isPassVisible = true;
  String errMsg = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome Admin',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email), labelText: 'Email Adress'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return emptyTextFieldMsg;
                  }
                },
                onSaved: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: isPassVisible,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(isPassVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isPassVisible = !isPassVisible;
                        });
                      },
                    ),
                    labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return emptyTextFieldMsg;
                  }
                },
                onSaved: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: Text('Login'),
                onPressed: _loginAdmin,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                errMsg,
                style: TextStyle(fontSize: 18, color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loginAdmin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    try {
      final user = await FirebaseAuthService.loginAdmin(email!, password!);
      if (user != null) {
        final status = await FirebaseAuthService.isAdminValid(user.uid);
        if (status) {
          Navigator.pushReplacementNamed(context, DashboardPage.routeName);
        } else {
          setState(() {
            errMsg = 'you are not an admin';
          });
        }
        // Navigator.pushReplacementNamed(context, DashboardPage.routeName);
      }
    } catch (error) {
      setState(() {
        errMsg = error.toString();
      });
    }
  }
}
