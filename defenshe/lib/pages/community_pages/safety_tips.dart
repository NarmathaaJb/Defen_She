import 'package:flutter/material.dart';

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
          title: const Text("Safety Tips", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.pink[400],
          bottom: const TabBar(
            isScrollable: true,
            labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            TipSection(ageGroup: "Kids", tips: kidsTips),
            TipSection(ageGroup: "Teens", tips: teensTips),
            TipSection(ageGroup: "Women", tips: womenTips),
            TipSection(ageGroup: "Elderly", tips: elderlyTips),
          ],
        ),
      ),
    );
  }
}

class TipSection extends StatelessWidget {
  final String ageGroup;
  final List<SafetyTip> tips;

  const TipSection({super.key, required this.ageGroup, required this.tips});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        return Card(
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
        );
      },
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

// Example tips (Add real descriptions and your asset images in pubspec.yaml)
final List<SafetyTip> kidsTips = [
  SafetyTip(
    title: "Good Touch, Bad Touch",
    shortDesc: "Help children understand body safety.",
    detailDesc: "Teach children about safe and unsafe touches with clear examples and encourage open communication.",
    imageAsset: "assets/images/good_bad_touch.jpg",
  ),
  // Add more kids tips
];

final List<SafetyTip> teensTips = [
  SafetyTip(
    title: "Understanding Body Changes",
    shortDesc: "Educate teens on physical and emotional changes.",
    detailDesc: "Talk openly about periods, hormonal changes, and emotional well-being.",
    imageAsset: "assets/images/teens_changes.png",
  ),
  // Add more teen tips
];

final List<SafetyTip> womenTips = [
  SafetyTip(
    title: "Be Alert When Outside",
    shortDesc: "Always stay aware of surroundings.",
    detailDesc: "Stay alert when out and about. Avoid distractions and trust your instincts.",
    imageAsset: "assets/images/women_safety.png",
  ),
  // Add more women tips from your infographic
];

final List<SafetyTip> elderlyTips = [
  SafetyTip(
    title: "Stay Connected",
    shortDesc: "Maintain communication with family.",
    detailDesc: "Regular check-ins and being cautious with strangers is key for elderly safety.",
    imageAsset: "assets/images/elderly_safety.png",
  ),
  // Add more elderly tips
];