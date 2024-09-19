import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_hid/pages/addressedIssues.dart';
import 'package:ts_hid/pages/allIssuesPage.dart';
import 'package:ts_hid/pages/loginPage.dart';
import 'package:ts_hid/pages/profile.dart';
import 'package:ts_hid/pages/teamSelector.dart';

class CustomAppDrawer extends StatefulWidget {
  const CustomAppDrawer({super.key});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {

  Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('accessToken');
    await prefs.remove('isLoggedIn');
    await prefs.remove('userRole');

    // Navigate to the login page and remove all previous routes
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

    return Drawer(
      width: screenWidth * 0.85,
      backgroundColor: Color(0xff021526),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AllIssuesPage()));
              },
              leading: Icon(
                Icons.all_inbox_rounded,
                color: Colors.white,
              ),
              title: Text(
                'A L L  I S S U E S',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.edit_note,
                color: Colors.white,
              ),
              title: Text(
                ' P R E F E R E N C E S',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => TeamSelector()));
              },
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddressedIssues()));
              },
              leading: Icon(
                Icons.check_circle_outline_outlined,
                color: Colors.white,
              ),
              title: Text(
                'A D D R E S S E D  I S S U E S',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle_rounded,
                color: Colors.white,
              ),
              title: Text(
                'P R O F I L E',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ProfilePage()));
              },
            ),
            SizedBox(
              height: screenHeight * 0.4,
            ),
          ],
        ),
      ),
    );
  }
}
