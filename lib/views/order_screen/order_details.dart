// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
//
import '../../const/const.dart';
import '../../controller/order_controller.dart';
import '../widgets/our_button.dart';
import '../widgets/test_style.dart';
import 'components/order_place.dart';

class OrderDetail extends StatefulWidget {
  final dynamic data;
  const OrderDetail({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  var controller = Get.put(OrdersController());

  @override
  void initState() {
    controller.getOrders(widget.data);

    //store backend value in controller start

    controller.confirmed.value = widget.data['order_confirm'];
    controller.ondelivery.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];

    //store backend value in controller end
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back, color: darkGrey),
          ),
          title: boldText(text: 'Order details', color: fontGrey, size: 16.0),
        ),
        bottomNavigationBar: Visibility(
          visible: !controller.confirmed.value,
          child: SizedBox(
            height: 60,
            width: context.screenWidth,
            child: ourButton(
              color: green,
              onPress: () {
                controller.confirmed(true);
                controller.changeStatus(
                    title: 'order_confirm',
                    status: true,
                    docID: widget.data.id);
              },
              title: "Confirm Order",
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // order delivery status section

                Visibility(
                  visible: controller.confirmed.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      boldText(
                          text: "Order Status", color: fontGrey, size: 16.0),
                      SwitchListTile(
                        activeColor: green,
                        value: true,
                        onChanged: (value) {},
                        title: boldText(text: "Placed", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.confirmed.value,
                        onChanged: (value) {
                          controller.confirmed.value = value;
                          controller.changeStatus(
                              title: 'order_confirm',
                              status: value,
                              docID: widget.data.id);
                        },
                        title: boldText(text: "Confirmed", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.ondelivery.value,
                        onChanged: (value) {
                          controller.ondelivery.value = value;
                          controller.changeStatus(
                              title: 'order_on_delivery',
                              status: value,
                              docID: widget.data.id);
                        },
                        title: boldText(text: "on Delivery", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.delivered.value,
                        onChanged: (value) {
                          controller.delivered.value = value;
                          controller.changeStatus(
                              title: 'order_delivered',
                              status: value,
                              docID: widget.data.id);
                        },
                        title: boldText(text: "Delivered", color: fontGrey),
                      ),
                    ],
                  )
                      .box
                      .padding(const EdgeInsets.all(8))
                      .outerShadow
                      .white
                      .border(color: lightGrey)
                      .make(),
                ),

                // order detail section
                Column(
                  children: [
                    orderPlaceDetails(
                      d1: "${widget.data['order_code']}",
                      d2: "${widget.data['shipping_method']}",
                      title1: "Order Code",
                      title2: "Shipping Mathod",
                    ),
                    orderPlaceDetails(
                      d1: intl.DateFormat()
                          .add_yMd()
                          .format((widget.data['order_date'].toDate())),
                      d2: "${widget.data['payment_method']}",
                      title1: "Order Date",
                      title2: "Payment Mathod",
                    ),
                    orderPlaceDetails(
                      d1: "unpaid",
                      d2: "Order Places",
                      title1: "Payment Status",
                      title2: "payment Delivery",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // "Shipping Address".text.fontFamily(samibold).make(),
                              boldText(
                                  text: "Shipping Address", color: purpleColor),
                              "${widget.data['order_by_name']}".text.make(),
                              "${widget.data['order_by_email']}".text.make(),
                              "${widget.data['order_by_address']}".text.make(),
                              "${widget.data['order_by_city']}".text.make(),
                              "${widget.data['order_by_state']}".text.make(),
                              "${widget.data['order_by_phone']}".text.make(),
                              "${widget.data['order_by_postalcode']}"
                                  .text
                                  .make(),
                            ],
                          ),
                          SizedBox(
                            width: 130,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                boldText(
                                    text: "Total Amount", color: purpleColor),
                                boldText(
                                    text: "\$ ${widget.data['total_amount']}",
                                    color: red,
                                    size: 16.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).box.outerShadow.white.border(color: lightGrey).make(),
                const Divider(),
                10.heightBox,
                boldText(text: "Ordered Products", color: red, size: 16.0),
                10.heightBox,
                ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(controller.odersList.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderPlaceDetails(
                          title1: "${controller.odersList[index]['title']}",
                          title2: "\$ ${controller.odersList[index]['tprice']}",
                          d1: "${controller.odersList[index]['qty']}x",
                          d2: "Refundable",
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
