import 'dart:developer';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _tokenFCM = 'token_fcm';
  static const String _userRoleKey = "userRole";
  static const String _isSetUp = "isSetUp";
  static const String _userId = "userId";
  static const String _languageKey = 'language';
  static const String _cityKey = 'city';
  static const String _neighborhoodKey = 'neighborhood';
  static const String _isSubscribedKey = 'isSubscribed';
  static const String _subscriptionExpireAtKey = 'subscriptionExpireAt';
  static const String _subscriptionStatusKey = 'subscriptionStatus';

  static late SharedPreferences _preferences;

  static String? _token;
  static String? _fcmToken;
  static String? _userRole;
  static bool? _userSetUp;
  static String? _id;
  static String? _language;
  static List<String>? _city;
  static List<String>? _neighborhood;
  static bool? _isSubscribed;
  static DateTime? _subscriptionExpireAt;
  static String? _subscriptionStatus;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _language = _preferences.getString(_languageKey); // Load language
  }

  static Future<void> saveLanguage(String lang) async {
    await _preferences.setString(_languageKey, lang);
    _language = lang;
  }

  static String get language => _language ?? "French";

  static Future<void> inits() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences.getString(_tokenKey);
    _fcmToken = _preferences.getString(_tokenFCM);
    _userRole = _preferences.getString(_userRoleKey);
    _userSetUp = _preferences.getBool(_isSetUp);
    _id = _preferences.getString(_userId);

    // Read list values from SharedPreferences
    _city = _preferences.getStringList(_cityKey);
    _neighborhood = _preferences.getStringList(_neighborhoodKey);

    // Read subscription values
    _isSubscribed = _preferences.getBool(_isSubscribedKey);
    _subscriptionStatus = _preferences.getString(_subscriptionStatusKey);

    final String? expireDateStr = _preferences.getString(
      _subscriptionExpireAtKey,
    );
    if (expireDateStr != null && expireDateStr.isNotEmpty) {
      _subscriptionExpireAt = DateTime.tryParse(expireDateStr);
    }
  }

  static bool hasToken() {
    return _preferences.containsKey(_tokenKey) &&
        _token != null &&
        _token!.isNotEmpty;
  }

  // Save authentication token to persistent memory
  static Future<void> saveToken(String token) async {
    try {
      await _preferences.setString(_tokenKey, token);
      _token = token;
    } catch (e) {
      log('Error saving token: $e');
    }
  }

  // save Fcm token
  static Future<void> saveFCM(String token) async {
    try {
      await _preferences.setString(_tokenFCM, token);
      _fcmToken = token;
    } catch (e) {
      log('Error saving FCM token: $e');
    }
  }

  // Save the authenticated user's ID
  static Future<void> saveId(String id) async {
    try {
      await _preferences.setString(_userId, id);
      _id = id;
    } catch (e) {
      log('Error saving user id: $e');
    }
  }

  // Save user profile status configuration
  static Future<void> saveStatus(bool setUp) async {
    try {
      await _preferences.setBool(_isSetUp, setUp);
      _userSetUp = setUp;
    } catch (e) {
      log('Error saving onboarding status: $e');
    }
  }

  // Save the user access role permissions
  static Future<void> saveRole(String role) async {
    try {
      await _preferences.setString(_userRoleKey, role);
      _userRole = role;
    } catch (e) {
      log('Error saving user role: $e');
    }
  }

  // Save city as List<String>
  static Future<void> saveCity(List<String> cityList) async {
    try {
      await _preferences.setStringList(_cityKey, cityList);
      _city = cityList;
    } catch (e) {
      log('Error saving city list: $e');
    }
  }

  // Save neighborhood as List<String>
  static Future<void> saveNeighborhood(List<String> neighborhoodList) async {
    try {
      await _preferences.setStringList(_neighborhoodKey, neighborhoodList);
      _neighborhood = neighborhoodList;
    } catch (e) {
      log('Error saving neighborhood list: $e');
    }
  }

  // Save subscription status (bool)
  static Future<void> saveIsSubscribed(bool subscribed) async {
    try {
      await _preferences.setBool(_isSubscribedKey, subscribed);
      _isSubscribed = subscribed;
    } catch (e) {
      log('Error saving subscription status: $e');
    }
  }

  // Save subscription expiration date
  static Future<void> saveSubscriptionExpireAt(DateTime? expireAt) async {
    try {
      if (expireAt != null) {
        await _preferences.setString(
          _subscriptionExpireAtKey,
          expireAt.toIso8601String(),
        );
        _subscriptionExpireAt = expireAt;
      } else {
        await _preferences.remove(_subscriptionExpireAtKey);
        _subscriptionExpireAt = null;
      }
    } catch (e) {
      log('Error saving subscription expire date: $e');
    }
  }

  // Save subscription status text (e.g. "APPROVED", "PENDING", etc.)
  static Future<void> saveSubscriptionStatus(String? status) async {
    try {
      if (status != null && status.isNotEmpty) {
        await _preferences.setString(_subscriptionStatusKey, status);
        _subscriptionStatus = status;
      } else {
        await _preferences.remove(_subscriptionStatusKey);
        _subscriptionStatus = null;
      }
    } catch (e) {
      log('Error saving subscription status label: $e');
    }
  }

  // Destroys all stored configuration credentials and redirects out
  static Future<void> logoutUser() async {
    try {
      await deleteTokenRole();
      await goToLogin();
    } catch (e) {
      log('Error during user logout sequence: $e');
    }
  }

  // Clears persistent memory storage safe parameters keys
  static Future<void> deleteTokenRole() async {
    try {
      await _preferences.remove(_tokenKey);
      await _preferences.remove(_userRoleKey);
      await _preferences.remove(_isSetUp);
      await _preferences.remove(_userId);
      await _preferences.remove(_cityKey);
      await _preferences.remove(_neighborhoodKey);
      await _preferences.remove(_isSubscribedKey);
      await _preferences.remove(_subscriptionExpireAtKey);
      await _preferences.remove(_subscriptionStatusKey);

      // Clear runtime application references
      _token = null;
      _userRole = null;
      _userSetUp = null;
      _id = null;
      _city = null;
      _neighborhood = null;
      _isSubscribed = null;
      _subscriptionExpireAt = null;
      _subscriptionStatus = null;
    } catch (e) {
      log('Error deleting token data and roles: $e');
    }
  }

  static Future<void> goToLogin() async {
    Get.offAllNamed(AppRoutes.login);
  }

  // Getters
  static String? get token => _token;
  static String? get fcmToken => _fcmToken;
  static String? get userRole => _userRole;
  static bool? get userSetUp => _userSetUp;
  static String? get id => _id;
  static List<String>? get city => _city;
  static List<String>? get neighborhood => _neighborhood;
  static bool? get isSubscribed => _isSubscribed;
  static DateTime? get subscriptionExpireAt => _subscriptionExpireAt;
  static String? get subscriptionStatus => _subscriptionStatus;
}
