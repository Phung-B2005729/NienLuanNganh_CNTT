import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  // ignore: non_constant_identifier_names
  static String LoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String fullNameKey = "FULLNAMEKEY";
  // ignore: non_constant_identifier_names
  static String EmailKey = "USEREMAILKEY";
  // ignore: non_constant_identifier_names
  static String IdUserKey = "IDUSER";
  static String avataKey = 'AVATAKEY';
  static String anhnenKey = 'ANHNENKEY';
  static String ngaysinhKey = 'DATAKEY';

  static String anhMacDinh = 'ANHMACDINH';
  // saving the data to SF
  static Future<bool> saveAnhMacDinh() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(anhMacDinh,
        'https://firebasestorage.googleapis.com/v0/b/apparch-351df.appspot.com/o/images%2F1696494580475.jpg?alt=media&token=7f48e133-6caa-45cb-807c-bfa42c46054b');
  }

  static Future<bool> saveLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(LoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }
  // ignore: non_constant_identifier_names

  static Future<bool> saveFullNameSF(String Name) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(fullNameKey, Name);
  }

  static Future<bool> saveEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(EmailKey, userEmail);
  }

  static Future<bool> saveUserID(String userID) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(IdUserKey, userID);
  }

  static Future<bool> saveAvataSF(String avata) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(avataKey, avata);
  }

  static Future<bool> saveAnhNenSF(String anh) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(anhnenKey, anh);
  }

  static Future<bool> saveDateSF(String date) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(ngaysinhKey, date);
  }

  // getting the data from SF

  static Future<bool?> getLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(LoggedInKey);
  }

  static Future<String?> getAnhMacDinh() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(anhMacDinh);
  }

  static Future<String?> getEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(EmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getFullNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(fullNameKey);
  }

  static Future<String?> getUserID() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(IdUserKey);
  }

  static Future<String?> getAvata() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(avataKey);
  }

  static Future<String?> getAnhNen() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(anhnenKey);
  }

  static Future<String?> getDate() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(ngaysinhKey);
  }
}
