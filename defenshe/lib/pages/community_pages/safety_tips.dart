import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetyTips extends StatelessWidget {
  const SafetyTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety Tips"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Safety Tips
            const SectionTitle(title: "🔒 Personal Safety Tips"),
            const SafetyTip(
              "🔹 Trust your instincts – if something feels wrong, leave immediately.",
            ),
            const SafetyTip(
              "🔹 Avoid isolated places, especially at night.",
            ),
            const SafetyTip(
              "🔹 Keep emergency contacts on speed dial.",
            ),

            // Online Safety Tips
            const SectionTitle(title: "💻 Online Safety"),
            const SafetyTip(
              "🔹 Never share personal details with strangers online.",
            ),
            const SafetyTip(
              "🔹 Use strong passwords and enable two-factor authentication.",
            ),
            const SafetyTip(
              "🔹 Avoid clicking unknown links in messages or emails.",
            ),

            // Travel Safety Tips
            const SectionTitle(title: "✈️ Travel Safety"),
            const SafetyTip(
              "🔹 Always share your travel plans with family or friends.",
            ),
            const SafetyTip(
              "🔹 Use verified taxi or ride-sharing services.",
            ),
            const SafetyTip(
              "🔹 Carry a personal safety alarm or pepper spray.",
            ),

            // Workplace Safety
            const SectionTitle(title: "🏢 Workplace Safety"),
            const SafetyTip(
              "🔹 Know your workplace’s emergency exits and procedures.",
            ),
            const SafetyTip(
              "🔹 Avoid staying late alone in the office.",
            ),
            const SafetyTip(
              "🔹 Report any harassment or unsafe behavior immediately.",
            ),

            // Emergency Numbers
            const SectionTitle(title: "📞 Emergency Contacts"),
            ContactCard(
              title: "Police Helpline",
              number: "100",
              onTap: () async {
                  bool? res = await FlutterPhoneDirectCaller.callNumber("100");
                  if (res == null || !res) {
                    Fluttertoast.showToast(msg: "Cannot place call. Try manually.");
                  }
                },
            ),
            ContactCard(
              title: "Women’s Helpline",
              number: "1091",
              onTap: () async {
                  bool? res = await FlutterPhoneDirectCaller.callNumber("1091");
                  if (res == null || !res) {
                    Fluttertoast.showToast(msg: "Cannot place call. Try manually.");
                  }
                },
            ),
            ContactCard(
              title: "Cyber Crime Helpline",
              number: "1930",
              onTap: () async {
                  bool? res = await FlutterPhoneDirectCaller.callNumber("1930");
                  if (res == null || !res) {
                    Fluttertoast.showToast(msg: "Cannot place call. Try manually.");
                  }
                },
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Section Title Widget
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Reusable Safety Tip Widget
class SafetyTip extends StatelessWidget {
  final String tip;
  const SafetyTip(this.tip, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        tip,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

// Contact Card for Emergency Numbers
class ContactCard extends StatelessWidget {
  final String title;
  final String number;
  final VoidCallback onTap;
  const ContactCard({super.key, required this.title, required this.number, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        //leading: const Icon(Icons.phone, color: Colors.pink),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Call: $number"),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.green),
          onPressed: () async {
            Uri uri = Uri.parse("tel:$number");
            if (!await launchUrl(uri)) {
              throw Exception("Could not launch call to $number");
            }
          },
        ),
      ),
    );
  }
}
