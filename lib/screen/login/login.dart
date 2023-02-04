import 'package:cek_grammer_plagiat/firebase/auth/auth.dart';
import 'package:cek_grammer_plagiat/screen/dashboard/dasboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginWidget();
}

class LoginWidget extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  bool passHide = true;
  bool isSigningIn = false;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (kDebugMode) {
          print('User is currently signed out!');
        }
      } else {
        if (kDebugMode) {
          print('User is signed in!');
        }
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Auth authh = Provider.of<Auth>(context, listen: false);
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 155),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.outfit(
                          fontSize: 60,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          const TextSpan(
                            text: "Yan ",
                          ),
                          TextSpan(
                            text: "Plagiat",
                            style: GoogleFonts.outfit(
                              fontSize: 60,
                              color: const Color(0xffffc600),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 31, right: 31, top: 53, bottom: 11),
                          width: 328,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: controllerEmail,
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 328,
                          child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: controllerPassword,
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 6, left: 252, right: 32, bottom: 25),
                          child: Text(
                            'Forget Password ?',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: const Color(0xff000000),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 328,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (mounted) {
                            authh
                                .signIn(
                                    email: controllerEmail.text,
                                    password: controllerPassword.text)
                                .then((result) {
                              if (result == null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Dashboard()));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    result,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ));
                              }
                            });
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffffc600)),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 35, bottom: 44),
                      width: 328,
                      child: SvgPicture.asset('assets/svg/login1.svg')),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xfffbfaf6),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3f000000),
                            offset: Offset(0, 1),
                            blurRadius: 1,
                          ),
                        ]),
                    width: 75,
                    height: 48,
                    child: IconButton(
                      onPressed: () async {
                        setState(() {
                          isSigningIn = true;
                        });
                        await authh.signInWithGoogle();

                       
                      },
                      icon: SvgPicture.asset('assets/svg/googlelogo.svg'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xfffbfaf6)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 44),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xff626262),
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          const TextSpan(
                            text: "Not register yet ? ",
                          ),
                          TextSpan(
                              text: "Create Account",
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: const Color(0xff0c1f22),
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Dashboard()));
                                }),
                        ],
                      ),
                    ),
                  ),
                ])),
      ),
    ));
  }
}
