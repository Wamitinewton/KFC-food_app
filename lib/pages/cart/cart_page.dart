
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controlers/cart_controller.dart';
import 'package:food_delivery/controlers/popular_product_conroler.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:food_delivery/pages/home/main_home_page.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/colors.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';

import '../../base/no_data_page.dart';
import '../../controlers/recommended_product_controller.dart';
import '../../routes/route_helper.dart';


class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppIcon(icon: Icons.arrow_back_ios, iconColor: Colors.white,
                  backgroundColor: AppColors.mainColor,
                  iconSize: 24,),
                  SizedBox(width: 100,),
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(RouteHelper.getInitial());
                    },
                    child: AppIcon(icon: Icons.home_outlined, iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: 24,),
                  ),
                  AppIcon(icon: Icons.shopping_cart, iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: 24,)
                ],
          )),
          GetBuilder<CartController>(builder: (_cartController){
          return _cartController.getItems.length>0?
          Positioned(
              top: 100,
              left: 20,
              right: 20,
              bottom: 0,
              child: Container(
                margin: EdgeInsets.only(top: 15),
                //color: Colors.red,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: GetBuilder<CartController>(builder: (cartController){
                    var _cartList = cartController.getItems;
                    return  ListView.builder(
                        itemCount: _cartList.length,
                        itemBuilder: (_, index){
                          return Container(
                            width: double.maxFinite,
                            height: 100,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    var popularIndex = Get.find<PopularProductControler>()
                                        .popularProductList
                                        .indexOf(_cartList[index].product!);
                                    if(popularIndex>=0){
                                      Get.toNamed(RouteHelper.getPopularFood(popularIndex, "cartpage"));
                                    }else{
                                      var recommendedIndex = Get.find<RecommendedProductController>()
                                          .recommendedProductList
                                          .indexOf(_cartList[index].product!);
                                      if(recommendedIndex<0){
                                        Get.snackbar("History product", "Bidhaa haipo kwa History products!",
                                          backgroundColor: Color(0xFF89dad0),
                                          colorText: Colors.white,);
                                      }else{
                                        Get.toNamed(RouteHelper.getRecommendedFood(recommendedIndex, "cartpage"));
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                AppConstants.BASE_URL+AppConstants.UPLOAD_URL+cartController.getItems[index].img!
                                            )
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(child: Container(
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      BigText(text: cartController.getItems[index].name!, color: Colors.black54,),
                                      SmallText(text: "spicy"),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          BigText(text: cartController.getItems[index]!.price.toString(), color: Colors.redAccent,),
                                          Container(
                                            padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.white
                                            ),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                    onTap:(){
                                                      cartController.addItem(_cartList[index].product!, -1);
                                                      print("being tapped");
                                                    },
                                                    child: Icon(Icons.remove,color: AppColors.signColor,)),
                                                SizedBox(width: 5,),
                                                BigText(text: _cartList[index].quantity.toString()),//popularProduct.inCartItems.toString()),
                                                SizedBox(width: 5,),
                                                GestureDetector(
                                                    onTap: (){
                                                      //popularProduct.setQuantity(true);
                                                      cartController.addItem(_cartList[index].product!, 1);
                                                    },
                                                    child: Icon(Icons.add,color: AppColors.signColor ,)),

                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          );
                        });
                  },),
                ),
              )):NoDataPage(text: "your cart is empty!");
          })
        ],
      ),
      bottomNavigationBar: GetBuilder<CartController>(builder: (cartController){
        return Container(
          height: 120,
          padding: EdgeInsets.only(top: 30, bottom: 30,left: 20,right: 20),
          decoration: BoxDecoration(
              color: AppColors.buttonBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40)
              )
          ),
          child: cartController.getItems.length>0?Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: 20,bottom: 20,left: 20,right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
              ),
              child: Row(
                children: [
                  SizedBox(width: 5,),
                  BigText(text: "KSh "+cartController.totalAmount.toString()),
                  SizedBox(width: 5,),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                // popularProduct.addItem(product);
                cartController.addToHistory();
              },
              child: Container(
                padding: EdgeInsets.only(top: 20,bottom: 20,left: 20,right: 20),

                child: BigText(text: 'Check out',color: Colors.white,),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.mainColor
                ),
              ),
            )
          ],
        ):Container(),
        );
      }),
    );
  }
}
