import 'dart:async';
import 'dart:io';
import 'package:taxi/component/alert.dart';
// import 'package:taxi/pages/delivery.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:taxi/component/crud.dart';

import 'package:taxi/component/getnotify.dart';
import 'package:taxi/pages/delivery.dart';
import 'package:taxi/main.dart';
// My Import

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var driverid = prefs.getString("id");
  Map data;
  Crud crud = new Crud();
  setLocal() async {
    await Jiffy.locale("ar");
  }

// Timer _timer;
  @override
  void initState() {
    data = {"driverid": driverid, "status": 0.toString()};
    setLocal();
    // _timer = new Timer.periodic(Duration(seconds: 30), (Timer t) =>     (this.mounted) ? setState(() {}) : ""  );
    super.initState();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                //  onPressed: () =>   Navigator.of(context).pop(true)  ,
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            child: driverid == null
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
                            "لا يوجد اي طلبات بانتظار الموافقة",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListOrders(
                              orders: snapshot.data[index],
                              crud: crud,
                              context: context,
                            );
                          },
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
            onWillPop: _onWillPop));
  }
}

class ListOrders extends StatelessWidget {
  final orders;
  final crud;
  final context;
  ListOrders({Key key, this.orders, this.crud, this.context}) : super(key: key);

  approveOrdersTaxi() async {
    Map data2 = {

      "ordersid"  : orders['orderstaxi_id']         ,
      "userid"    : orders['user_id'].toString()    , 
      "lat"       : orders['orderstaxi_lat']        , 
      "long"      : orders['orderstaxi_long']       , 
      "destlat"   : orders['orderstaxi_lat_dest']   , 
      "destlong"  : orders['orderstaxi_long_dest']  , 
      "taxiid"    : orders['orderstaxi_taxi']   
      
    };
    showLoading(context);
    var responsebody = await crud.writeData("approveorderstaxi", data2);
    if (responsebody['status'] == "success") {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Delivery(
            userid: orders['user_id'],
            orderid: orders['orderstaxi_id'],
            statusorders: 1.toString(),
            lat: orders['orderstaxi_lat'],
            long: orders['orderstaxi_long'],
            destlat: orders['orderstaxi_lat_dest'],
            destlong: orders['orderstaxi_long_dest']);
      }));
    } else {
      String title = "تنبيه";
      String content = "هناك مشكلة لم يتم الموافقة على الطلب حاول مجددا";
      showdialogall(context, title, content);
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushNamed("home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {},
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Container(
                margin: EdgeInsets.only(top: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              text:
                                  "${orders['orderstaxi_distancekm']} كيلو متر",
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
                    "بانتظار الموافقة",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.3),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "موافق",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          )),
                      onTap: approveOrdersTaxi // approveDelivery,
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
