import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_python/treed_viewer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:math';

import 'image_infos.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required String title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  String queryText = '';
  File? _image;
  late final Map<String, dynamic> data;
  late String filePath;

  // New method to send thi image to backend
  Future<bool> _getImageAndSendToBackend(String imgName) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) {
        return false; // User canceled image selection
      }

      setState(() {
        _image = File(pickedFile.path);
      });

      _imageIsBeingProcessed();

      // Save the image
      await _saveImage(imgName);

    // Save the image to Backend

      // backend endpoint
      final url = Uri.parse('http://100.103.177.230:5000/api/data');
      final request = http.MultipartRequest('POST', url)
        ..fields['Query'] = _textEditingController.text
        ..files.add(
          await http.MultipartFile.fromPath(
            'image',
            _image!.path,
            filename: 'image.jpg',
          ),
        );

      print("1 - # # # # #");
      final response = await request.send();
      print("2 - # # # # #");
      if (response.statusCode == 200) {
        print('Image successfully uploaded.');

        // Read and decode the response body
        final responseBody = await response.stream.bytesToString();
        print('Raw response: $responseBody');

        try {
          data = json.decode(responseBody);
          if (data['message'] == "The image is not clear. Please retry") {
            print(data['message']);
            return false;
          } else {
            print(data['message']['name']);
            print(data['message']['description']);
            return true;
          }
        } catch (error) {
          print('Error decoding JSON: $error');
          return false;
        }
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        print(await response.stream.bytesToString());
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  //New method to generate the name of image
  String generateRandomString() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(4, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }


  // New method to display loadig dialog message
  Future<void> _imageIsBeingProcessed() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Please wait. We are processing your image...'),
              ],
            ),
          ),
        );
      },
    );
  }

  //New method to tell the user that the image is not clear
  Future<void> _imageNotClear() async {
    // Capture the context before entering the asynchronous part
    var currentContext = context;

    // Show a dialog if the input is empty
    showDialog(
      context: currentContext, // Use the captured context
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('The image is not clear. Please retry'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                // Trigger a page reload by calling setState
                // You can replace this with your actual reload logic
                setState(() {});
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // New method to save the image piked
  Future<void> _saveImage(String fileName) async {
    try {
      if (_image != null) {
        final appDocDir = await getApplicationDocumentsDirectory();
        filePath = '${appDocDir.path}/$fileName.jpg';

        // Save to filesystem
        await _image!.copy(filePath);
      }
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  // New method to show the dialog message
  Future<void> _showDialogMessage(filePath) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Saved'),
          content: const Text('The image is saved successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the new window with the image path
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyImageInfos(imagePath: filePath, data: data,),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // New method to display the 3D model
  void _display3DModel(String modelPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThreeDViewer(modelPath: modelPath),
      ),
    );
  }

  // Method build to create the component of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 60.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      'assets/logo/logo_green.jpeg',
                      height: 140.0,
                      width: 180.0,
                    ),
                  ),
                ),
              ),
              const Text(
                'NB: Please take a clear picture',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13.0,
                  fontFamily: 'Times New Roman',
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String enteredText = generateRandomString();
                      // Continue with your logic for non-empty input
                      print('Entered Text: $enteredText');
                      bool test = await _getImageAndSendToBackend(enteredText);
                      print("##################################");
                      print(test);
                      // Close loading indicator
                      Navigator.of(context).pop();

                      if (test == true) {
                        _showDialogMessage(filePath);
                      } else {
                        _imageNotClear();
                      }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Take Picture and Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              /*
              if (_image != null)
                Image.file(
                  _image!,
                  height: 100,
                  width: 100,
                ),

               */
            ],
          ),
        ),
      ),
    );
  }


}