import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../const/const.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  // text Controller for login
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  // SignIn method

  Future<UserCredential?> signupMethod({context, email, password}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  // storing data method in firebase

  storeUserData({context, name, password, email}) async {
    DocumentReference store =
        firestore.collection(vendorsCollection).doc(currentUser!.uid);
    store.set(
      {
        'id': currentUser!.uid,
        'name': name,
        'password': password,
        'email': email,
        'imageUrl': '',
      },
    );
  }

  clearfield() {
    emailController.clear();
    passwordController.clear();
  }

  // SignOut method

  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
