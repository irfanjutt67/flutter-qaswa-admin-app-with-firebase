import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
//
import '../../const/const.dart';
import '../../controller/auth_controller.dart';
import '../../controller/profile_controller.dart';
import '../../services/store_services.dart';
import '../auth_screen/login_screen.dart';
import '../message_screen/message_screen.dart';
import '../shop_screen/shop_setting_screen.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/test_style.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: settings, size: 16.0),
        actions: [
          TextButton(
              onPressed: () async {
                await Get.find<AuthController>().signoutMethod(context);
                Get.offAll(() => const LoginPage());
              },
              child: normalText(text: logout))
        ],
      ),
      body: FutureBuilder(
          future: StoreServices.getProfile(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator(circleColor: white);
            } else {
              controller.snapshotData = snapshot.data!.docs[0];

              return Column(
                children: [
                  //user detail section
                  ListTile(
                    leading: Hero(
                      tag: controller.snapshotData['imageUrl'],
                      child: controller.snapshotData['imageUrl'] == ''
                          ? Image.asset(icProfile, width: 100, fit: BoxFit.fill)
                              .box
                              .roundedFull
                              .clip(Clip.antiAlias)
                              .make()
                          : CachedNetworkImage(
                              placeholder: (context, url) => loadingIndicator(),
                              imageUrl:
                                  "${controller.snapshotData['imageUrl']}",
                              width: 100,
                            ).box.roundedFull.clip(Clip.antiAlias).make(),
                    ),
                    title: boldText(
                        text: "${controller.snapshotData['vaendor_name']}"),
                    subtitle:
                        normalText(text: "${controller.snapshotData['email']}"),
                    trailing: IconButton(
                        onPressed: () {
                          Get.to(
                            () => EditProfileScreen(
                              username: controller.snapshotData['vaendor_name'],
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, color: white)),
                  ),
                  const Divider(),
                  10.heightBox,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: List.generate(
                        profileButtonIcons.length,
                        (index) => ListTile(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Get.to(() => const ShopSettingScreen());
                                break;
                              case 1:
                                Get.to(() => const MessageScreen());
                                break;
                              default:
                            }
                          },
                          leading: Icon(
                            profileButtonIcons[index],
                            color: white,
                          ),
                          title: normalText(text: profileButtonTitles[index]),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
