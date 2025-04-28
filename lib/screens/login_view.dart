import 'package:eltracker_app/home_page.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  var userName = TextEditingController();
  var password = TextEditingController();

  var inputUserName = '';
  var inputPassword = '';

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
              controller: userName,
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

                inputUserName = userName.text;
                inputPassword = password.text;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(username: inputUserName,))
                );

                // ignore: avoid_print
                print('clicked login button');
              }, 
              ),
          ],
        ),
      ),
    );
  }
}