import 'package:ecommerce_demo_project/views/home_page.dart';
import 'package:ecommerce_demo_project/views/sign_in_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/user_auth.dart';

class SingInPage extends StatefulWidget {
  const SingInPage({Key? key}) : super(key: key);

  @override
  State<SingInPage> createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('SIGN IN', textAlign: TextAlign.center),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  User? user =
                      await Provider.of<UserAuth>(context, listen: false)
                          .mysignInAnonymously();
                  print('Anonim id: ${user?.uid}');
                },
                child: const Text('Sign in Anonym'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SingInEmail(),
                      ));
                },
                child: const Text('Sign in E-Mail'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Provider.of<UserAuth>(context, listen: false)
                      .mySignInWithGoogle();
                },
                child: const Text('Sign in Google'),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                  },
                  child: const Text('Return to Home Page'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
