import 'package:ecommerce_demo_project/views/home_page.dart';
import 'package:ecommerce_demo_project/views/register_with_email.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/user_auth.dart';
import '../widgets/buttons_and_textfields.dart';

class ResetPasswordWithEmail extends StatefulWidget {
  const ResetPasswordWithEmail({Key? key}) : super(key: key);

  @override
  State<ResetPasswordWithEmail> createState() => _ResetPasswordWithEmailState();
}

class _ResetPasswordWithEmailState extends State<ResetPasswordWithEmail> {
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orangeAccent),
      body: Center(
        widthFactor: MediaQuery
            .of(context)
            .size
            .width * 0.90,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.50,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.20,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://blog.logrocket.com/wp-content/uploads/2022/08/add-listtile-flutter.png'),
                  ),
                ),
                child: Text('LOGIN',
                    textAlign: TextAlign.center,
                    style: buildTextStyle(color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _loginKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: textInputDecoration(
                            labelText: 'E-Mail', icon: const Icon(Icons.mail)),
                        validator: (value) {
                          if (!EmailValidator.validate(_email.text) ||
                              value == null ||
                              value.isEmpty) {
                            return 'not a valid email address';
                          } else {
                            return null;
                          }
                        },
                        controller: _email,
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.50,
                        child: ElevatedButton(
                          style: myBuildButtonStyle(),
                          onPressed: () async {
                            if (_loginKey.currentState!.validate()) {

                              await Provider.of<UserAuth>(context, listen: false)
                                  .mySendPasswordResetEmail(email: _email.text);

                              await _showMyDialog();

                            }
                          },
                          child: Text(
                            'ŞİFREMİ GÖNDER',
                            style: buildTextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Şifreniz E-mail adresinize gönderimiştir.'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Lütfen E-Mail Adresinizi kontrol ediniz'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ANLADIM'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage(),));
              },
            ),
          ],
        );
      },
    );
  }
}
