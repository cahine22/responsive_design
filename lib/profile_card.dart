import 'package:flutter/material.dart';
import 'package:responsive_design/login_screen.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Design'),
      ),
      body: Center(
        child: Container(
          color: Colors.purple[100],
          padding: const EdgeInsets.all(20.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Small screen (mobile)
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: 20),
                    _buildContent(context),
                  ],
                );
              } else {
                // Large screen (tablet, desktop)
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAvatar(),
                    const SizedBox(width: 40),
                    _buildContent(context),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

//function that returns a Widget
//names that start with an underscore are private to the file
Widget _buildAvatar() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
    child: const Icon(Icons.person, size: 50, color: Colors.white),
  );
}

// container widget for the profile
Widget _buildContent(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Caroline Hines',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      Text('Major: Computer Science'),
      Text('Favorite Class: AI'),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          // Navigate to the login screen, pushing a new screen onto the screen stack
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LoginScreen())
            
          );
        },
        child: Text('Log in'),
      ),
    ],
  );
}
