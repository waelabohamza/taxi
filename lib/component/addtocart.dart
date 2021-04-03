import 'package:flutter/material.dart';


class AddToCart with ChangeNotifier {

  List _itemsnoreapt = [];

  double _price = 0;

  Map quantity = {};

  Map active = {};

  double _pricedelivery = 0;

 
  Map listpricedelivery = {}   ; 


  List listres = [] ; 

  bool showalert = false  ;  
 

  void add(items) {
   
   

     if (listres.isEmpty) {
          listres.add(items['res_id']) ; 
     }else {
    
     }

      List resault = listres.where((element) => int.parse(element[0]) == int.parse(items['res_id']) ).toList() ; 

      if (resault.isNotEmpty) {
        
         showalert = false  ; 
    
          active[items['item_id']] = 1;

          _price += double.parse(items['item_price'].toString());

          if (quantity[items['item_id']] == null || quantity[items['item_id']] == 0) {

            _itemsnoreapt.add(items);

            quantity[items['item_id']] = 1;

          } else {

            quantity[items['item_id']] = quantity[items['item_id']] + 1;

          }


          if (listpricedelivery[items['res_id']] != double.parse(items['res_id'].toString())) {

          listpricedelivery[items['res_id']] = int.parse(items['res_id'].toString());
        
          _pricedelivery += double.parse(items['res_price_delivery'].toString());

        }


    }else {
 
         showalert = true ; 
    }

    print(listres[0]);
    print(resault);

    notifyListeners();
  }

  void remove(items) {

    if (quantity[items['item_id']] != null) {

      if (quantity[items['item_id']] == 1) {

        _itemsnoreapt
            .removeWhere((item) => item['item_id'] == items['item_id']);

        _itemsnoreapt.remove(items);

        active[items['item_id']] = 0;
      }

      if (quantity[items['item_id']] > 0) {

        _price -= double.parse(items['item_price'].toString());

        quantity[items['item_id']] = quantity[items['item_id']] - 1;

            var value =
            _itemsnoreapt.where((element) => element['res_id'] == items['res_id']);

        if (value.isEmpty) {
          listpricedelivery[items['res_id']] = 0;
          _pricedelivery -= double.parse(items['res_price_delivery'].toString());
          showalert = false  ; 
          listres.clear() ; 
        }

      }

      print(quantity);

      notifyListeners();
    }
  }

  void reset(items) {
      //  =====================================
    _itemsnoreapt.removeWhere((item) => item['item_id'] == items['item_id']);

    _price = _price -
        (double.parse(quantity[items['item_id']].toString()) *
            double.parse(items['item_price'].toString()));

    quantity[items['item_id']] = 0;

    // ===============

    active[items['item_id']] = 0;

        var value = _itemsnoreapt.where((element) => element['res_id'] == items['res_id']);

    if (value.isEmpty) {
       listpricedelivery[items['res_id']] = 0;
  
      _pricedelivery -= double.parse(items['res_price_delivery'].toString());
    
       listres.clear() ; 

          showalert = false  ; 


    }

    notifyListeners();

  }

  removeAll() {
    _itemsnoreapt.clear();
    _price = 0;
    quantity.clear();
    active.clear();
    listres.clear() ; 
    _pricedelivery = 0  ; 
    listpricedelivery.clear() ; 

  }

  double get totalprice {
    return _price;
  }

  List get basketnoreapt {
    return _itemsnoreapt;
  }

  double get totalpricedelivery {
    return _pricedelivery;
  }

  double get sumtotalprice {
    return _price + _pricedelivery;
  }

  // Color button change

}



 