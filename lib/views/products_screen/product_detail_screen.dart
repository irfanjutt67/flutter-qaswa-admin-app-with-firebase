import '../../const/const.dart';
import '../widgets/test_style.dart';

class ProductDetailScreen extends StatelessWidget {
  final dynamic data;
  const ProductDetailScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: darkGrey),
        ),
        title: boldText(text: "${data['p_name']}", color: fontGrey, size: 16.0),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxSwiper.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              autoPlay: true,
              height: 350,
              itemCount: data['p_imgs'].length,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              itemBuilder: (context, index) {
                return Image.network(
                  data['p_imgs'][index],
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
            10.heightBox,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title and details section
                  boldText(
                      text: "${data['p_name']}", color: fontGrey, size: 16.0),
                  10.heightBox,
                  boldText(
                      text: "Brand: ${data['p_brand']}",
                      color: fontGrey,
                      size: 16.0),
                  10.heightBox,
                  Row(
                    children: [
                      boldText(
                          text: "${data['p_category']}",
                          color: fontGrey,
                          size: 16.0),
                      10.widthBox,
                      normalText(
                          text: "${data['p_subcategory']}",
                          color: fontGrey,
                          size: 16.0),
                    ],
                  ),

                  10.heightBox,

                  VxRating(
                    isSelectable: false,
                    value: double.parse(data['p_rating']),
                    onRatingUpdate: (value) {},
                    normalColor: textfieldGrey,
                    count: 5,
                    maxRating: 5,
                    size: 25,
                  ),
                  10.heightBox,
                  boldText(
                      text: '\$ ${data['p_price']}', color: red, size: 18.0),
                  10.heightBox,
                  boldText(
                      text: 'Discounted price \$ ${data['p_discountprice']}',
                      color: red,
                      size: 18.0),

                  //color action start

                  20.heightBox,
                  Column(
                    children: [
                      10.heightBox,
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child:
                                boldText(text: "Quantity : ", color: fontGrey),
                          ),
                          boldText(
                              text: "${data['p_quantity']}", color: fontGrey),
                        ],
                      ),
                    ],
                  ).box.white.padding(const EdgeInsets.all(8)).make(),
                  const Divider(),
                  20.heightBox,
                  boldText(text: "Description", color: fontGrey),
                  10.heightBox,
                  normalText(text: "${data['p_desc']}", color: fontGrey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
