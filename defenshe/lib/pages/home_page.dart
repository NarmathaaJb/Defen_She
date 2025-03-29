import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:defenshe/pages/auth_page.dart';
import 'package:defenshe/pages/community_page.dart';
import 'package:defenshe/pages/contact_page.dart';
import 'package:defenshe/pages/feed_page.dart';
import 'package:defenshe/pages/safetyBot.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';





class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static Future<void> openMap(String location) async{
    String googleUrl = 'https://www.google.com/maps/search/$location';
    final Uri url = Uri.parse(googleUrl);
    try{
      await launchUrl(url);
    }
    catch(e){
      Fluttertoast.showToast(msg: 'Something went wrong! Call Emergency numbers');
    }
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  late stt.SpeechToText _speech;

  bool _isListening = false;
  

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    startVoiceListening();
  }

  Future<void> startVoiceListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == "notListening" && _isListening) {
          startVoiceListening();
        }
      },
      onError: (error) {
        startVoiceListening();
      },
    );

    if (available) {
      _isListening = true;
      _speech.listen(
        onResult: (result) {
          final recognizedText = result.recognizedWords.toLowerCase();
          if (recognizedText.contains("help") || recognizedText.contains("save me") || recognizedText.contains("sos")) {
          triggerVoiceSOS();
          }
        },
        listenMode: stt.ListenMode.confirmation,
        partialResults: true,
        localeId: 'en_US',
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 5),
      );
    }
  }

  Future<void> triggerVoiceSOS() async {
    Fluttertoast.showToast(msg: "Voice trigger detected! Sending SOS...");
    await _triggerSOS();
  }

  Future<Position> _getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied.');
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  }

/*Future<void> sendSOS(String phoneNumber, String message) async
  {
  


  final uri = Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');
  final response = await http.post(
    uri,
    headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
    },
    body: {
      'From': fromNumber,
      'To': phoneNumber,
      'Body': message,
    },
  );

  if (response.statusCode == 201) {
    debugPrint("SMS sent to $phoneNumber");
  } else {
    debugPrint("Failed to send SMS: ${response.body}");
  }
}*/

Future<void> _triggerSOS() async {
    try {
      Fluttertoast.showToast(msg: "Sending SOS...");

      final position = await _getCurrentLocation();
      final locationUrl =
          'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';


      final message = "🚨 EMERGENCY ALERT 🚨\nI need help! My location: $locationUrl";

      final userId = FirebaseAuth.instance.currentUser?.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final contacts = userDoc['emergencyContacts'] as List<dynamic>;

      for (var number in contacts) {
        String formattedNumber = number
            .toString()
            .replaceAll(RegExp(r'\D'), '')
            .replaceFirst(RegExp(r'^0+'), '');
        if (!formattedNumber.startsWith('91')) {
          formattedNumber = '91$formattedNumber';
        }
        formattedNumber = '+$formattedNumber';

        await sendSOS(formattedNumber, message);
      }

      Fluttertoast.showToast(msg: "SOS alert sent successfully.");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error sending SOS: $e");
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF06292),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile_defenshe.jpg'),
          ),
        ),
        title: FutureBuilder(
          future: FirebaseAuth.instance.currentUser?.reload(),
          builder: (context, snapshot) {
      final user = FirebaseAuth.instance.currentUser;
      String displayName = user?.displayName ?? 'User';
      return Text(
        "Hi, $displayName",
        style: GoogleFonts.arimo(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );
    },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "stay_safe".tr(),
                style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  try {
                    debugPrint("SOS Button Pressed!".tr());
                    Fluttertoast.showToast(msg: "fetching_location".tr());

                    // 1. Get user location
                    final position = await _getCurrentLocation();
                    final latitude = position.latitude;
                    final longitude = position.longitude;
                    final locationUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

                    // 2. Prepare message
                    final message = "🚨 EMERGENCY ALERT 🚨\nI need help! My location: $locationUrl";

                    // 3. Get emergency contacts from Firestore
                    final userId = FirebaseAuth.instance.currentUser?.uid;
                    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
                    final contacts = userDoc['emergencyContacts'] as List<dynamic>;

                    // 4. Send SMS to each emergency contact
                    for (var number in contacts) {
                      String formattedNumber = number.toString().replaceAll(RegExp(r'\D'), ''); // remove non-digits
                      if (formattedNumber.startsWith('0')) {
                        formattedNumber = formattedNumber.substring(1); // remove leading zero
                      }
                      if (!formattedNumber.startsWith('91')) {
                        formattedNumber = '91$formattedNumber';
                      }
                      formattedNumber = '+$formattedNumber'; // add '+'
  
                      await sendSOS(formattedNumber, message);
                    }

                    Fluttertoast.showToast(msg: "sos_alert_sent".tr());
                  }
                  catch (e) {
                    Fluttertoast.showToast(msg: "error_sending_sos: $e".tr());
                  }
                },
                child: Center(
                  child: Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD81B60),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD81B60).withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "SOS",
                        style: GoogleFonts.poppins(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "press_sos".tr(),
                style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Locale currentLocale = context.locale;
                  if (currentLocale.languageCode == 'en') {
                    context.setLocale(const Locale('ta'));
                  } else {
                    context.setLocale(const Locale('en'));
                  }
                },
                child: Text("switch_language".tr()),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 30),
              OptionTile(
                icon: Icons.location_on,
                title: "nearby_police".tr(),
                subtitle: "find_police".tr(),
                onTap: () {
                  HomePage.openMap("police station near me");
                },
              ),
              OptionTile(
                icon: Icons.phone,
                title: "women_helpline".tr(),
                subtitle: "distress".tr(),
                onTap: () async {
                  bool? res = await FlutterPhoneDirectCaller.callNumber("1091");
                  if (res == null || !res) {
                    Fluttertoast.showToast(msg: "cannot_call".tr());
                  }
                },
              ),
              const SizedBox(height: 40),
              LiveSafeSection(), // Added LiveSafe Section here
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SafetyBot()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF06292),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                    child: Text(
                      "safetybot".tr(),
                      style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommunityPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  FeedPage()),
              );
              break;
            case 4: // Logout
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: "Contacts"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
        ],
      ),
    );
  }
}

// ===========================
// Explore LiveSafe Section
// ===========================
class LiveSafeSection extends StatelessWidget {
  final List<Map<String, dynamic>> liveSafeOptions = [
    {"icon": Icons.local_police, "label": "police_stations".tr(), "search": "police stations near me"},
    {"icon": Icons.local_hospital, "label": "hospitals".tr(), "search": "hospitals near me"},
    {"icon": Icons.local_pharmacy, "label": "pharmacy".tr(), "search": "pharmacy near me"},
    {"icon": Icons.directions_bus, "label": "bus_stops".tr(), "search": "bus stops near me"},
  ];

  LiveSafeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "explore_livesafe".tr(),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView (
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: liveSafeOptions.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          HomePage.openMap(option["search"]);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            option["icon"],
                            size: 30,
                            color: const Color(0xFFF06292), // Customize color if needed
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option["label"],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
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
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFFF06292), size: 30),
          title: Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
          trailing:
              const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18),
          onTap: onTap,
        ),
      ),
    );
  }
}

