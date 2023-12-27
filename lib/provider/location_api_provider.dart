import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model_class/add_location_response.dart';


class PhpService {
    Future<AddLocation?> addLocation(String latitude,
        String longitude) async {
      var client = http.Client();


      Map<String, dynamic> input = {
        "latitude": latitude,
        "longitude": longitude,
      };
      var uri = 'https://devkokocustomerphpservices.kokonet.in/guest/get_space_tag_details';
      var url = Uri.parse(uri);
      print(input);
      try {
        var response = await client.post(
          url,
          body: json.encode(input),
          headers: {"Content-Type": "application/json"},
        );
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');



        if (response.statusCode == 200) {
          // print('service1');
          // Assuming AddVehicle is your model class, replace it with your actual class
          return AddLocation.fromJson(jsonDecode(response.body));
        } else {
          // Handle non-200 status code here
          print('Error: ${response.statusCode}');
          return null;
        }
      } catch (e) {
        // Handle network-related errors
        print('Error: $e');
        return null;
      } finally {
        client.close();
      }
    }
  }