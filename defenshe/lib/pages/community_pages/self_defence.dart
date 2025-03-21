import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SelfDefence extends StatelessWidget {
  const SelfDefence({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Self Defence", style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Section
            const Text(
              "Why Self-Defense is Important?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Self-defense skills help you protect yourself in dangerous situations. "
              "They also boost confidence and awareness of your surroundings.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Basic Techniques Section
            const Text(
              "Basic Self-Defense Techniques",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelfDefenceTechnique(
              imagePath: "assets/images/palm_strike.jpg",
              title: "Palm Strike",
              description: "Use the base of your palm to strike the attacker's nose or chin.",
            ),
            SelfDefenceTechnique(
              imagePath: "assets/images/knee_strike.jpg",
              title: "Knee Strike",
              description: "Bring your knee up forcefully to the attacker's stomach or groin.",
            ),
            SelfDefenceTechnique(
              imagePath: "assets/images/elbow_strike.jpg",
              title: "Elbow Strike",
              description: "Use your elbow to hit the attacker’s face or ribs.",
            ),
            SelfDefenceTechnique(
              imagePath: "assets/images/front_kick.jpg",
              title: "Front Kick",
              description: "A front kick to the groin can be a very effective self-defense tool because of the vulnerable area it targets",
            ),
            const SizedBox(height: 20),

            // Workshops & Classes
            const Text(
              "Workshops & Online Classes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _launchURL("https://www.udemy.com/course/self-defense-training/"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[200]),
              child: const Text("View Online Self-Defense Course",style: TextStyle(color: Colors.black),),
            ),
            const SizedBox(height: 20),

            // Emergency Actions Section
            const Text(
              "Emergency Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "1. Stay aware of your surroundings.\n"
              "2. Keep a safe distance from strangers.\n"
              "3. Use your voice to alert others.\n"
              "4. Aim for the attacker's weak points.\n"
              "5. Escape to a safe location and call for help.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // FAQ Section
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FAQItem(question: "Is self-defense legal?", answer: "Yes, you are allowed to defend yourself if attacked."),
            FAQItem(question: "What should I do if I am followed?", answer: "Go to a public place and call for help."),
            FAQItem(question: "What if I freeze in a dangerous situation?", answer: "Practice self-defense drills regularly to build muscle memory."),
          ],
        ),
      ),
    );
  }

  // Function to open external links
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception("Could not launch $url");
    }
  }
}

// Self-Defense Technique Widget
class SelfDefenceTechnique extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const SelfDefenceTechnique({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(imagePath, height: 180, width: double.infinity, fit: BoxFit.contain),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: Color.fromARGB(255, 87, 83, 83))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// FAQ Section Widget
class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(answer, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}
