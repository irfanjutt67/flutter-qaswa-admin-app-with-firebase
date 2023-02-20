import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//
import '../../const/const.dart';
import '../../services/store_services.dart';
import '../products_screen/product_detail_screen.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/dashboard_button.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/test_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StreamBuilder(
                  stream: StoreServices.getProducts(currentUser!.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return loadingIndicator();
                    } else {
                      var data = snapshot.data!.docs;
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: dashboardButton(context,
                                title: products,
                                count: '${data.length}',
                                icon: icProducts),
                          ));
                    }
                  }),
              StreamBuilder(
                  stream: StoreServices.getOrders(currentUser!.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return loadingIndicator();
                    } else {
                      var data = snapshot.data!.docs;
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: dashboardButton(context,
                                title: order,
                                count: '${data.length}',
                                icon: icOrders),
                          ));
                    }
                  }),
            ],
          ),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StreamBuilder(
                  stream: StoreServices.getBrand(currentUser!.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return loadingIndicator();
                    } else {
                      var data = snapshot.data!.docs;
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: dashboardButton(context,
                                title: brandName,
                                count: '${data.length}',
                                icon: icOrders),
                          ));
                    }
                  }),
              dashboardButton(context, title: rating, count: 5, icon: icStar),
            ],
          ),
          10.heightBox,
          const Divider(),
          10.heightBox,
          boldText(text: popular, color: fontGrey, size: 16.0),
          20.heightBox,
          StreamBuilder(
              stream: StoreServices.getProducts(currentUser!.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return loadingIndicator();
                } else {
                  var data = snapshot.data!.docs;

                  data = data.sortedBy((a, b) =>
                      b['p_wishlist'].length.compareTo(a['p_wishlist'].length));
                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                      data.length,
                      (index) => data[index]['p_wishlist'].length == 0
                          ? const SizedBox()
                          : ListTile(
                              onTap: () {
                                Get.to(
                                    () => ProductDetailScreen(
                                          data: data[index],
                                        ),
                                    transition: Transition.rightToLeft);
                              },
                              leading: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    loadingIndicator(),
                                imageUrl: "${data[index]['p_imgs'][0]}",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              title: boldText(
                                  text: "${data[index]['p_name']}",
                                  color: fontGrey,
                                  size: 14.0),
                              subtitle: normalText(
                                  text: "\$ ${data[index]['p_price']}",
                                  color: darkGrey),
                            ),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
