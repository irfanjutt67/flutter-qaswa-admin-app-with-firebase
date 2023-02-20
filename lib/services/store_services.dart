import 'package:qaswa_admin/const/const.dart';

class StoreServices {
  static getProfile(uid) {
    return firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .get();
  }

  // get messages
  static getAllmessage() {
    return firestore
        .collection(chatsCollection)
        .where('toId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  // get all chat messages

  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messageCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  // get orders
  //// arrayContains  only use for list  or aray
  static getOrders(uid) {
    return firestore
        .collection(ordersCollection)
        .where('vaendor_id', arrayContains: currentUser!.uid)
        .snapshots();
  }

  // get all Products

  static getProducts(uid) {
    return firestore
        .collection(productsCollection)
        .where('vaendor_id', isEqualTo: uid)
        .snapshots();
  }

  // get all category

  static getBrand(uid) {
    return firestore
        .collection(brandCollection)
        .where('vaendor_id', isEqualTo: uid)
        .snapshots();
  }
}
