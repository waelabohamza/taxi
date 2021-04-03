import 'dart:async';

import 'package:taxi/component/alert.dart';
import 'package:taxi/component/crud.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:taxi/component/distancebetween.dart';
import 'package:taxi/component/polyline.dart';
// import 'dart:async';
import 'dart:math';
import 'package:taxi/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Delivery extends StatefulWidget {
  final userid;
  final lat;
  final long;
  final destlat;
  final destlong;
  final orderid;
  final statusorders;
  Delivery({
    Key key,
    this.lat,
    this.long,
    this.orderid,
    this.statusorders,
    this.destlat,
    this.destlong,
    this.userid,
  }) : super(key: key);

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  List<Marker> markers = [];
  GoogleMapController _controller;

  // current Location
  Location location = new Location();
  Crud crud = new Crud();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  // for polyline
  // Set<Polyline> polylineSet = {};
  // List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints = PolylinePoints();

  var currentlat;
  var currentlong;

  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor pinCustomerIcon;
  BitmapDescriptor pinTargetIcon;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/car.png');
  }

  void setCustomerPin() async {
    markers.add(Marker(
        markerId: MarkerId(Random().nextInt(1000).toString()),
        infoWindow: InfoWindow(title: "موقع الزبون"),
        position: LatLng(double.parse(widget.lat.toString()),
            double.parse(widget.long.toString())),
        draggable: true,
        onDragEnd: (ondragend) {
          print(ondragend);
        }));
  }

  void setTargetPin() async {
    markers.add(Marker(
        markerId: MarkerId(Random().nextInt(1000).toString()),
        infoWindow: InfoWindow(title: "الهدف"),
        position: LatLng(double.parse(widget.destlat.toString()),
            double.parse(widget.destlong.toString())),
        draggable: true,
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/newtarget.png'),
        onDragEnd: (ondragend) {
          print(ondragend);
        }));
  }

  getCurrentLocation() async {
    _locationData = await location.getLocation();
    // print("=================================") ;
    // print(_locationData.latitude) ;
    // print(_locationData.longitude) ;
    // print("=================================") ;

    markers.add(
      Marker(
          markerId: MarkerId("1"),
          infoWindow: InfoWindow(title: "موقعي الحالي"),
          position: LatLng(_locationData.latitude, _locationData.longitude),
          draggable: true,
          icon: pinLocationIcon,
          onDragEnd: (ondragend) {
            print(ondragend);
          }),
    );
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        // make changes here
      });
    }
  }

  doneDelivery() async {
    var data = {"ordersid": widget.orderid, "userid": widget.userid};
    showLoading(context);
    var responsebody = await crud.writeData("donedelivery", data);
    if (responsebody['status'] == "success") {
      Navigator.of(context).pushReplacementNamed("home");
    }
  }

  triggerdPolyLine() async {
    await getDirectionLocation(
        widget.lat, widget.long, widget.destlat, widget.destlong);
    setState(() {});
  }

  updateLocation() async {
    var data = {
      "taxiid": prefs.getString("id"),
      "long": currentlong.toString(),
      "lat": currentlat.toString()
    };
    var responsbody = await crud.writeData("updatelocation", data);

    print("========refresh update location 22");
    print(responsbody);
  }

  Timer _timer;
  @override
  void initState() {
    setCustomMapPin();
    setCustomerPin();
    setTargetPin();
    getCurrentLocation();
    super.initState();
    triggerdPolyLine();
    print(markers);
    location.onLocationChanged.listen((LocationData currentLocation) {
      currentlat = currentLocation.latitude;
      currentlong = currentLocation.longitude;
      updatePinMap(currentLocation);
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          // make changes here
        });
      }
      // Use current location
    });
    _timer = new Timer.periodic(
        Duration(seconds: 10), (Timer t) => updateLocation());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  updatePinMap(cl) {
    markers.removeWhere((element) => element.markerId.value == "1");
    markers.add(
      Marker(
          markerId: MarkerId("1"),
          infoWindow: InfoWindow(title: "موقعي الحالي"),
          position: LatLng(cl.latitude, cl.longitude),
          draggable: true,
          icon: pinLocationIcon,
          onDragEnd: (ondragend) {
            print(ondragend);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    double mdh = MediaQuery.of(context).size.height;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('توصيل الطلبية'),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30))),
            padding: EdgeInsets.all(20),
            height: 80,
            child: MaterialButton(
              child: Text("تم التوصيل",
                  style: TextStyle(color: Colors.blue, fontSize: 20)),
              onPressed: () async {
                var distance = await destanceBetweenDriving(
                    currentlat, currentlong, widget.destlat, widget.destlong);
                print(distance);
                if (distance > 50) {
                  showdialogall(context, "تنبيه", "لم تصل الى المكان المحدد") ; 
                } else {
                  await doneDelivery();
                }
              },
              color: Colors.white,
            ),
          ),
          body: WillPopScope(
              child: Stack(
                children: [
                  Container(
                      height: mdh,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(double.parse(widget.lat.toString()),
                                double.parse(widget.long.toString())),
                            zoom: 10),
                        markers: markers.toSet(),
                        onTap: (latlng) {},
                        onMapCreated: onMapCreated,
                        polylines:
                            polylineSet, //Set<Polyline>.of(polylines.values) ,
                        myLocationEnabled: true,
                        tiltGesturesEnabled: true,
                        compassEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                      )),
                  Positioned(
                      top: 50,
                      child: Container(
                        child: RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () async {
                            await launch(
                                "https://www.google.com/maps/dir/${widget.lat},${widget.long}/${widget.destlat},${widget.destlong}/@29.3643755,47.9921928,14z/data=!3m1!4b1");
                          },
                          child: Text("Google Map"),
                        ),
                      )),
                ],
              ),
              onWillPop: () {
                Navigator.of(context).pushReplacementNamed("home");
                return null;
              }),
        ));
  }

  onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }
}
