import 'package:flutter/material.dart';
import 'package:food_delivery/controlers/cart_controller.dart';
import 'package:food_delivery/controlers/popular_product_conroler.dart';
import 'package:food_delivery/pages/home/main_home_page.dart';
import 'package:food_delivery/pages/splash/splash_page.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'controlers/recommended_product_controller.dart';
import 'helper/dependancies.dart'as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  Get.find<CartController>().getCartData();

  return GetBuilder<PopularProductControler>(builder: (_){
    return GetBuilder<RecommendedProductController>(builder: (_){
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Diemo',

        //home: SplashScreen(),

        initialRoute: RouteHelper.getSplashPage(),
        getPages: RouteHelper.routes,
      );
    });
  },);
  }
}
