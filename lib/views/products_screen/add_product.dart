import 'package:cloud_firestore/cloud_firestore.dart';
//
import '../../const/const.dart';
import '../../controller/products_controller.dart';
import '../../services/store_services.dart';
import '../widgets/cutom_textfield.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/test_style.dart';
import 'components/product_dropdown.dart';
import 'components/product_images.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var controller = Get.find<ProductsController>();
  bool _noCategorySelected = false;
  final addDataFormKey = GlobalKey<FormState>(); //ke

  Widget _dropDownButton() {
    return StreamBuilder(
        stream: StoreServices.getBrand(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            // var data = snapshot.data!.docs;
            return DropdownButtonHideUnderline(
              child: DropdownButton(
                  isExpanded: true,
                  value: controller.selectedValue,
                  hint: selectBrand.text.make(),
                  items: snapshot.data!.docs.map((e) {
                    return DropdownMenuItem<String>(
                        value: e['p_brand'], child: Text(e['p_brand']));
                  }).toList(),
                  onChanged: (selectedCat) {
                    setState(() {
                      controller.selectedValue = selectedCat;
                      _noCategorySelected = false;
                    });
                  }),
            )
                .box
                .white
                .roundedSM
                .padding(const EdgeInsets.symmetric(horizontal: 4))
                .make();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: boldText(text: "Add Product", color: white, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      if (addDataFormKey.currentState!.validate()) {
                        controller.isloading(true);
                        await controller.uploadImages();
                        // ignore: use_build_context_synchronously
                        await controller.uploadProducts(context);
                        Get.back();
                      }
                    },
                    child: boldText(text: save, color: white),
                  ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: addDataFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.heightBox,
                  customTextField(
                    hint: "eg. BMW",
                    label: "Product name",
                    controller: controller.pnamecontroller,
                  ),
                  10.heightBox,
                  _dropDownButton(),
                  5.heightBox,
                  if (_noCategorySelected == true) alert.text.color(red).make(),
                  10.heightBox,
                  customTextField(
                      hint: "eg. nice product",
                      label: "Description",
                      isDesc: true,
                      controller: controller.pdesccontroller),
                  10.heightBox,
                  customTextField(
                      hint: "eg. \$100",
                      label: "Price",
                      controller: controller.ppricecontroller),
                  10.heightBox,
                  customTextField(
                      hint: "eg. \$100",
                      label: "Discount Price",
                      controller: controller.discpricecontroller),
                  10.heightBox,
                  customTextField(
                      hint: "eg. 20",
                      label: "Quantity",
                      controller: controller.pquantitycontroller),
                  10.heightBox,
                  productDrown("Category", controller.categoryList,
                      controller.categoryvalue, controller),
                  10.heightBox,
                  productDrown("Subcategory", controller.subcategoryList,
                      controller.subcategoryvalue, controller),
                  10.heightBox,
                  const Divider(color: white),
                  boldText(text: "Choose product images"),
                  10.heightBox,
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                          3,
                          (index) => controller.pImagesList[index] != null
                              ? Image.file(
                                  controller.pImagesList[index],
                                  width: 100,
                                ).onTap(() {
                                  controller.pickImage(index, context);
                                })
                              : productImages(label: "${index + 1}").onTap(() {
                                  controller.pickImage(index, context);
                                })),
                    ),
                  ),
                  5.heightBox,
                  normalText(
                      text: "First image will be your display images",
                      color: lightGrey),
                  10.heightBox
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
