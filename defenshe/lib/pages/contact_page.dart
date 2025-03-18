import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Map<String, dynamic>> emergencyContacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmergencyContacts();
  }

  Future<void> _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<void> fetchEmergencyContacts() async {
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists && doc.data()?['emergencyContacts'] != null) {
        setState(() {
          emergencyContacts = List<Map<String, dynamic>>.from(doc.data()!['emergencyContacts']);
          isLoading = false;
        });
      } else {
        setState(() {
          emergencyContacts = [];
          isLoading = false;
        });
      }
    }
  } catch (e) {
    setState(() {
      emergencyContacts = [];
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contacts",
          style: GoogleFonts.arimo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFFF06292),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Helpline",
                      style: GoogleFonts.montserrat(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        helplineTile("Women Helpline", "1090", Icons.woman_2_outlined),
                        helplineTile("Police", "100", Icons.local_police),
                        helplineTile("Domestic Abuse", "1091", Icons.security),
                        helplineTile("Emergency", "112", Icons.warning),
                        helplineTile("Ambulance", "108", Icons.accessible),
                        const SizedBox(height: 20),
                        Text("Emergency Contacts",
                            style: GoogleFonts.montserrat(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        emergencyContacts.isEmpty
                            ? const Text("No emergency contacts added.")
                            : Column(
                                children: emergencyContacts.map((contact) {
                                  return dynamicEmergencyContactTile(contact['name'], contact['number']);
                                }).toList(),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add functionality to add or update contacts
        },
        backgroundColor: Colors.pink[300],
        icon: const Icon(Icons.add, color: Colors.black),
        label: Text(
          "Add contact",
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget helplineTile(String title, String number, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.pink[50],
        child: Icon(icon, color: Colors.pink[300]),
      ),
      title: Text(
        title,
        style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        number,
        style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey),
      ),
      trailing: const Icon(Icons.call, color: Colors.black),
      onTap: () {
        _callNumber(number);
      },
    );
  }

  // Dynamic Emergency Contact tile from fetched Firestore data
  Widget dynamicEmergencyContactTile(String name, String number) {
  return ListTile(
    leading: const CircleAvatar(
      backgroundImage: AssetImage('assets/images/emergency_avatar.png'),
    ),
    title: Text(
      name,
      style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    subtitle: Text(
      number,
      style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey),
    ),
    trailing: const Icon(Icons.call, color: Colors.black),
    onTap: () {
      _callNumber(number);
    },
  );
}}
