// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'dart:io';
//
import '../../const/const.dart';
import '../../controller/profile_controller.dart';
import '../widgets/cutom_textfield.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/test_style.dart';

class EditProfileScreen extends StatefulWidget {
  String? username;
  EditProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.nameController.text = widget.username!;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: editProfile, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);

                      //if image is not selected
                      if (controller.profileImagePath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                        Get.back();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData['imageUrl'];
                      }

                      // check old password is same in data base
                      if (controller.snapshotData['password'] ==
                          controller.oldpassController.text) {
                        await controller.changeAuthPassword(
                          email: controller.snapshotData['email'],
                          password: controller.oldpassController.text,
                          newpassword: controller.newpassController.text,
                        );

                        // after check old password in data base than update
                        await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.newpassController.text);
                        VxToast.show(context, msg: "Updated Profile");
                        Get.back();
                      } else if (controller
                              .oldpassController.text.isEmptyOrNull &&
                          controller.newpassController.text.isEmptyOrNull) {
                        await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.snapshotData['password']);
                        VxToast.show(context, msg: "updated");
                        Get.back();
                      } else {
                        VxToast.show(context, msg: "Some error occured");
                        controller.isloading(false);
                      }
                    },
                    child: normalText(text: save)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // if data image url and controller path is empty

              Hero(
                tag: controller.snapshotData['imageUrl'],
                child: controller.snapshotData['imageUrl'] == '' &&
                        controller.profileImagePath.isEmpty
                    ? Image.asset(icProfile, width: 100, fit: BoxFit.contain)
                        .box
                        .roundedFull
                        .clip(Clip.antiAlias)
                        .make()
                    // if data is not empty but controller path is empty
                    : controller.snapshotData['imageUrl'] != '' &&
                            controller.profileImagePath.isEmpty
                        ? Image.network(controller.snapshotData['imageUrl'],
                                width: 100, fit: BoxFit.cover)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make()

                        // if both are empty
                        : Image.file(File(controller.profileImagePath.value),
                                width: 100, fit: BoxFit.cover)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make(),
              ),
              10.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: white),
                onPressed: () {
                  controller.changeImage(context);
                },
                child: normalText(text: changeImage, color: fontGrey),
              ),
              10.heightBox,
              const Divider(color: white),
              10.heightBox,
              customTextField(
                label: name,
                hint: 'eg. abcd',
                controller: controller.nameController,
              ),
              10.heightBox,
              Align(
                  alignment: Alignment.centerLeft,
                  child: boldText(text: "Change your Password")),
              10.heightBox,
              customTextField(
                label: password,
                hint: passwordHint,
                controller: controller.oldpassController,
              ),
              10.heightBox,
              customTextField(
                label: confirmPassword,
                hint: passwordHint,
                controller: controller.newpassController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
