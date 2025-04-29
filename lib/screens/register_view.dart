import 'package:eltracker_app/controller/auth_service.dart';
import 'package:eltracker_app/screens/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false;

  Future<void> register() async {
    setState(() => isLoading = true);
    try {
      await authService.value.createAccount(
        email: email.text.trim(), 
        password: password.text.trim(),
      );
      
      // Registration successful - navigate to login or home screen
      if (mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => LoginView()),
        );
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.message}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                hintText: 'Ex@gmail.com',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: password,
              obscureText: true, // Hide password
              decoration: InputDecoration(
                labelText: 'Enter Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : register,
              child: isLoading 
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Register'),
            ),
            TextButton(
              onPressed: isLoading 
                  ? null 
                  : () => Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => LoginView()),
                      ),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}