import 'dart:math';

import 'package:eltracker_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eltracker_app/controller/auth_service.dart';

import 'package:eltracker_app/screens/register_view.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  var email = TextEditingController();
  var password = TextEditingController();

  void login() async {

    try {
        await authService.value.singIn(email: email.text.trim(), password: password.text.trim());

        if (mounted) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context)=>HomePage(username: email.text)),
          );
        }

    } on FirebaseException catch (e) {
          print(e);
    }

  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Login page'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10 , right: 10),
        child: Column(
          children: [
        
            //*user name area
            Text('User Name'),
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Enter Username',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
        
            //* password area 
            Text('Password'),
            TextField(
              controller: password,
              decoration: InputDecoration(
                labelText: 'Enter Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              keyboardType: TextInputType.text,
            ),
            
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                login();
              }, 
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterView()));
                },

                child: Text('Don\'t have an account'),
              ),
          ],
        ),
      ),
    );
  }
}