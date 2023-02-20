//
import '../../const/const.dart';
import '../../controller/products_controller.dart';
import '../widgets/cutom_textfield.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/test_style.dart';

class AddBrand extends StatelessWidget {
  const AddBrand({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();

    final aFormKey = GlobalKey<FormState>(); //key
    return Scaffold(
      backgroundColor: purpleColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: aFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                20.heightBox,
                customTextField(
                    hint: "eg. BMW",
                    label: addbrandName,
                    controller: controller.brandnamecontroller),
                20.heightBox,
                controller.isloading.value
                    ? loadingIndicator(circleColor: white)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () async {
                          if (aFormKey.currentState!.validate()) {
                            controller.isloading(true);
                            await controller.uploadBrand(context);
                          }
                        },
                        child: boldText(text: save, color: white),
                      ).box.rounded.make()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
