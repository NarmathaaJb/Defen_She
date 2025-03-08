import 'package:defenshe/pages/auth_page.dart';
import 'package:defenshe/pages/community_page.dart';
import 'package:defenshe/pages/contact_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/profile.jpg'), // Profile image
          ),
        ),
        title: Text(
          "Hi, Sophia",
          style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout, color: Colors.black
            ), // Logout icon
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Sign out user
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthPage()
                ), // Navigate to AuthPage
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Stay Safe and Secure",
                  style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement SOS functionality
                    print("SOS Button Pressed!");
                  },
                  child: Center(
                    child: Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "SOS",
                          style: GoogleFonts.poppins(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Press the SOS button",
                  style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 90),
                OptionTile(
                  icon: Icons.location_on,
                  title: "Nearby police",
                  subtitle: "Find the nearest police station",
                  onTap: () {
                    // TODO: Implement navigation to police location
                  },
                ),
                OptionTile(
                  icon: Icons.phone,
                  title: "Women helpline",
                  subtitle: "For women in distress",
                  onTap: () {
                    // TODO: Implement helpline functionality
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement SafetyBot functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              ),
              child: Text(
                "SafetyBot",
                style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactPage()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommunityPage()),
            );
          }
          if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AuthPage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: "Contacts"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
        ],
      ),
    );
  }
}


class OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple, size: 30),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18),
        onTap: onTap,
      ),
    );
  }
}
