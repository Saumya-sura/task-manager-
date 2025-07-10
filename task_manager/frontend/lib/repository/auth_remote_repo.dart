import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:task_manager/constants/constant.dart';
import 'package:task_manager/model/user_model.dart';
import 'package:task_manager/services/services.dart';

class AuthRemoteRepository {
  final spService = SpService();

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print("Sending signup request to: ${Constants.backendUri}/auth/signup");
      print("Request body: {name: $name, email: $email, password: $password}");
      final res = await http.post(
        Uri.parse(
          '${Constants.backendUri}/auth/signup',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.body}");

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      try {
        print("Trying to parse signup response body: ${res.body}");
        print("Response body type: ${res.body.runtimeType}");
        
        if (res.body.isEmpty) {
          throw "Empty response body";
        }
        
        final Map<String, dynamic> jsonData = jsonDecode(res.body);
        print("Successfully parsed JSON data: $jsonData");
        
        // Check if there's a nested user object
        if (jsonData['user'] != null) {
          final userData = jsonData['user'];
          print("User data from response: $userData");
          
          // Add the token to the user data if it exists separately in the response
          if (jsonData['token'] != null && userData['token'] == null) {
            userData['token'] = jsonData['token'];
          }
          
          return UserModel.fromMap(userData);
        } else {
          // For the response format: {"token":"...", "id":"...", "name":"...", ...}
          print("No nested user object found, using whole response");
          
          // Ensure we have the right format for the UserModel
          final processedData = {
            'id': jsonData['id'] ?? '',
            'email': jsonData['email'] ?? '',
            'name': jsonData['name'] ?? '',
            'token': jsonData['token'] ?? '',
            'createdAt': jsonData['created_at'] ?? DateTime.now().toIso8601String(),
            'updatedAt': jsonData['updated_at'] ?? DateTime.now().toIso8601String(),
          };
          
          print("Processed data for UserModel: $processedData");
          return UserModel.fromMap(processedData);
        }
      } catch (parseError) {
        print("Error parsing response: $parseError");
        throw "Failed to parse response: $parseError";
      }
    } catch (e) {
      print("Error during signup: $e");
      throw e.toString();
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      print("Sending login request to: ${Constants.backendUri}/auth/login");
      print("Request body: {email: $email, password: $password}");
      
      final res = await http.post(
        Uri.parse(
          '${Constants.backendUri}/auth/login',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.body}");

      // Accept both 200 and 201 status codes for successful login
      if (res.statusCode != 200 && res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      try {
        print("Trying to parse login response body: ${res.body}");
        print("Response body type: ${res.body.runtimeType}");
        
        if (res.body.isEmpty) {
          throw "Empty response body";
        }
        
        final Map<String, dynamic> jsonData = jsonDecode(res.body);
        print("Successfully parsed JSON data: $jsonData");
        
        // Check if there's a nested user object
        if (jsonData['user'] != null) {
          final userData = jsonData['user'];
          print("User data from response: $userData");
          
          // Add the token to the user data if it exists separately in the response
          if (jsonData['token'] != null && userData['token'] == null) {
            userData['token'] = jsonData['token'];
          }
          
          return UserModel.fromMap(userData);
        } else {
          // For the login response format: {"token":"...", "id":"...", "name":"...", ...}
          print("No nested user object found, using whole response");
          
          // Ensure we have the right format for the UserModel
          final processedData = {
            'id': jsonData['id'] ?? '',
            'email': jsonData['email'] ?? '',
            'name': jsonData['name'] ?? '',
            'token': jsonData['token'] ?? '',
            'createdAt': jsonData['created_at'] ?? DateTime.now().toIso8601String(),
            'updatedAt': jsonData['updated_at'] ?? DateTime.now().toIso8601String(),
          };
          
          print("Processed data for UserModel: $processedData");
          return UserModel.fromMap(processedData);
        }
      } catch (parseError) {
        print("Error parsing login response: $parseError");
        throw "Failed to parse login response: $parseError";
      }
    } catch (e) {
      print("Error during login: $e");
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        print("No token found, user is not logged in");
        return null;
      }

      print("Validating token: $token");
      final res = await http.post(
        Uri.parse(
          '${Constants.backendUri}/auth/tokenIsValid',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      print("Token validation response: ${res.statusCode}, ${res.body}");
      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        print("Token is invalid or expired");
        return null;
      }

      print("Token is valid, fetching user data");
      final userResponse = await http.get(
        Uri.parse(
          '${Constants.backendUri}/auth',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      print("User data response: ${userResponse.statusCode}, ${userResponse.body}");
      if (userResponse.statusCode != 200) {
        throw jsonDecode(userResponse.body)['error'];
      }

      try {
        print("Parsing user data response");
        if (userResponse.body.isEmpty) {
          throw "Empty user data response";
        }
        
        return UserModel.fromJson(userResponse.body);
      } catch (parseError) {
        print("Error parsing user data: $parseError");
        return null;
      }
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }
}