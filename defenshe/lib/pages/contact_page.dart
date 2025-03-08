import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Contactpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Helpline", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  helplineTile("Women Helpline", "1090", Icons.shield),
                  helplineTile("Police", "100", Icons.local_police),
                  helplineTile("Domestic Abuse", "1091", Icons.security),
                  helplineTile("Emergency", "112", Icons.warning),
                  helplineTile("Ambulance", "108", Icons.accessible),
                  SizedBox(height: 20),
                  Text("Emergency Contacts", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
                  emergencyContactTile("Contact 1", "Amma", "assets/contact1.jpg"),
                  emergencyContactTile("Contact 2", "Sister", "assets/contact2.jpg"),
                  emergencyContactTile("Contact 3", "Friend", "assets/contact3.jpg"),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement Add Contact functionality
        },
        backgroundColor: Colors.purple[100],
        icon: Icon(Icons.add, color: Colors.black),
        label: Text("Add contact", style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),),
      ),
    );
  }

  Widget helplineTile(String title, String number, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.purple[100],
        child: Icon(icon, color: Colors.purple[800]),
      ),
      title: Text(title, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: Text(number, style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey)),
      trailing: Icon(Icons.call, color: Colors.black),
      onTap: () {
        // TODO: Implement Call Function
      },
    );
  }

  Widget emergencyContactTile(String name, String relation, String image) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(image)),
      title: Text(name, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: Text(relation, style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey)),
      trailing: Icon(Icons.call, color: Colors.black),
      onTap: () {
        // TODO: Implement Call Function
      },
    );
  }
}
