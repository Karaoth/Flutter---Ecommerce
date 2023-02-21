import 'package:ecommerce_demo_project/models/costumer.dart';
import 'package:ecommerce_demo_project/view_model/costumer_view_model.dart';
import 'package:ecommerce_demo_project/views/home_page.dart';
import 'package:ecommerce_demo_project/views/register_with_email.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/user_auth.dart';
import '../widgets/buttons_and_textfields.dart';
import 'forgot_password_email.dart';

class SingInEmail extends StatefulWidget {
  const SingInEmail({Key? key}) : super(key: key);

  @override
  State<SingInEmail> createState() => _SingInEmailState();
}

class _SingInEmailState extends State<SingInEmail> {
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orangeAccent),
      body: Center(
        widthFactor: MediaQuery.of(context).size.width * 0.90,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.50,
                height: MediaQuery.of(context).size.height * 0.20,
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
                      TextFormField(
                        decoration: textInputDecoration(
                            labelText: 'Password',
                            icon: const Icon(Icons.password)),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return 'your password cannot be less than 6 characters';
                          } else {
                            return null;
                          }
                        },
                        controller: _password,
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: ElevatedButton(
                          style: myBuildButtonStyle(),
                          onPressed: () async {

                            /// kullanıcının emaili onaylayıp onayladığının kontrolü yapılacak
                            /*
                            if(!(FirebaseAuth.instance.currentUser!.emailVerified)) {

                            }
                             */

                            try{
                              if (_loginKey.currentState!.validate()) {
                                User? user = await Provider.of<UserAuth>(context,
                                    listen: false)
                                    .mySignInWithEmailAndPassword(
                                    email: _email.text,
                                    password: _password.text);

                                print('kullanıcı : ${user?.email}');

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>  const HomePage()));

                              }
                              /// Kod bu bloğa erişmeden error inputlarda işleniyor
                              /// _loginKey.currentState!.validate() koşuluna gelmeden engelleniyor
                            } on FirebaseAuthException catch(error) {
                              print('E-mail ve Şifre ile Giriş Sırasında Hata Meydana Geldi');

                              if(error.code == 'invalid-email') {
                               await _showMyInvalidEmailDialog();
                              }
                            }



                          },
                          child: Text(
                            'GİRİŞ',
                            style: buildTextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterWithEmail(),
                              ));
                        },
                        child: const Text(
                          'Yeni hesap oluşturmak için tıklayın',
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ResetPasswordWithEmail(),
                              ));
                        },
                        child: const Text(
                          'Şifremi unuttum',
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
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

  Future<void> _showMyInvalidEmailDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('HATA!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Girdiğiniz E-mail Adresi Kayıtlı Değil.'),
                SizedBox(height: 10,),
                Text('Lütfen Başka bir E-mail Adresi Deneyin.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ANLADIM'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
