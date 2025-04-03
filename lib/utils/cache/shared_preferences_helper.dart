import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _authTokenKey = 'auth_token';

  // Get token from SharedPreferences
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    print("Token retrieved: $token"); // Log the retrieved token
    return token;
  }

   // Save token to SharedPreferences
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
    print("Token saved: $token"); // Log the saved token
  }

  // Clear token from SharedPreferences
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
   print("Token cleared"); // Log the token clearance
  }
}