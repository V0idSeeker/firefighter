import 'dart:convert';

import 'package:http/http.dart';

import 'Fire.dart';
import 'Report.dart';

class DatabaseManeger {
  late Uri url;
  String geocodeApiAuth="741499549589927466382x105731";

  DatabaseManeger() {
    url = Uri.http("192.168.1.111", "api/index.php");
  }

  // account section
  Future<Map<String, dynamic>> logIn(String username, String password) async {

    var response = await post(url, body: {
      "username": username,
      "password": password,
      "command": "logIn",
    });
    if (response.statusCode != 200) return {"Error": "Connection error"};
    List<dynamic> decodedResponse = jsonDecode(response.body);

    if(decodedResponse[0]==null) return {"Error": "Invalid information "};
    return decodedResponse[0];
  }
  updateAccount(Map<String, dynamic> addAccountData) async {
    addAccountData["command"] ="updateAccount";
    var response = await post(url, body: addAccountData);

    print(response.body);
    Map<String ,dynamic> decodedResponse = jsonDecode(response.body);
    return decodedResponse["success"]==true;


  }

  //fire section

  //Fires section
  Future<List<Fire>> getActiveLocalFires(String  city) async {
    var response=await post(url,body: {
      "command": "getActiveLocalFires",
      "city": city
    });
    List<dynamic> decodedResponse = jsonDecode(response.body);
    List<Fire> listOfActiveFires = decodedResponse.map((item) {
      return Fire.fromMap(item);
    }).toList();
    return listOfActiveFires;
  }


  Future<bool> updateFireStatus (int fireId , int firefighterId , String newStatus)async{
    var response =await post(url ,body:{
      "command": "updateFireStatus",
      "fireId": fireId.toString(),
      "firefighterId": firefighterId.toString(),
      "newStatus" : newStatus.toString()
    });
    Map<String ,dynamic> decodedResponse = jsonDecode(response.body);
    print("dfdf $decodedResponse");
    return bool.parse(decodedResponse["success1"].toString()) && bool.parse(decodedResponse["success2"].toString());

  }

//only for user & fighter
  Future<bool> sendReport(Report report) async {
    var request = MultipartRequest('POST', url);
    //attaching data to the request
    report.toMap().forEach((key, value) async {
      request.fields["command"] = "addReport";
      //if its a file
      if (key == "resourcePath" || key == "audioPath") {
        if (value != null)
          request.files.add(
            await MultipartFile.fromPath(
              key,
              value,
            ),
          );
      }
      //if its normal data

      else
        request.fields[key] = value.toString();
    });
    // Add the image file to the request

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await Response.fromStream(streamedResponse);

      // Check if the upload was successful
      if (response.statusCode == 200) {


      } else {
        print('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }

    return true;
  }



//geolocator api section
  latLongToCity(double lat, double long) async {
    Uri geo = Uri.http("geocode.xyz", "${lat},$long",
        {"geoit": "json", "auth": geocodeApiAuth});
    var response = await get(geo);
    dynamic decodedResponse = jsonDecode(response.body);
    return {
      "city": decodedResponse["city"],
      "addr": decodedResponse["staddress"]
    };
  }
  cityToLatLang(String city) async {
    Uri geo = Uri.http("geocode.xyz", "$city",
        {"geoit": "json", "auth": geocodeApiAuth});
    var response = await get(geo);
    dynamic decodedResponse = jsonDecode(response.body);
    return {
      "positionLong": decodedResponse["longt"],
      "positionLat": decodedResponse["latt"]
    };
  }
  infoChecker(String? city , String username , String password ,String id) async {

    var response = await post(url,body: {
      "command":"checkInInfoAvailability",
      "username": username,
      "password": password,
      "accountId":id.toString()
    });
    Map<String ,dynamic> bdresponse = jsonDecode(response.body);
    if(city!=null){
      Uri geo = Uri.http("geocode.xyz", "$city",
          {"geoit": "json", "auth": geocodeApiAuth});
      response = await get(geo);
      Map<String ,dynamic> georesponse = jsonDecode(response.body);
      bdresponse["city"]=georesponse["standard"]==null ?null :georesponse["standard"]["city"];
    }



     return bdresponse;

  }





}
