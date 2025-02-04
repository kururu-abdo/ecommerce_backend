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
    'type': 'service_account',
    'project_id': 'online-shop-d2eca',
    'private_key_id': '81251c465c6ee3f42f4187bbfa3c9c16f40efcdb',
    'private_key': '-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCC5RoitloZ0NP/\nuHcGrXSAak2YK98pVwJs/2Bh4PHd3QNiDaBVehve3akTBDj8ZJ+iWh/h6PweeNA5\nGzOCAOCQ3PeyA8PYtRfMNABQlbgPYGOExg+X5fjtxDY4Rzha5Rx5tYEZlJbNpfZb\nV9/0J4B2aVYuU3i0UTNJwCUgQdYlsVgWq0ismtOEaV/J1VIMnEUTIqC/Hd64sN4N\ncJ/WP7ZBwzsVbOYfPn4Ha3e53uIvjd6C/TEsfYnSNkwXtJdR2yeE9r8OZ7t2kt+0\n6JhDhkhGRsercz0s9HKIWgdpxqSbb6VYT1x+WbIlGGzyrE0cAWL62M8KtU8spSkJ\n4TvxKXDzAgMBAAECggEAOpEe6hQ0aWOmT7+uRicbPxARavqKTfl4BOQZMIJRRkeL\nKXbWXBiYWtZMPc2AX/H3+VEg/dhc4peE92BD4jHZSQgNrjGAEjkpDj3gPC5ZXkvv\nC2wBcyI7iMtnxTOctBLadFyxiIwTE63j9ofxlVGNaa4FGRJRKkFA1QlrsyyyEEfP\nRcN7q7sGHXuV/iKv6AIjwVWbHCkIR34OQQuQ4yra/FEnSjQmhSq5mvY345kWTGxQ\n/mJ/uA/5H+W/12dkEgh4BUX9qFu9k7VMDEZhvpMvoJHx2/GrTkSWhnL64CX0bjTt\nCM+lAMbocOFB0BPBACP+SheM7EYhds4kZMUH5xuyXQKBgQC3BBqtwAM3OsrO6677\nUUfAsQcYTuNfXO0d6VpVRhpw2/9U2Sz4RF8mj0C+cji9hCu4E0I0GHHVoAp4sKRw\njKe7PhjIJU7YUJlVzFUaXCTf7sKni8fvFNqCCdP3pjpBVWKKRxolmnx9Ab+FRrUn\neBEhLRoE683eA5jGQaMxPZzIDwKBgQC3GAO/k3j/2MILrqoloIYPBxrsHhN6eCXh\nVRHGIxKeIBn01EGQZ3YfeObaJFcEmnV6wnrMhBrZYiYrwDj7maMHg96E+5WU0A2h\nB6FMZ2sPuUa45PnM6xXBTqN0DQgua2rucxAoBfOx1VdainDc4AYu/Uc6tPeNMY4W\ntUAeOseE3QKBgHcNbG1qYq0iyZshJYrGrO5kOkFN0ArQ4E585g5itACGm+oN/Hrj\nvyHOPkek9dQSjn4HySEqZaKZoTYxckbkuJfNJUHNQyTkCVsOuK2VE0e4gVeMTlrw\nLdQ5oHGQ6IRnjtp0tkWP4TtQT83a2Sz7pej29d4NprWtkUwmlooJkltxAoGBAJbh\nDUWzy0RaZR2nY8L6Ez8TBdaJuldz5xNXPPxgLplrrrgYqabL+4VX5jThOWwrtJ/i\n37rlKhL1VKs9DjgXlUc+HgLMJ6moAXMvjHYfyxP8BBGdb1S0bQsNOJkLnDBUiJvS\n6f9xWC61tfSAnR0G51GVmjsAofcSXRrNZfcDTSNpAoGAET1g/UpEyjwyWcE32x7t\nws1vNu4rXPuLY1KoY/FvmshfB2bm5jB2NDU1yNCVCYiZvmBJHCT8gYi2TpTVDKrH\n7Es0XLPIvl+hRgHNR8GwqTSZwjwgj6wCqWTO/udGLukW6fJ/97gjLYBk2WwdmlOP\n/4X7bo3bdDzjJuDi+quJWG4=\n-----END PRIVATE KEY-----\n',
    'client_email': 'firebase-adminsdk-rkwnf@online-shop-d2eca.iam.gserviceaccount.com',
    'client_id': '108115846103954115450',
    'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
    'token_uri': 'https://oauth2.googleapis.com/token',
    'auth_provider_x509_cert_url': 'https://www.googleapis.com/oauth2/v1/certs',
    'client_x509_cert_url': 'https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-rkwnf%40online-shop-d2eca.iam.gserviceaccount.com',
    'universe_domain': 'googleapis.com',
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
