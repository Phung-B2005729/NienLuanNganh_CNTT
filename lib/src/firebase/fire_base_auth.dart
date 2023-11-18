import 'package:firebase_auth/firebase_auth.dart';
import '../helper/helper_function.dart';
import 'services/database_user.dart';

class FirAuth {
  // ignore: prefer_final_fields
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  void registerUserWithEmailandPassword(
      // ignore: non_constant_identifier_names
      String UserName,
      String email,
      String password,
      Function onSuccess,
      Function(String) onRegisterError) async {
    // ignore: unused_local_variable
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      // ignore: unnecessary_null_comparison
      if (user != null) {
        // call our database service to update the user data.
        await DatabaseUser(uid: user.uid).savingUserData(UserName, email);
        //   await DatabaseDSDoc().createDanhSachDoc(user.uid, 'Thư viện');
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      // ignore: prefer_interpolation_to_compose_strings
      print('Lỗi đăng ký ' + e.toString());
      onSignUpErr(e.code, onRegisterError);
    }
  }

  // ignore: unused_element
  void onSignUpErr(String code, Function(String) onsigupError) {
    // ignore: avoid_print, prefer_interpolation_to_compose_strings

    if (code == "email-already-in-use") {
      // ignore: avoid_print, prefer_interpolation_to_compose_strings
      onsigupError("Email đã tồn tại");
    } else if (code == "invalid-email") {
      onsigupError("Email không hợp lệ");
    } else if (code == "weak-password") {
      onsigupError("Mật khẩu yếu");
    } else {
      onsigupError("SignUp fail, please try again");
    }
  }

// login
  void login(String email, String pass, Function onSuccess,
      Function(String mgg) onLoginError) {
    firebaseAuth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) {
      onSuccess();
    }).catchError((err) {
      onLoginError("Email hoặc password không chính xác");
    });
  }

// logout
  Future<void> logOut() async {
    try {
      await HelperFunctions.saveLoggedInStatus(false);
      await HelperFunctions.saveEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      // ignore: avoid_returning_null_for_void
      return null;
    }
  }

  // thay đổi email
  Future<void> updateEmai(
      String newEmail,
      String currentEmail,
      String currentPassword,
      Function onSuccesss,
      Function(String) onUpdateError) async {
    try {
      User user = firebaseAuth.currentUser!;
      AuthCredential credential = EmailAuthProvider.credential(
          email: currentEmail, password: currentPassword); // xác thực
      await user.reauthenticateWithCredential(credential);
      //
      await user.updateEmail(newEmail);

      onSuccesss();
    } on FirebaseAuthException catch (e) {
      // ignore: prefer_interpolation_to_compose_strings, avoid_print
      print('Lỗi cập nhật Email ' + e.toString());
      onUpdateErr(e.code, onUpdateError);
    }
  }

  // thay đổi pass
  Future<void> updatePassword(String newPassword, String currentPassword,
      String email, Function onSuccess, Function(String) onUpdateError) async {
    try {
      User user = firebaseAuth.currentUser!;
      AuthCredential credential = EmailAuthProvider.credential(
          email: email, password: currentPassword); // xác thực
      await user.reauthenticateWithCredential(credential);
      //
      await user.updatePassword(newPassword);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      // ignore: prefer_interpolation_to_compose_strings
      print('Lỗi cập nhật Password ' + e.toString());
      onUpdateErr(e.code, onUpdateError);
    }
  }

  // bắt lỗi update
  void onUpdateErr(String code, Function(String) onUpdateError) {
    // ignore: avoid_print, prefer_interpolation_to_compose_strings
    if (code == "email-already-in-use") {
      // ignore: avoid_print, prefer_interpolation_to_compose_strings
      onUpdateError("Email đã tồn tại");
      //
    } else if (code == "invalid-email") {
      onUpdateError("Email không hợp lệ");
      //
    } else if (code == 'requires-recent-login') {
      onUpdateError('reLogin');
      //
    } else if (code == "weak-password") {
      onUpdateError("Mật khẩu yếu");
      //
    } else if (code == 'wrong-password') {
      onUpdateError("Mật khẩu xác nhận không đúng");
    } else {
      onUpdateError("Lỗi, thử lại");
    }
  }
}
