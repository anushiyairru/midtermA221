import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import '../../models/user.dart';
import 'mainscreen.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/homescreen.jpg'),
                fit: BoxFit.cover)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                height: 150,
              ),
              Text(
                "HOMESTAY RAYA",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 160, 73, 3)),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "comfort at your tips",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 46, 25, 0)),
              ),
              SizedBox(
                height: 400,
              ),
              Text("Version 1.1b",
                  style: TextStyle(color: Color.fromARGB(255, 241, 145, 19)))
            ]),
      ),
    ));
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String pass = (prefs.getString('pass')) ?? '';
    if (email.isNotEmpty) {
      http.post(Uri.parse("${Config.SERVER}/php/login_user.php"),
          body: {"email": email, "password": pass}).then((response) {
        print(response.body);
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200 && jsonResponse['status'] == "success") {
          User user = User.fromJson(jsonResponse['data']);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: user))));
        } else {
          User user = User(
              id: "0",
              email: "unregistered",
              name: "unregistered",
              address: "na",
              phone: "0123456789",
              regdate: "0");
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: user))));
        }
      });
    } else {
      User user = User(
          id: "0",
          email: "unregistered@email.com",
          name: "unregistered",
          address: "na",
          phone: "0123456789",
          regdate: "0");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
