import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model_class/add_location_response.dart';

class CaptureScreen extends StatelessWidget {
    final XFile? imageFile;
    final String scanningText;
    final String location;
    final bool isLocationValid;
    List<SpaceTagsList>? spaceTagsList;

    CaptureScreen({
      Key? key,
      required this.imageFile,
      required this.scanningText,
      required this.location,
      required this.isLocationValid,
      this.spaceTagsList,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          // Use FutureBuilder to handle the loading state
          future: Future.delayed(Duration(seconds: 2)), // Replace with your async operation
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for the data
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Set color to white
                ),
              );
            } else {
              // Display the CaptureScreen content when the data is ready
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.file(File(imageFile!.path)),
                  const SizedBox(height: 10),
                  const Text(
                    'Vehicle Number',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    scanningText,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  if (spaceTagsList != null && spaceTagsList!.isNotEmpty)
                    Column(
                      children: [
                        Text(spaceTagsList![0].spaceName.toString(), style: const TextStyle(fontSize: 16, color: Colors.white),),
                        const SizedBox(height: 5,),
                        Text(spaceTagsList![0].address.toString(), style: const TextStyle(fontSize: 16, color: Colors.white),),
                      ],
                    ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {

                    },
                    child: Text(
                      'Park',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Adjust the value as needed
                        ),
                      ),
                      padding: MaterialStateProperty.all(const EdgeInsets.only(right: 40, left: 40)), // Adjust the value as needed
                    ),
                  ),
                ],
              );
            }
          },
        ),
      );
    }
  }