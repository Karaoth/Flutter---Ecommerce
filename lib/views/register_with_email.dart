import 'package:ecommerce_demo_project/models/costumer.dart';
import 'package:ecommerce_demo_project/views/sign_in_email.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/user_auth.dart';
import '../view_model/costumer_view_model.dart';
import '../widgets/buttons_and_textfields.dart';

class RegisterWithEmail extends StatefulWidget {
  const RegisterWithEmail({Key? key}) : super(key: key);

  @override
  State<RegisterWithEmail> createState() => _RegisterWithEmailState();
}

class _RegisterWithEmailState extends State<RegisterWithEmail> {
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
                  child: Text('REGISTER',
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
                              labelText: 'E-Mail',
                              icon: const Icon(Icons.mail)),
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
                        TextFormField(
                          decoration: textInputDecoration(
                              labelText: 'Passowrd',
                              icon: const Icon(Icons.password)),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                _password.value.text != value) {
                              return 'your password does not match';
                            } else {
                              return null;
                            }
                          },
                          controller: null,
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: ElevatedButton(
                            style: myBuildButtonStyle(),
                            onPressed: () async {
                              try{
                                if (_loginKey.currentState!.validate()) {
                                  User? user = await Provider.of<UserAuth>(
                                      context,
                                      listen: false)
                                      .myCreateUserWithEmailAndPassword(
                                      email: _email.text,
                                      password: _password.text);

                                  /// Buradan FirebaseAuth üzerinden Firestore'a veri çekeceğim.
                                  User? addedUser = FirebaseAuth.instance.currentUser;
                                  print('eklenen kullanıcı: ${addedUser?.email}');
                                  if(addedUser != null) {
                                    Provider.of<CostumerViewModel>(context, listen: false).userAdd(
                                      Costumer(
                                          costumerEmail: _email.text,
                                          costumerId: addedUser.uid.toString(),
                                          adress: '',
                                          displayName: addedUser.displayName.toString(),
                                      ).toJson()
                                    );
                                  }


                                  if (!(user!.emailVerified)) {
                                    await user.sendEmailVerification();
                                  }

                                  await _showMyEmailVerificationDialog();

                                  await Future.delayed(
                                      const Duration(seconds: 45));
                                  await FirebaseAuth.instance.currentUser
                                      ?.reload();
                                  User? user2 = FirebaseAuth.instance.currentUser;
                                  print(
                                      'firebase ile verified: ${FirebaseAuth.instance.currentUser?.emailVerified}');
                                  print(
                                      'user emailVerified after send mail: ${user2?.emailVerified}');
                                }
                              } catch(error) {
                                print('E-mail Kayıt Formunda Hata Yakalandı');
                                print(error);

                                  if(error is FirebaseAuthException)
                                    if(error.code == 'email-already-in-use') {
                                      await _showMyEmailAlreadyInUSeDialog();
                                    }
                              }

                            },
                            child: Text(
                              'KAYDOL',
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
                                  builder: (context) => const SingInEmail(),
                                ));
                          },
                          child: const Text(
                            'Zaten bir hesabım var',
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

  Future<void> _showMyEmailAlreadyInUSeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('HATA!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Girdiğiniz E-mail Adresi Zaten Kullanımda.'),
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

  Future<void> _showMyEmailVerificationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('E-MAİL ADRESİNİZE DOĞRULAMA LİNKİ GÖNDERİLMİŞTİR'),
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
