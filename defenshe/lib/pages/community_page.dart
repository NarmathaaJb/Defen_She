import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to the community hub",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Community Cards with Asset Images
            CommunityCard(
              imagePath: "assets/images/self_defense.webp",
              title: "Self Defence",
              description: "Learn how to protect yourself and your loved ones.",
              buttonText: "Join Now",
            ),
            CommunityCard(
              imagePath: "assets/images/awareness.jpeg",
              title: "Awareness",
              description: "Understand the issue and learn how to help others.",
              buttonText: "Explore",
            ),
            CommunityCard(
              imagePath: "assets/images/safety_tips.jpg",
              title: "Safety Tips",
              description: "Get tips on how to stay safe in various situations.",
              buttonText: "Read More",
            ),
            CommunityCard(
              imagePath: "assets/images/support_group.jpg",
              title: "Support Groups",
              description: "Join discussions and share experiences with others.",
              buttonText: "Get Involved",
            ),
            CommunityCard(
              imagePath: "assets/images/counseling.jpeg",
              title: "Counseling",
              description: "Connect with mentors and get guidance.",
              buttonText: "Connect Now",
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Card Widget
class CommunityCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String buttonText;

  const CommunityCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(imagePath, height: 180, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple.shade400,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
