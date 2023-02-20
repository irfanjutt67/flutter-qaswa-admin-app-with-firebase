import '../../const/const.dart';
import '../../controller/profile_controller.dart';
import '../widgets/cutom_textfield.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/test_style.dart';

class ShopSettingScreen extends StatelessWidget {
  const ShopSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: shopSettings, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      await controller.updateShops(
                        shopaddress: controller.shopAddressController.text,
                        shopnames: controller.shopNameController.text,
                        shopmobile: controller.shopMobileController.text,
                        shopwebsite: controller.shopWebsiteController.text,
                        shopdescription: controller.shopDescController.text,
                      );
                      // ignore: use_build_context_synchronously
                      VxToast.show(context, msg: "Shop Updated");
                    },
                    child: normalText(text: save)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              customTextField(
                  label: shopname,
                  hint: nameHint,
                  controller: controller.shopNameController),
              10.heightBox,
              customTextField(
                  label: address,
                  hint: shopAddresshint,
                  controller: controller.shopAddressController),
              10.heightBox,
              customTextField(
                  label: mobile,
                  hint: shopMobileHint,
                  controller: controller.shopMobileController),
              10.heightBox,
              customTextField(
                  label: website,
                  hint: shopWebsiteHint,
                  controller: controller.shopWebsiteController),
              10.heightBox,
              customTextField(
                  isDesc: true,
                  label: description,
                  hint: shopDescHint,
                  controller: controller.shopDescController),
            ],
          ),
        ),
      ),
    );
  }
}
