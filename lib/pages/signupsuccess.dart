import 'package:flutter/material.dart';

class SignUpSuccess extends StatefulWidget {
  SignUpSuccess({Key key}) : super(key: key);

  @override
  _SignUpSuccessState createState() => _SignUpSuccessState();
}

class _SignUpSuccessState extends State<SignUpSuccess> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 20),
                  child: Text(
                    " تمت عملية التسجيل بنجاح!  ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                ),
                            Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                  child: Text(
                    " قد تستغرق عملية الموافقة يوم كامل  ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/success.png",
                  ),
                ),
                Container(
                    child: MaterialButton(
                  color: Color(0xFF27ae60),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("login") ; 
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                    child: Text(
                      "تم العملية بنجاح",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ));
  }
}
