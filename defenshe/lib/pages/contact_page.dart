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
            emergencyContacts = List<Map<String, dynamic>>.from(
              (doc.data()?['emergencyContacts'] as List).map((e) => Map<String, dynamic>.from(e))
            );
          });
        } else {
          setState(() {
            emergencyContacts = [];
          });
        }
      }
    } catch (e) {
      print("Error fetching contacts: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addEmergencyContact(String name, String number) async {
    if (emergencyContacts.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only add up to 3 emergency contacts.")),
      );
      return;
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      emergencyContacts.add({'name': name, 'number': number});
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'emergencyContacts': emergencyContacts,
      });
      fetchEmergencyContacts();
    }
  }

  Future<void> deleteEmergencyContact(int index) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      emergencyContacts.removeAt(index);
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'emergencyContacts': emergencyContacts,
      });
      fetchEmergencyContacts();
    }
  }

  void showAddContactDialog() {
    String name = "";
    String number = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Emergency Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Name"),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                onChanged: (value) => number = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty && number.isNotEmpty) {
                  addEmergencyContact(name, number);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void showEditContactDialog(int index, String existingName, String existingNumber) {
    final nameController = TextEditingController(text: existingName);
    final numberController = TextEditingController(text: existingNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Name"),
                controller: nameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Phone Number"),
                controller: numberController,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final updatedName = nameController.text;
                final updatedNumber = numberController.text;

                if (updatedName.isNotEmpty && updatedNumber.isNotEmpty) {
                  emergencyContacts[index] = {
                    'name': updatedName,
                    'number': updatedNumber,
                  };

                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid != null) {
                    await FirebaseFirestore.instance.collection('users').doc(uid).update({
                      'emergencyContacts': emergencyContacts,
                    });
                  }

                  Navigator.pop(context);
                  fetchEmergencyContacts();
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts", style: GoogleFonts.arimo(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: const Color(0xFFF06292),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Helplines", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    helplineTile("Women Helpline", "1090", Icons.woman_2_outlined),
                    helplineTile("Police", "100", Icons.local_police),
                    helplineTile("Domestic Abuse", "1091", Icons.security),
                    helplineTile("Emergency", "112", Icons.warning),
                    helplineTile("Ambulance", "108", Icons.accessible),
                    const SizedBox(height: 25),
                    Text("Emergency Contacts", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    emergencyContacts.isEmpty
                        ? const Text("No emergency contacts added.")
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: emergencyContacts.length,
                            itemBuilder: (context, index) {
                              final contact = emergencyContacts[index];
                              return ListTile(
                                leading: const CircleAvatar(
                                    backgroundColor: Color.fromARGB(255, 245, 224, 231),
                                    child: Icon(Icons.person, color: Color(0xFFF06292))),
                                title: Text(contact['name'],
                                    style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500)),
                                subtitle: Text(contact['number'],
                                    style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.call, color: Colors.black),
                                      onPressed: () {
                                        _callNumber(contact['number']);
                                      },
                                    ),
                                    PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert, color: Colors.black),
                                      onSelected: (value) {
                                        if (value == 'Edit') {
                                          showEditContactDialog(index, contact['name'], contact['number']);
                                        } else if (value == 'Delete') {
                                          deleteEmergencyContact(index);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'Edit',
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddContactDialog,
        backgroundColor: Colors.pink[300],
        icon: const Icon(Icons.add, color: Colors.black),
        label: Text(
          "Add contact",
          style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }
}
