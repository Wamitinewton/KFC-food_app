
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../controlers/cart_controller.dart';
import '../../models/cart_model.dart';
import '../../utils/app_constants.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/colors.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var getCartHistoryList = Get.find<CartController>()
        .getCartHistoryList().reversed.toList();
    Map<String, int> cartItemPerOrder =Map();

    for(int i=0; i<getCartHistoryList.length; i++){
      if(cartItemPerOrder.containsKey(getCartHistoryList[i].time)){
        cartItemPerOrder.update(getCartHistoryList[i].time!, (value) =>++value);
      }else{
        cartItemPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
      }
    }

    List<int>cartItemsPerOrderToList(){
      return cartItemPerOrder.entries.map((e) => e.value).toList();
    }
    List<String>cartOrderTimeToList(){
      return cartItemPerOrder.entries.map((e) => e.key).toList();
    }

    List<int>itemsPerOrder = cartItemsPerOrderToList();

    var listCounter=0;

    Widget timeWidget(int index){
      var outputDate=DateTime.now().toString();
      if(index<getCartHistoryList.length){
        DateTime parseDate=DateFormat("yyy-MM-dd HH:mm:ss").parse(getCartHistoryList[listCounter].time!);
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat=DateFormat("MM/dd/yyy hh:mm a");
        outputDate = outputFormat.format(inputDate);
      }
        return BigText(text: outputDate);
    }
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            color: AppColors.mainColor,
            width: double.maxFinite,
            padding: EdgeInsets.only(top: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BigText(text: "your cart History",color: Colors.white,),
                AppIcon(icon: Icons.shopping_cart_outlined,
                  backgroundColor: AppColors.yellowColor,
                  iconColor:AppColors.mainColor ,)
              ],
            ),
          ),
          GetBuilder<CartController>(builder: (_cartController){
            return _cartController.getCartHistoryList().length>0? Expanded(child: Container(

                margin: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context, child: ListView(
                  children: [
                    for(int i=0;i<itemsPerOrder.length;i++)
                      Container(
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            timeWidget(listCounter),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: List.generate(itemsPerOrder[i], (index){
                                    if(listCounter<getCartHistoryList.length){
                                      listCounter++;
                                    }
                                    return index<=2?Container(
                                      height: 80,
                                      width: 80,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  AppConstants.BASE_URL+AppConstants.UPLOAD_URL+getCartHistoryList[listCounter-1].img!
                                              )
                                          )
                                      ),
                                    ):Container();
                                  }),
                                ),
                                Container(
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SmallText(text: "total", color: AppColors.titleColor),
                                      BigText(text: itemsPerOrder[i].toString()+" Items",color: AppColors.titleColor,),
                                      GestureDetector(
                                        onTap: (){
                                          var orderTime = cartOrderTimeToList();
                                          Map<int, CartModel> moreOrder={};
                                          for (int j=0; j<getCartHistoryList.length;j++){
                                            if(getCartHistoryList[j].time==orderTime[i]){
                                              moreOrder.putIfAbsent(getCartHistoryList[j].id!, () =>
                                                  CartModel.fromJson(jsonDecode(jsonEncode(getCartHistoryList[j])))
                                              );
                                            }
                                          }
                                          Get.find<CartController>().setItems=moreOrder;
                                          Get.find<CartController>().addToCartList();
                                          Get.toNamed(RouteHelper.getCartPage());
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(width: 1, color: AppColors.mainColor)
                                          ),
                                          child: SmallText(text: "more items",color: AppColors.mainColor,),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),

                      )
                  ],
                ),)
            ))
                :SizedBox(
              height: MediaQuery.of(context).size.height/1.5,
                child: const Center(
                  child: NoDataPage(text: "you didn't buy anything so far",
                    imgPath: "assets/image/empty_box.png",),
                ));
          })

        ],
      ),
    );
  }
}
