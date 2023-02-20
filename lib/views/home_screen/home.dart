import '../../const/const.dart';
import '../../controller/home_controller.dart';
import '../order_screen/order_screen.dart';
import '../products_screen/products_screen.dart';
import '../profile_screen/profile_screen.dart';
import 'home_screen.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// for bottom nav start
    var controller = Get.put(HomeController());

    var navScreens = [
      const HomeScreen(),
      const ProductsScreen(),
      const OrderScreen(),
      const SettingsScreen()
    ];

    var bottomNavbar = [
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: dashboard,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icProducts, width: 24.0, color: darkGrey),
        label: products,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icOrders, width: 24.0, color: darkGrey),
        label: order,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icGeneralSettings, width: 24.0, color: darkGrey),
        label: settings,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            onTap: (index) {
              controller.navIndex.value = index;
            },
            currentIndex: controller.navIndex.value,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: purpleColor,
            unselectedItemColor: darkGrey,
            items: bottomNavbar,
          )),
      body: Column(
        children: [
          Obx(() => Expanded(
                child: navScreens.elementAt(controller.navIndex.value),
              )),

          /// for bottom nav end
        ],
      ),
    );
  }
}
