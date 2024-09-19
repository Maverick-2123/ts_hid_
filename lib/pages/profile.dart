// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_hid/components/glassCards/glassCard.dart';
import 'package:ts_hid/controllers/controllers.dart';
import '../components/appDrawer.dart';
import 'loginPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('accessToken');
    await prefs.remove('isLoggedIn');
    await prefs.remove('userRole');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child:
                  Image.asset('assets/logo.png', height: screenHeight * 0.015),
            ),
          ],
          backgroundColor: Colors.black,
        ),
        drawer: CustomAppDrawer(),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff000000), Color(0xff11307A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    'MY PROFILE',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  Divider(
                    endIndent: screenWidth * 0.42,
                    indent: screenWidth * 0.42,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: GlassCard(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.066,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Center(
                            child: ListTile(
                              leading: Text(
                                'Currently Logged in as :',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              trailing: Text(
                                usernameController.text,
                                style: GoogleFonts.poppins(
                                    color: Colors.white60,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GlassCard(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.066,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Center(
                            child: ListTile(
                              leading: Text(
                                'Region :',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              trailing: Text(
                                'APAC',
                                style: GoogleFonts.poppins(
                                    color: Colors.white60,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GlassCard(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.066,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Center(
                            child: ListTile(
                              leading: Text(
                                'Country :',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              trailing: Text(
                                'India',
                                style: GoogleFonts.poppins(
                                    color: Colors.white60,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GlassCard(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.066,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Center(
                            child: ListTile(
                              leading: Text(
                                'Technology :',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              trailing: Text(
                                'Optics',
                                style: GoogleFonts.poppins(
                                    color: Colors.white60,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GlassCard(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.066,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Center(
                            child: ListTile(
                              leading: Text(
                                'Permissions Level :',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              trailing: Text(
                                'Admin',
                                style: GoogleFonts.poppins(
                                    color: Colors.white60,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: GestureDetector(
                      onTap: () {
                        logout(context);
                      },
                      child: GlassCard(
                          width: screenWidth * 0.3,
                          height: screenHeight * 0.05,
                          child: Center(
                            child: Text(
                              'LOGOUT',
                              style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            )));
  }
}
