//
import '../../const/const.dart';
import 'addbrand.dart';
import 'brandlist.dart';

class BrandScreens extends StatelessWidget {
  const BrandScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: red,
        appBar: AppBar(
          title: const Text(addbrandName),
          bottom: const TabBar(tabs: [
            Tab(
              text: "add",
            ),
            Tab(
              text: "List",
            )
          ]),
        ),
        body: const TabBarView(
          children: [
            AddBrand(),
            BrandList(),
          ],
        ),
      ),
    );
  }
}
