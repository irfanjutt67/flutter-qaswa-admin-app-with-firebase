import 'package:get/get.dart';

import '../const/firebase_conts.dart';

class HomeController extends GetxController {
  // here execute the getusername method start
  @override
  void onInit() {
    getUsername();
    super.onInit();
  }
  // here execute the getusername method end

  /// for bottom nav start
  var navIndex = 0.obs;

  /// for bottom nav end

// for get seller name start

  var username = '';

  getUsername() async {
    var n = await firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['vaendor_name'];
      }
    });
    username = n;
  }

  // for get seller name end
}
