import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication_key_manager.dart';

const _prefsKey = 'serverpod_userinfo_key';

/// The [SessionManager] keeps track of and manages the signed-in state of the
/// user. Use the [instance] method to get access to the singleton instance.
/// Users are typically authenticated with Google, Apple, or other methods.
/// Please refer to the documentation to see supported methods. Session
/// information is stored in the shared preferences of the app and persists
/// between restarts of the app.
class SessionManager with ChangeNotifier {
  static SessionManager? _instance;

  Caller caller;
  late AuthenticationKeyManager keyManager;

  SessionManager({
    required this.caller,
  }) {
    _instance = this;
    assert(caller.client.authenticationKeyManager != null, 'The client needs an associated key manager');
    keyManager = caller.client.authenticationKeyManager!;
  }

  /// Returns a singleton instance of the session manager
  static Future<SessionManager> get instance async {
    assert(_instance != null, 'You need to create a SessionManager before the instance method can be called');
    return _instance!;
  }

  UserInfo? _signedInUser;

  /// Returns information about the signed in user or null if no user is
  /// currently signed in.
  UserInfo? get signedInUser => _signedInUser;
  set signedInUser(UserInfo? userInfo) {
    _signedInUser = userInfo;
    _storeSharedPrefs();
    notifyListeners();
  }

  /// Returns true if the user is currently signed in.
  bool get isSignedIn => signedInUser != null;

  Future<void> initialize() async {
    await _loadSharedPrefs();
    refreshSession();
  }

  /// Signs the user out from all connected devices. Returns true if successful.
  Future<bool> signOut() async {
    if (!isSignedIn)
      return true;

    try {
      await caller.status.signOut();
      signedInUser = null;
      notifyListeners();
      return true;
    }
    catch(e) {
      return false;
    }
  }

  /// Verify the current sign in status with the server and update the UserInfo.
  /// Returns true if successful.
  Future<bool> refreshSession() async {
    try {
      _signedInUser = await caller.status.getUserInfo();
      await _storeSharedPrefs();
      notifyListeners();
      return true;
    }
    catch(e) {
      return false;
    }
  }

  Future<void> _loadSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();

    var json = prefs.getString(_prefsKey);
    if (json == null)
      return;

    _signedInUser = Protocol.instance.createEntityFromSerialization(jsonDecode(json)) as UserInfo;
    notifyListeners();
  }

  Future<void> _storeSharedPrefs() async {
    var prefs = await SharedPreferences.getInstance();

    if (signedInUser == null) {
      await prefs.remove(_prefsKey);
    }
    else {
      await prefs.setString(_prefsKey, jsonEncode(signedInUser!.serialize()));
    }
  }

  Future<bool> uploadUserImage(ByteData image) async {
    if (_signedInUser == null)
      return false;

    try {
      var success = await caller.user.setUserImage(image);
      if (success) {
        _signedInUser = await caller.status.getUserInfo();
        notifyListeners();
        return true;
      }
      return false;
    }
    catch(e) {
      return false;
    }
  }
}