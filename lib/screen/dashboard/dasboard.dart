import 'package:cek_grammer_plagiat/firebase/auth/auth.dart';
import 'package:cek_grammer_plagiat/screen/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardWidget();
}

class DashboardWidget extends State<Dashboard> {
  User? auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
              child: SizedBox(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 120),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.outfit(
                    fontSize: 48,
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    const TextSpan(
                      text: "Welcome Back \n",
                    ),
                    TextSpan(
                      text: auth?.displayName.toString(),
                      style: GoogleFonts.outfit(
                        fontSize: 48,
                        color: const Color(0xffffc600),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 600,
              width: 350,
              child: Stack(
                children: [
                  Positioned(
                    left: 119,
                    top: 310,
                    child: SizedBox(
                        child: GestureDetector(
                      onTap: () {
                        Auth().signOut().then((value) =>
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen())));
                      }, // Image tapped
                      child: Image.asset(
                        'assets/image/dashboard1.png',
                        fit: BoxFit.cover, // Fixes border issues
                        width: 110.0,
                        height: 110.0,
                      ),
                    )),
                  ),
                  // Positioned(
                  //   left: 70,
                  //   top: 40,
                  //   child: SizedBox(
                  //     child: Image.network(
                  //       auth!.photoURL.toString(),
                  //       width: 220,
                  //       height: 220,
                  //       fit: BoxFit.fill,
                  //       filterQuality: FilterQuality.high, // Fixes border issues
                  //     ),
                  //   ),
                  // )
                ],
              ),
            )
          ],
              )),
            ),
        ));
  }
}
