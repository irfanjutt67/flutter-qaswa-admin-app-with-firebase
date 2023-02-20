import '../../const/const.dart';
import '../../controller/products_controller.dart';
import '../widgets/cutom_textfield.dart';

class EditBrand extends StatelessWidget {
  const EditBrand({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();
    TextEditingController noteController = TextEditingController();
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        title: editBrand.text.make(),
        backgroundColor: red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            10.heightBox,
            customTextField(
              hint: "eg. BMW",
              label: editBrand,

              controller: noteController
                ..text = Get.arguments['p_brand'].toString(),
              // controller: noteController,
            ),
            20.heightBox,
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  controller.isloading(true);
                  await controller.updateBrand(
                      brandname: noteController.text.trim());
                  // ignore: use_build_context_synchronously
                  VxToast.show(context, msg: "Updated Brand");
                  Get.back();
                },
                child: "Update".text.make())
          ],
        ),
      ),
    );
  }
}
