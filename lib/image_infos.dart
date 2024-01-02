import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_python/simple_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MyImageInfos extends StatelessWidget {

  MyImageInfos({super.key, required this.imagePath, required this.data});

  final String imagePath;
  final Map<String, dynamic> data;
  final FlutterTts flutterTts = FlutterTts();

  Future<File> loadImage(String path) async {
    return File(path);
  }

  Future<void> speakText(String text) async {
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  bool isSpeaking = false; // Track the speaking state

  // Function to stop text-to-speech
  Future<void> stopSpeaking() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: loadImage(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading image'));
          } else {
            return Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: const Text('Image Infos'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 140.0,
                      height: 140.0,
                      margin: const EdgeInsets.only(top: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Image.file(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal margin to the container
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Information About This Component :',
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: 'Times New Roman'),
                                ),
                                const SizedBox(height: 8.0),
                                const Text(
                                  'Component Name : ',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, fontFamily: 'Times New Roman'),
                                ),Text(
                                  '${data['message']['name']}',
                                  style: const TextStyle(fontSize: 16.0, fontFamily: 'Times New Roman'),
                                ),
                                const SizedBox(height: 8.0),
                                const Text(
                                  'Component Description : ',
                                  style: TextStyle(fontSize: 16.0, fontFamily: 'Times New Roman', fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.justify,
                                ),Text(
                                  '${data['message']['description']}',
                                  style: const TextStyle(fontSize: 16.0, fontFamily: 'Times New Roman'),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (!isSpeaking) {
                                    speakText('The component that you provided is ${data['message']['name']}. '
                                        'And I will give you some informations about it.'
                                        '${data['message']['description']}');
                                    isSpeaking = true;
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  padding: const EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.volume_up,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              ElevatedButton(
                                onPressed: () {
                                  // Redirect the user to MyHomePage
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const MyHomePage(title: '')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.brown,
                                  padding: const EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              ElevatedButton(
                                onPressed: () {
                                  // Stop the text-to-speech here
                                  stopSpeaking();
                                  isSpeaking = false;
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // Set the button background color to red
                                  padding: const EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.stop,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'We hope this was helpful',
                              style: TextStyle(fontSize: 14.0, fontFamily: 'Times New Roman', color: Colors.black38),
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
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }



}
