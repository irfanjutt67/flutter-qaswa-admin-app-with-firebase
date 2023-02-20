import 'package:cloud_firestore/cloud_firestore.dart';
//
import '../../const/const.dart';
import '../../controller/products_controller.dart';
import '../../services/store_services.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/tabel.dart';
import '../widgets/test_style.dart';
import 'editbrand.dart';

class BrandList extends StatefulWidget {
  const BrandList({
    Key? key,
  }) : super(key: key);

  @override
  State<BrandList> createState() => _BrandListState();
}

class _BrandListState extends State<BrandList> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();
    return Scaffold(
      backgroundColor: purpleColor,
      body: StreamBuilder(
          stream: StoreServices.getBrand(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "No data found".text.color(fontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;

              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                      defaultColumnWidth: const FlexColumnWidth(100.0),
                      border: TableBorder.all(
                          color: Colors.black, style: BorderStyle.solid),
                      children: [
                        TableRow(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                            ),
                            children: [
                              boldText(text: tablenumber)
                                  .box
                                  .padding(const EdgeInsets.all(12.0))
                                  .makeCentered(),
                              boldText(text: brandName)
                                  .box
                                  .padding(const EdgeInsets.all(12.0))
                                  .makeCentered(),
                              boldText(text: action)
                                  .box
                                  .padding(const EdgeInsets.all(12.0))
                                  .makeCentered(),
                            ]),
                        for (var index = 0; index < data.length; index++) ...[
                          buildRow(
                            id: index.toString(),
                            text: "${data[index]['p_brand']}",
                            icon: Icons.edit,
                            onPress: () {
                              Get.to(() => const EditBrand(), arguments: {
                                'p_brand': '${data[index]['p_brand']}',
                                'id': data[index].id,
                              });
                            },
                            icon1: Icons.delete,
                            onPress1: () {
                              dialogBox(context, controller, data, index);
                            },
                          )
                        ]
                      ]));
            }
          }),
    );
  }

  Future<dynamic> dialogBox(BuildContext context, ProductsController controller,
      List<QueryDocumentSnapshot<Object?>> data, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          child: AlertDialog(
            backgroundColor: red.withOpacity(0.9),
            title: const Text('Warning'),
            titleTextStyle: const TextStyle(
                color: white, fontSize: 18, fontWeight: FontWeight.bold),
            content: const Text('Are You Sure!'),
            contentTextStyle: const TextStyle(color: white),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      controller.deleteBrand(data[index].id);
                      VxToast.show(context, msg: "Brand Removed");
                      Get.back();
                    },
                    child: const Text('DELETE'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
