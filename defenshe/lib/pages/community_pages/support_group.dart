import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportGroup extends StatelessWidget {
  const SupportGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Women Support Group"),
          centerTitle: true,
          backgroundColor: Colors.pink[400],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.forum), text: "Community"),
              Tab(icon: Icon(Icons.phone), text: "Help & SOS"),
              Tab(icon: Icon(Icons.event), text: "Workshops"),
              Tab(icon: Icon(Icons.book), text: "Resources"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CommunitySection(),
            HelpAndSOSSection(),
            EventsAndWorkshops(),
            ResourceCenter(),
          ],
        ),
      ),
    );
  }
}

// 🏡 1️⃣ Community Forum
class CommunitySection extends StatelessWidget {
  const CommunitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        PostCard(username: "Rinaa R", content: "Hey everyone, what are the safest cab services for women at night?"),
        PostCard(username: "Narmathaa J B", content: "How do you manage work and personal life without feeling overwhelmed?"),
        PostCard(username: "Nivetha S B", content: "Are there any co-working spaces for women in Chennai?"),
        PostCard(username: "Swathika S T", content: "Hey everyone, what are some self-defense tips?"),
        PostCard(username: "Srijhha R M", content: "Looking for a women-only co-working space in Mumbai. Any recommendations?"),
        PostCard(username: "Neha Gupta M", content: "Looking for a women-only co-working space in Mumbai. Any recommendations?"),
      ],
    );
  }
}

class PostCard extends StatelessWidget {
  final String username;
  final String content;

  const PostCard({super.key, required this.username, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink.shade100,
          child: const Icon(Icons.person, color: Colors.pink),
        ),
        title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
        trailing: const Icon(Icons.comment, color: Colors.blue),
      ),
    );
  }
}

// 📞 2️⃣ Help & SOS Section
class HelpAndSOSSection extends StatelessWidget {
  const HelpAndSOSSection({super.key});

  // Function to make a direct call
  void _makePhoneCall(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const SOSButton(),
        HelpLineTile(title: "Women Helpline", number: "1091", onTap: _makePhoneCall, icon: Icons.woman,),
        HelpLineTile(title: "Cyber Crime Support", number: "1930", onTap: _makePhoneCall, icon: Icons.shield),
        HelpLineTile(title: "Ambulance", number: "102", onTap: _makePhoneCall, icon: Icons.local_hospital),
        HelpLineTile(title: "Child Helpline", number: "1098", onTap: _makePhoneCall, icon: Icons.child_friendly),
        HelpLineTile(title: "Senior Citizen Helpline", number: "1253", onTap: _makePhoneCall, icon: Icons.elderly),
        HelpLineTile(title: "Dial a Doctor", number: "1911", onTap: _makePhoneCall, icon: Icons.medical_information),
        HelpLineTile(title: "Anti Ragging Helpline", number: "18001805522", onTap: _makePhoneCall, icon: Icons.dangerous),
        HelpLineTile(title: "Suicide Prevention", number: "8526565656", onTap: _makePhoneCall, icon: Icons.warning),
        HelpLineTile(title: "Trauma Service", number: "1099", onTap: _makePhoneCall, icon: Icons.safety_check),
      ],
    );
  }
}

// 📌 Custom widget for helpline tiles
class HelpLineTile extends StatelessWidget {
  final String title;
  final String number;
  final Function(String) onTap;
  final IconData icon;

  const HelpLineTile({super.key, required this.title, required this.number, required this.onTap, required this.icon,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:  Icon(icon, color: Colors.pink),
      title: Text("$title: $number"),
      onTap: () => onTap(number),
    );
  }
}

// 🆘 Emergency SOS Button
class SOSButton extends StatelessWidget {
  const SOSButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () {
          // Implement SOS functionality
        },
        icon: const Icon(Icons.warning, color: Colors.white),
        label: const Text("Emergency SOS", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// 🎤 3️⃣ Events & Workshops Section
class EventsAndWorkshops extends StatelessWidget {
  const EventsAndWorkshops({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        EventCard(title: "Self-Defense Workshop", date: "April 10, 2025", location: "Delhi"),
        EventCard(title: "Legal Rights for Women Webinar", date: "April 25, 2025", location: "Online"),
        EventCard(title: "Financial Independence Bootcamp", date: "May 5, 2025 ", location: "Bangalore"),
        EventCard(title: "Personal Safety & Self-Defense Training", date: "June 01, 2025", location: "Online"),
        EventCard(title: "Women in Tech Meetup", date: "June 11, 2025", location: "Hyderabad"),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;

  const EventCard({super.key, required this.title, required this.date, required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.event, color: Colors.purple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("📅 $date | 📍 $location"),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

// 📚 4️⃣ Resource Center
class ResourceCenter extends StatelessWidget {
  const ResourceCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        ResourceTile(title: "Domestic Violence Laws", url: "https://unacademy.com/content/upsc/study-material/general-awareness/the-legal-action-for-domestic-violence-in-india/#:~:text=Section%20498A%20of%20the%20Indian%20Penal%20Code%3A&text=The%20harassment%20may%20be%20mental,498A%20has%20a%20broad%20scope."),
        ResourceTile(title: "Women Safety Tips", url: "https://www.placer.ca.gov/8848/Violence-against-women-general-safety-ti"),
        ResourceTile(title: "Your Legal Rights: Women Protection Laws in India", url: "https://www.lexisnexis.in/blogs/laws-for-women-in-india/"),
        ResourceTile(title: "Cyber Safety Guide for Women", url: "https://cyber.delhipolice.gov.in/TIPSWOMEN.html"),
        ResourceTile(title: "Support for Single Mothers", url: "https://kidshealth.org/"),
        ResourceTile(title: "Career Growth & Skill Development", url: "https://www.mentoringcomplete.com/women-mentoring-programs-on-career-growth/"),
        ResourceTile(title: "Mental Health Support", url: "https://www.nimh.nih.gov/health/topics/women-and-mental-health"),
        ResourceTile(title: "Financial Aid for Women", url: "https://www.startupindia.gov.in/content/sih/en/women_entrepreneurs.html#:~:text=Loans%20under%20Mudra%20Yojana%20Scheme,age%20requirement%20is%2018%20years."),
      ],
    );
  }
}

class ResourceTile extends StatelessWidget {
  final String title;
  final String url;

  const ResourceTile({super.key, required this.title, required this.url});

  void _openURL(BuildContext context) async {
  final Uri uri = Uri.parse(Uri.encodeFull(url)); // Encode URL properly

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint("Could not open $url");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Could not open link. Please check your internet connection."))
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.book, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: () => _openURL(context),
      ),
    );
  }
}
