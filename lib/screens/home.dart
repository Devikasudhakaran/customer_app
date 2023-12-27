import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:geolocator/geolocator.dart';


import '../model_class/add_location_response.dart';
import '../provider/location_api_provider.dart';
import 'captured_image.dart';

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
  String location = "";
  bool servicePermission = false;
  late LocationPermission permission;
  bool isTextScanned = false;
  bool isLoading = false;
  bool isLocationValid = false;
  String latitude = "";
  String longitude = "";
  List<SpaceTagsList>? spaceTagsList;



  void getImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        if (!isTextScanned) {
          getRecognisedText(pickedImage);
          getLocation();
          await callAddLocation();
          navigateToCaptureScreen(spaceTagsList);
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
    RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );
    await textRecognizer.close();
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scanningText = scanningText + line.text;
      }
    }
    textScanning = false;
    setState(() {});
  }

  Future<void> callAddLocation() async {
    print('callAddLocation');
    try {
      var response = await PhpService().addLocation(latitude, longitude);
      print('fff');
      if (response?.statuscode == 200) {
        // Successful response
        if (response?.spaceTagsList != null &&
            response!.spaceTagsList!.isNotEmpty) {
          // Valid pay and park, proceed
          setState(() {
            isLocationValid = true;
            spaceTagsList = response.spaceTagsList;
          });
        } else {
          // Not a valid pay and park,
          setState(() {
            isLocationValid = false;
          });
          // Show a dialogue box if needed
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text(
                  "The provided location is not a valid pay and park.",
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  getLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print('service disabled');
    }
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permission denied');
    }
    try {
      Position position =
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      print('ss');
      print(position);
      print('ser');
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();

      setState(() {});
    } catch (e) {
      location = "Error fetching location";
      setState(() {});
    }
  }


  void navigateToCaptureScreen(List<SpaceTagsList>? spaceTagsList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaptureScreen(
          imageFile: imageFile!,
          scanningText: scanningText,
          location: location,
          isLocationValid: isLocationValid,
          spaceTagsList: spaceTagsList,
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
                              const Expanded(
                                child: Text('Take a snap of your parked vehicle'),
                              ),
                              GestureDetector(
                                onTap: getImage,
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Step(
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
                    const Step(
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