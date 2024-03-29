import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  // ignore: non_constant_identifier_names
  static String LoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String EmailKey = "USEREMAILKEY";
  static String IdUserKey = "IDUSER";
  static String avataKey = 'AVATAKEY';
  static String anhMacDinh = 'ANHMACDINH';
// tien trinh doc
  static void saveIdtruyenTienTrinh(String nameIdTruyen, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(nameIdTruyen, value);
  }

  static Future<int> getIdTruyenTienTrinh(String nameIdTruyen) async {
    final prefs = await SharedPreferences.getInstance();
    int tientrinh = prefs.getInt(nameIdTruyen) ?? -1;
    return tientrinh;
  }

//lich su
  static void saveLichSuTimKiem(List<String> LS, String iduser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(iduser, LS);
  }

  static Future<List<String>> getLishSuTimKiem(String iduser) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> myList = prefs.getStringList(iduser) ?? [];
    return myList;
  }

  // saving the data to SF
  static Future<bool> saveAnhMacDinh() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(anhMacDinh,
        'https://firebasestorage.googleapis.com/v0/b/apparch-351df.appspot.com/o/images%2F1696494580475.jpg?alt=media&token=7f48e133-6caa-45cb-807c-bfa42c46054b');
  }

  //login

  static Future<bool> saveLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(LoggedInKey, isUserLoggedIn);
  }

//username
  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }
  // ignore: non_constant_identifier_names

  static Future<bool> saveEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(EmailKey, userEmail);
  }
  //id

  static Future<bool> saveUserID(String userID) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(IdUserKey, userID);
  }

//avata
  static Future<bool> saveAvataSF(String avata) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(avataKey, avata);
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

  static Future<String?> getUserID() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(IdUserKey);
  }

  static Future<String?> getAvata() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(avataKey);
  }
}
