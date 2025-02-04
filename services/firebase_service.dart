// lib/firebase_service.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_admin/firebase_admin.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  late final App _app;

  void initialize() {
    _app = FirebaseAdmin.instance.initializeApp(
      AppOptions(
        credential: Credentials.applicationDefault()!
        
        ,
        // credential: Credentials. fromJson(
        //   json.decode(<your-service-account-json-here>),
        // ),
      ),
    );
  }

/*
 Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      FirebaseAdmin.instance.certFromPath(path)
      await FirebaseAdmin.instance.messaging().send(
        Message(
          token: token,
          notification: Notification(
            title: title,
            body: body,
          ),
        ),
      );
      print("Notification sent successfully!");
    } catch (e) {
      print("Failed to send notification: $e");
    }
  }
*/

  App get app => _app;










  
//get the access token with the .json file downloaded from google cloud console
  Future<String> _getAccessToken() async {
    try {
      //the scope url for the firebase messaging
      const firebaseMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      //get the service account from the environment variables or from the .env file where it has been stored.
      //it is advised not to hardcode the service account details in the code
     
      final client = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson(
            {
   
  }
          ),
          [firebaseMessagingScope],);

      final accessToken = client.credentials.accessToken.data;
      log('YOUR TOKEN $accessToken');
      return accessToken;
    } catch (_) {
      //handle your error here
      throw Exception('Error getting access token');
    }
  }




// SEND NOTIFICATION TO A DEVICE
  Future<bool> sendNotification(
      {required String recipientFCMToken,
      required String title,
      required String body,}) async {
    final accessToken = await _getAccessToken();
    //Input the project_id value in the .json file downloaded from the google cloud console
    const projectId = 'INPUT project_id VALUE HERE';
    const fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/$projectId';
    final url = Uri.parse('$fcmEndpoint/messages:send');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final reqBody = jsonEncode(
      {
        'message': {
          'token': recipientFCMToken,
          'notification': {'body': body, 'title': title},
          'android': {
            'notification': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
          },
          'apns': {
            'payload': {
              'aps': {'category': 'NEW_NOTIFICATION'},
            },
          },
        },
      },
    );

    try {
      final response = await http.post(url, headers: headers, body: reqBody);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      //handle your error here
      return false;
    }
  }

}
