import 'dart:async';
import 'package:taxi/pages/delivery.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:taxi/component/crud.dart';
import 'package:taxi/main.dart';
// My Import

class OrdersDoneDelivery extends StatefulWidget {
  OrdersDoneDelivery({Key key}) : super(key: key);

  @override
  _OrdersDoneDeliveryState createState() => _OrdersDoneDeliveryState();
}

class _OrdersDoneDeliveryState extends State<OrdersDoneDelivery> {
  
  var driverid = prefs.getString("id");
  Map data;
  Crud crud = new Crud();
  setLocal() async {
    await Jiffy.locale("ar");
  }
 
//  Timer _timer = new Timer.periodic(Duration(seconds: 60), (Timer t) =>  setsta);
  @override
  void initState() {
    data = {"driverid": driverid,"status" : 3.toString()};
    setLocal();
    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
            
            body: driverid == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : FutureBuilder(
                    future: crud.writeData("orders", data),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data[0] == "faild") {
                          return Center(
                              child: Text(
                            "لا يوجد اي طلبات تم توصيلها  ",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListOrders(
                              orders: snapshot.data[index],
                              driverid: driverid,
                              crud: crud,
                              context: context,
                            );
                          },
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ));
  }
}
class ListOrders extends StatelessWidget {
  final orders;
  final driverid;
  final crud;
  final context;
  ListOrders({Key key, this.orders, this.driverid, this.crud, this.context})
      : super(key: key);
 

  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {
             
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Container(
                margin: EdgeInsets.only(top: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(
                      "معرف الطلبية : ${orders['orderstaxi_id']}",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: "اسم الزبون : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['username']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ])),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: "هاتف الزبون  : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['user_phone']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ])),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: "مسافة الطلب   : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['orderstaxi_distancekm']} كيلو متر",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600))
                        ])),
                         RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: " السعر الكلي   : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['orderstaxi_price']} د.ك",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600))
                        ])),
                  ],
                ),
              ),
              trailing: Container(
                  margin: EdgeInsets.only(top: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${Jiffy(orders['orders_date']).fromNow()}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
            ),
 
            Container(
              padding:
                  EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 10),
              child: Row(
                children: [
                  Text(
                    "تم التوصيل",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Container(),
                  ) 
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
