import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:taxi/component/alert.dart';
import 'package:taxi/component/crud.dart';
import 'package:taxi/main.dart';

bool _serviceEnabled;
PermissionStatus _permissionGranted;
Location location = new Location();
LocationData locationData;


 requestPermissionLocation(BuildContext context) async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
        print("denied") ; 
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
          var title = "هام" ; 
          var content = "في حال لم تقم باعطاء الصلاحية لهذا التطبيق فانك لن تستطيع استخدام هذا التطبيق " ; 
        showdialogall(context, title, content ) ; 
        prefs.clear() ; 
        await Future.delayed(Duration(seconds: 5) , (){
                 Navigator.of(context).pushReplacementNamed("login") ;
        }) ;
        return;
      }
    }
      updateLocation()  ; 
  }

   updateLocation() async {
             Crud crud = new Crud() ; 
             var lat ; 
              var long ;
             locationData = await location.getLocation();
              lat =   locationData.latitude ; 
              long =  locationData.longitude ; 
              var userid = prefs.getString("id") ; 
              var data = { "taxiid" : userid.toString() , "lat" : lat.toString() , "long" : long.toString() }  ;  
              var  responsebody = await crud.writeData("updatelocation", data) ;  
              print("================================ refresh location") ; 
              print(responsebody) ; 
              print("================================") ; 
  }
