import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qaswa_admin/const/const.dart';
class OrdersController extends GetxController {
  var odersList = [];

  var confirmed = false.obs;
  var ondelivery = false.obs;
  var delivered = false.obs;

  getOrders(data) {
    odersList.clear();
    for (var item in data['orders']) {
      if (item['vaendor_id'] == currentUser!.uid) {
        odersList.add(item);
      }
    }
  }

  // change Status

  changeStatus({title, status, docID}) async {
    var store = firestore.collection(ordersCollection).doc(docID);
    await store.set({title: status}, SetOptions(merge: true));
  }
}
