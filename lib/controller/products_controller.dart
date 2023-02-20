import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qaswa_admin/const/const.dart';
import 'package:qaswa_admin/controller/home_controller.dart';
import 'package:qaswa_admin/models/category_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class ProductsController extends GetxController {
  var isloading = false.obs;

  Object? selectedValue;
  late QueryDocumentSnapshot snapshotData;

  // text field controller for add products or data

  var pnamecontroller = TextEditingController();
  var pdesccontroller = TextEditingController();
  var ppricecontroller = TextEditingController();
  var pquantitycontroller = TextEditingController();
  var brandnamecontroller = TextEditingController();
  var discpricecontroller = TextEditingController();
  var categoryList = <String>[].obs;
  var subcategoryList = <String>[].obs;
  List<Category> category = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>.generate(3, (index) => null);

  //variable
  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;

  getCategory() async {
    var data = await rootBundle.loadString('lib/services/category_model.json');
    var cat = categoryModelFromJson(data);
    category = cat.categories;
  }

  populateCategoryList() {
    categoryList.clear();

    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populatesubCategoryList(cat) {
    subcategoryList.clear();

    var data = category.where((element) => element.name == cat).toList();

    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  //upload images in firebase

  uploadImages() async {
    pImagesLinks.clear();
    for (var item in pImagesList) {
      if (item != null) {
        var filename = basename(item.path);
        var destination = 'images/vendors/${currentUser!.uid}/$filename';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        pImagesLinks.add(n);
      }
    }
  }

  uploadProducts(context) async {
    var store = firestore.collection(productsCollection).doc();
    await store.set({
      'is_featured': false,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_brand': selectedValue,
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_desc': pdesccontroller.text.trim(),
      'p_name': pnamecontroller.text.trim(),
      'p_price': ppricecontroller.text.trim(),
      'p_discountprice': discpricecontroller.text.trim(),
      'p_quantity': pquantitycontroller.text.trim(),
      'p_seller': Get.find<HomeController>().username,
      'p_rating': "5.0",
      'vaendor_id': currentUser!.uid,
      'featured_id': '',
    });
    isloading(false);
    VxToast.show(context, msg: "Product Uploaded");
    clearProduct();
  }

  clearProduct() {
    pnamecontroller.clear();
    pdesccontroller.clear();
    ppricecontroller.clear();
    categoryvalue.value = "";
    subcategoryvalue.value = "";
    discpricecontroller.clear();
    pquantitycontroller.clear();
  }

  addFeatured(docid) async {
    firestore.collection(productsCollection).doc(docid).set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    }, SetOptions(merge: true));
  }

  removeFeatured(docid) async {
    await firestore.collection(productsCollection).doc(docid).set({
      'featured_id': '',
      'is_featured': false,
    }, SetOptions(merge: true));
  }

  removeProducts(docid) async {
    await firestore.collection(productsCollection).doc(docid).delete();
  }

  clearText() {
    brandnamecontroller.clear();
  }

  //Upload Brand start
  uploadBrand(context) async {
    var store = firestore.collection(brandCollection).doc();
    await store.set({
      'p_brand': brandnamecontroller.text.trim(),
      'vaendor_id': currentUser!.uid,
    });
    isloading(false);
    VxToast.show(context, msg: "Brand Uploaded");
    clearText();
  }
  //Upload Brand end

  // delete brand
  deleteBrand(docId) {
    return firestore.collection(brandCollection).doc(docId).delete();
  }

// Update brand
  updateBrand({brandname}) async {
    await firestore
        .collection(brandCollection)
        .doc(Get.arguments['id'].toString())
        .update({
      'p_brand': brandname,
    });

    isloading(false);
    clearText();
  }
}
