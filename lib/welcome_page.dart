import 'package:flutter/material.dart';
import 'package:flutter_python/simple_screen.dart';

class WelcomePage extends StatelessWidget {

  @override
  final Key? key;

  const WelcomePage({this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white60, // Set your desired background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add your logo here with border radius
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0), // Adjust the border radius as needed
              child: Image.asset(
                'assets/logo/fssm.png', // Replace with the path to your logo image asset
                height: 100.0, // Adjust the height as needed
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'AppLearn',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Times New Roman',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            const Text(
              '^ Welcome to AppLearn – the essential companion for new university students. '
                  'Our application is tailored specifically for those embarking on their academic journey. '
                  'Designed with a focus on education, AppLearn is here to help newcomers to get easly in the IT world ^',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
                fontFamily: 'Times New Roman',
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(title: 'Home',),
                      // Add a PageRouteBuilder to define the transition effect
                      settings: const RouteSettings(name: 'home'),
                      fullscreenDialog: true, // Set this to true if you want a modal dialog transition
                      maintainState: true,
                    ),
                  );
                },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
