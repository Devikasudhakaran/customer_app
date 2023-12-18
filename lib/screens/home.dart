import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

class CaptureScreen extends StatelessWidget {
  final XFile? imageFile;
  final String scanningText;
  final String location;

  const CaptureScreen({
    Key? key,
    required this.imageFile,
    required this.scanningText,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.file(File(imageFile!.path)),
          SizedBox(height: 20),
          Text(
            'Vehicle Number',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            scanningText,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            'Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            location,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  XFile? imageFile;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool textScanning = false;
  String scanningText = "";
  String location = "Fetching location...";
  bool isTextScanned = false;

  void getImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        if (!isTextScanned) {
          getRecognisedText(pickedImage);
          getLocation();
          // Navigate to CaptureScreen after getting the location
          navigateToCaptureScreen();
        }
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scanningText = "Error occurred while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scanningText = scanningText + line.text;
      }
    }

    textScanning = false;
    setState(() {});
  }

  void getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      location = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      setState(() {});
    } catch (e) {
      location = "Error fetching location";
      setState(() {});
    }
  }

  void navigateToCaptureScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaptureScreen(
          imageFile: imageFile!,
          scanningText: scanningText,
          location: location,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        width: 150,
                        height: 50,
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.directions_car,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Transform.rotate(
                  angle: -0.1,
                  child: Container(
                    padding: EdgeInsets.only(top: 40),
                    child: const Column(
                      children: [
                        Text(
                          'Your Parking is',
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                        Text(
                          'Free now !',
                          style: TextStyle(fontSize: 40, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                Stepper(
                  steps: [
                    Step(
                      title: Text("Step 1"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text('Take a snap of your parked vehicle'),
                              ),
                              GestureDetector(
                                onTap: getImage,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: Text("Step 2"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text('Scan your shopping bill'),
                              ),
                              Icon(Icons.qr_code_scanner, color: Colors.black),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: Text("Refund"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Refund'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Home(),
//   ));
// }
