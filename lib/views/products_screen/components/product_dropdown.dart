import 'package:qaswa_admin/const/const.dart';
import 'package:qaswa_admin/controller/products_controller.dart';
import 'package:qaswa_admin/views/widgets/test_style.dart';

Widget productDrown(
    hint, List<String> list, dropvalue, ProductsController controller) {
  return Obx(
    () => DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: normalText(text: "$hint", color: fontGrey),
        value: dropvalue.value == '' ? null : dropvalue.value,
        isExpanded: true,
        items: list.map((e) {
          return DropdownMenuItem(value: e, child: e.toString().text.make());
        }).toList(),
        onChanged: (newValue) {
          if (hint == "Category") {
            controller.subcategoryvalue.value = '';
            controller.populatesubCategoryList(newValue.toString());
          }
          dropvalue.value = newValue.toString();
        },
      ),
    )
        .box
        .white
        .roundedSM
        .padding(const EdgeInsets.symmetric(horizontal: 4))
        .make(),
  );
}
