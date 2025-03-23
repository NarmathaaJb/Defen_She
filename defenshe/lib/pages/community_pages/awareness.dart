import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Awareness extends StatelessWidget {
  const Awareness({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Awareness"),
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        foregroundColor: Colors.black,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Understanding the Issue
            SectionTitle(title: "Understanding the Issue"),
            AwarenessText(
              "Many people face challenges related to harassment, domestic violence, and personal safety. "
              "Understanding these issues helps individuals take preventive actions and support victims effectively.",
            ),

            // Statistics & Facts
            SectionTitle(title: "Statistics & Facts"),
            AwarenessText(
              "🔹 1 in 3 women globally have experienced physical or sexual violence.\n"
              "🔹 70% of cyber harassment cases go unreported.\n"
              "🔹 Over 80% of victims of violence know their attacker.",
            ),

            // How to Report
            SectionTitle(title: "How to Report"),
            AwarenessText(
              "1️⃣ Stay safe: If in danger, move to a secure place.\n"
              "2️⃣ Contact authorities: Dial emergency services or helplines.\n"
              "3️⃣ Gather evidence: Take screenshots, note details.\n"
              "4️⃣ Seek support: Reach out to NGOs, lawyers, or trusted people.",
            ),

            // Educational Resources
            SectionTitle(title: "Educational Resources"),
            ResourceButton(title: "Read More on Women's Safety", url: "https://wbl.worldbank.org/en/safety"),
            ResourceButton(title: "Self Awareness Tips", url: "https://www.betterup.com/blog/what-is-self-awareness"),
            ResourceButton(title: "Legal Rights of women in India", url: "https://www.lexisnexis.in/blogs/laws-for-women-in-india/"),

            // Stories & Testimonials
            SectionTitle(title: "Stories & Testimonials"),
            StoryCard(
              title: "Escaping an Unsafe Relationship",
              content: "A survivor shares how she found support and regained confidence.",
            ),
            StoryCard(
              title: "Speaking Up Against Harassment",
              content: "An inspiring journey of a woman who fought back and won justice.",
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

// Reusable Awareness Text Widget
class AwarenessText extends StatelessWidget {
  final String text;
  const AwarenessText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}

// Resource Button for External Links
class ResourceButton extends StatelessWidget {
  final String title;
  final String url;
  const ResourceButton({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: () async {
          Uri uri = Uri.parse(url);
          if (!await launchUrl(uri)) {
            throw Exception("Could not launch $url");
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[200]),
        child: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

// Story Card for Testimonials
class StoryCard extends StatelessWidget {
  final String title;
  final String content;
  const StoryCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(content, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
