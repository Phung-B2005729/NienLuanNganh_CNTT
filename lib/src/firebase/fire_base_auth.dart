//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apparch/src/firebase/services/database_danhsachdoc.dart';
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
        .then((User) {
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
}
