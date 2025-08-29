// lib/screens/intro_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';

class IntroScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  IntroScreen({required this.onThemeToggle});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> introData = [
    {
      "image": "assets/img2.jpeg",
      "title": "Discover Events",
      "desc": "Find amazing events near you.",
    },
    {
      "image": "assets/img4.png",
      "title": "Join Easily",
      "desc": "Register with a single click.",
    },
    {
      "image": "assets/img5.jpeg",
      "title": "Stay Updated",
      "desc": "Track and manage your events.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: introData.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(introData[i]["image"]!,
                        height: 250, fit: BoxFit.contain),
                    SizedBox(height: 30),
                    Text(
                      introData[i]["title"]!,
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Text(
                      introData[i]["desc"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            },
          ),

          // Indicator + Button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    introData.length,
                        (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      height: 10,
                      width: _currentPage == index ? 20 : 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.deepPurple
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_currentPage == introData.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              LoginScreen(onThemeToggle: widget.onThemeToggle),
                        ),
                      );
                    },
                    child: Text("Get Started"),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
