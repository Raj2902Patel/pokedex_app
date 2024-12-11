import 'package:shared_preferences/shared_preferences.dart';

class DatabaseServices {
  DatabaseServices();

  Future<bool?> saveList(String key, List<String> value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setStringList(key, value);
      return result;
    } catch (error) {
      print("Error: ${error.toString()}");
    }

    return false;
  }

  Future<List<String>?> getList(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? result = prefs.getStringList(key);
      return result;
    } catch (error) {
      print("Error: ${error.toString()}");
    }

    return null;
  }
}
