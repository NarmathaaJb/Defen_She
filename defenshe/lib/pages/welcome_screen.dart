import 'package:flutter/material.dart';
import 'home_page.dart'; // Replace with your home page import

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> welcomePages = [
    {
      'image': 'assets/images/logo.png',
      'title': 'Welcome to DefenShe',
      'description': 'Your personal safety companion. Stay secure, stay connected.'
    },
    {
      'image': 'assets/images/siren.png',
      'title': 'Real-time SOS',
      'description': 'Trigger emergency alerts and share your live location instantly.'
    },
    {
      'image': 'assets/images/helpline.png',
      'title': 'Helpline Directory',
      'description': 'Access national and local helpline numbers anytime.'
    },
    {
      'image': 'assets/images/contact.png',
      'title': 'Custom Emergency Contacts',
      'description': 'Add and store up to 3 personal emergency contacts for quick access.'
    },
    {
      'image': 'assets/images/safety.png',
      'title': 'Safety Analytics',
      'description': 'Get alerts about unsafe areas and stay informed about security risks.'
    },
    {
      'image': 'assets/images/bot.png',
      'title': 'AI-Powered Virtual Assistant',
      'description': 'Get instant guidance and safety tips with our AI-powered assistant.'
    },
    {
      'image': 'assets/images/community.png',
      'title': 'Community Support',
      'description': 'Join a network of users to report incidents and help others stay safe.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: welcomePages.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        welcomePages[index]['image']!,
                        height: index ==0 ? 300 : 200,
                        fit: BoxFit.cover,
                        color: index == 0
                        ? Colors.pink
                        : null,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        welcomePages[index]['title']!,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        welcomePages[index]['description']!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              welcomePages.length,
              (index) => buildDot(index, context),
            ),
          ),
          const SizedBox(height: 30),
          currentPage == welcomePages.length - 1
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: const Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: () {
                    _controller.nextPage(
                        duration: const Duration(milliseconds: 500), curve: Curves.ease);
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.pinkAccent, fontSize: 16),
                  ),
                ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.pinkAccent : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
