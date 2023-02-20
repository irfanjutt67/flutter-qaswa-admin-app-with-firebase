import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//
import '../../const/const.dart';
import '../../controller/products_controller.dart';
import '../../services/store_services.dart';
import '../brand/brand.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/test_style.dart';
import 'add_product.dart';
import 'components/floatingbuttons.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());

    return Scaffold(
      floatingActionButton: SpeedDial(
        //Speed dial menuottom
        icon: Icons.menu, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: Colors.deepOrangeAccent, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor:
            Colors.deepPurpleAccent, //background color when menu is expanded
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0, //shadow elevation of button
        shape: const CircleBorder(), //shape of button

        children: [
          speedDialChild(
              label: addroduct,
              icon: Icons.add,
              onPress: () async {
                await controller.getCategory();
                controller.populateCategoryList();
                Get.to(() => const AddProduct());
              }),
          speedDialChild(
              label: addbrandName,
              icon: Icons.branding_watermark,
              onPress: () {
                Get.to(() => const BrandScreens());
              }),
        ],
      ),
      appBar: appbarWidget(products),
      body: StreamBuilder(
          stream: StoreServices.getProducts(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else {
              var data = snapshot.data!.docs;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      children: List.generate(
                    data.length,
                    (index) => ListTile(
                      onTap: () {
                        Get.to(
                          () => ProductDetailScreen(
                            data: data[index],
                          ),
                          transition: Transition.downToUp,
                        );
                      },
                      leading: CachedNetworkImage(
                        placeholder: (context, url) => loadingIndicator(),
                        imageUrl: "${data[index]['p_imgs'][0]}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      title: boldText(
                          text: "${data[index]['p_name']}",
                          color: fontGrey,
                          size: 14.0),
                      subtitle: Row(
                        children: [
                          normalText(
                              text: "\$ ${data[index]['p_price']}",
                              color: darkGrey),
                          10.widthBox,
                          boldText(
                              text: data[index]['is_featured'] == true
                                  ? "Featured"
                                  : '',
                              color: green)
                        ],
                      ),
                      trailing: VxPopupMenu(
                          arrowSize: 0.0,
                          menuBuilder: () => Column(
                                children: List.generate(
                                  popupMenuTitles.length,
                                  (i) => Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            popupMenuIcons[i],
                                            color: data[index]['featured_id'] ==
                                                        currentUser!.uid &&
                                                    i == 0
                                                ? green
                                                : darkGrey,
                                          ),
                                          10.widthBox,
                                          normalText(
                                              text: data[index]
                                                              ['featured_id'] ==
                                                          currentUser!.uid &&
                                                      i == 0
                                                  ? 'Remove feature'
                                                  : popupMenuTitles[i],
                                              color: darkGrey)
                                        ],
                                      ).onTap(
                                        () {
                                          switch (i) {
                                            case 0:
                                              if (data[index]['is_featured'] ==
                                                  true) {
                                                controller.removeFeatured(
                                                    data[index].id);
                                                VxToast.show(context,
                                                    msg: "Removed");
                                              } else {
                                                controller.addFeatured(
                                                    data[index].id);
                                                VxToast.show(context,
                                                    msg: "Added");
                                              }
                                              break;
                                            case 1:
                                              controller.removeProducts(
                                                  data[index].id);
                                              VxToast.show(context,
                                                  msg: "Product Removed");
                                              break;
                                            default:
                                          }
                                        },
                                      )),
                                ),
                              ).box.white.width(200).rounded.make(),
                          clickType: VxClickType.singleClick,
                          child: const Icon(Icons.more_vert_rounded)),
                    ),
                  )),
                ),
              );
            }
          }),
    );
  }
}
