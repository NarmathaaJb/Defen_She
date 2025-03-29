import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetyTip {
  final String title;
  final String shortDesc;
  final String detailDesc;
  final String imageAsset;

  SafetyTip({
    required this.title,
    required this.shortDesc,
    required this.detailDesc,
    required this.imageAsset,
  });
}

class SafetyTips extends StatelessWidget {
  const SafetyTips({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Safety Tips",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.pink[400],
          bottom: const TabBar(
            isScrollable: true,
            labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Kids"),
              Tab(text: "Teens"),
              Tab(text: "Women"),
              Tab(text: "Elderly"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TipSection(ageGroup: "Kids", tips: kidsTips, resources: kidsResources),
            TipSection(ageGroup: "Teens", tips: teensTips, resources: teensResources),
            TipSection(ageGroup: "Women", tips: womenTips, resources: womenResources),
            TipSection(ageGroup: "Elderly", tips: elderlyTips, resources: elderlyResources),
          ],
        ),
      ),
    );
  }
}

class TipSection extends StatelessWidget {
  final String ageGroup;
  final List<SafetyTip> tips;
  final List<Map<String, String>> resources;

  const TipSection({super.key, required this.ageGroup, required this.tips, required this.resources});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        ...tips.map((tip) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.pink.shade100,
                  child: const Icon(Icons.shield, color: Colors.pink),
                ),
                title: Text(tip.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(tip.shortDesc),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => TipDetailDialog(tip: tip),
                  );
                },
              ),
            )),
        const SizedBox(height: 20),
        const Text("Resources", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...resources.map((resource) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: const Icon(Icons.link, color: Colors.blueAccent),
                title: Text(resource["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(resource["url"]!, style: const TextStyle(color: Colors.blue)),
                trailing: const Icon(Icons.open_in_new, color: Colors.blue),
                onTap: () => launchUrlFunction(resource["url"]!),
              ),
            )),
      ],
    );
  }
}

class TipDetailDialog extends StatelessWidget {
  final SafetyTip tip;

  const TipDetailDialog({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(tip.imageAsset, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tip.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(tip.detailDesc, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void launchUrlFunction(String url) async {
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
// Resources data
final List<Map<String, String>> kidsResources = [
  {"title": "Child Safety Guide", "url": "https://www.safekids.org"},
  {"title": "Good Touch, Bad Touch - Video", "url": "https://youtu.be/C5eWJkn5MgI?feature=shared"},
];

final List<Map<String, String>> teensResources = [
  {"title": "Online Safety for Teens", "url": "https://www.connectsafely.org/"},
  {"title": "Cyber Safety Tips - YouTube", "url": "https://youtu.be/aO858HyFbKI?si=PogmThQNGEcx4rJe"},
];

final List<Map<String, String>> womenResources = [
  {"title": "Self-Defense Techniques", "url": "https://www.womensselfdefense.org/"},
  {"title": "Personal Safety Tips - YouTube", "url": "https://youtu.be/QEmO0F-ge8I?si=IwJ9P4-mhaRn9RW-"},
];

final List<Map<String, String>> elderlyResources = [
  {"title": "Senior Citizen Safety", "url": "https://www.nsc.org"},
  {"title": "Avoiding Scams - YouTube", "url": "https://youtu.be/QiWcLQLvy5c?si=-gZjMvFXLQ2y5XLu"},
];

// Example tips (Add real descriptions and your asset images in pubspec.yaml)
final List<SafetyTip> kidsTips = [
  SafetyTip(
    title: "Good Touch, Bad Touch",
    shortDesc: "Help children understand body safety.",
    detailDesc: "Teach children about safe and unsafe touches with clear examples and encourage open communication.",
    imageAsset: "assets/images/good_bad_touch.jpg",
  ),
  SafetyTip(
    title: "Stranger Danger",
    shortDesc: "Teach kids to be cautious around strangers.",
    detailDesc: "Explain the importance of not talking to or accepting gifts from strangers and seeking help when needed.",
    imageAsset: "assets/images/stranger_danger.jpg",
  ),
  SafetyTip(
    title: "Emergency Contacts",
    shortDesc: "Make sure kids know important phone numbers.",
    detailDesc: "Teach children to memorize key contact numbers, such as parents, guardians, or emergency services.",
    imageAsset: "assets/images/emergency_kids.jpg",
  ),
  // Add more kids tips
];

final List<SafetyTip> teensTips = [
  SafetyTip(
    title: "Understanding Body Changes",
    shortDesc: "Educate teens on physical and emotional changes.",
    detailDesc: "Talk openly about periods, hormonal changes, and emotional well-being.",
    imageAsset: "assets/images/body_changes.jpg",
  ),
  SafetyTip(
    title: "Safe Online Behavior",
    shortDesc: "Be cautious with social media and strangers online.",
    detailDesc: "Avoid sharing personal information online and be aware of cyberbullying risks.",
    imageAsset: "assets/images/safe_online_behaviour.png",
  ),
  SafetyTip(
    title: "Peer Pressure Awareness",
    shortDesc: "Learn to say no to harmful activities.",
    detailDesc: "Help teens build confidence to resist negative peer pressure and make responsible choices.",
    imageAsset: "assets/images/peer_pressure.jpg",
  ),

  // Add more teen tips
];

final List<SafetyTip> womenTips = [
  SafetyTip(
    title: "Be Alert When Outside",
    shortDesc: "Always stay aware of surroundings.",
    detailDesc: "Stay alert when out and about. Avoid distractions and trust your instincts.",
    imageAsset: "assets/images/personal_safety_outside.jpg",
  ),
  SafetyTip(
    title: "Self-Defense Awareness",
    shortDesc: "Learn basic self-defense techniques.",
    detailDesc: "Take self-defense classes to feel more confident and prepared for any situation.",
    imageAsset: "assets/images/self_defence_tips.jpg",
  ),
  SafetyTip(
    title: "Travel Safety Tips",
    shortDesc: "Ensure safe travel routines.",
    detailDesc: "Use well-lit routes, avoid empty streets at night, and share trip details with family or friends.",
    imageAsset: "assets/images/solo_travel.png",
  ),
  // Add more women tips from your infographic
];

final List<SafetyTip> elderlyTips = [
  SafetyTip(
    title: "Stay Connected",
    shortDesc: "Maintain communication with family.",
    detailDesc: "Regular check-ins and being cautious with strangers is key for elderly safety.",
    imageAsset: "assets/images/stay_connected.png",
  ),
  SafetyTip(
    title: "Home Safety Measures",
    shortDesc: "Ensure a safe home environment.",
    detailDesc: "Install handrails, remove tripping hazards, and use adequate lighting to prevent falls.",
    imageAsset: "assets/images/home_safety.png",
  ),
  SafetyTip(
    title: "Financial Scams Awareness",
    shortDesc: "Be aware of financial frauds and scams.",
    detailDesc: "Avoid sharing banking details over the phone and verify unknown callers before providing information.",
    imageAsset: "assets/images/online_scams.jpg",
  ),
  // Add more elderly tips
];