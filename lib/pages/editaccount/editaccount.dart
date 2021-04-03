import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:taxi/component/alert.dart';
import 'package:taxi/component/chooseuploadimage.dart';
import 'dart:io';
import 'package:taxi/component/crud.dart';
import 'package:taxi/component/preferences.dart';
import 'package:taxi/component/valid.dart';
// My Import
 

class EditAccount extends StatefulWidget {
  final userid;
  final password;
  final username;
  final email;
  final phone;

  EditAccount(
      {Key key,
      this.userid,
      this.email,
      this.password,
      this.username,
      this.phone})
      : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  File file;
  File myfile;

  bool loading = false;

  void _chooseGallery() async {
    final myfile = await ImagePicker().getImage(source: ImageSource.gallery);
    // For Show Image Direct in Page Current witout Reload Page
    if (myfile != null)
      setState(() {
        file = File(myfile.path);
      });
    else {}
  }

  void _chooseCamera() async {
    final myfile = await ImagePicker().getImage(source: ImageSource.camera);
    // For Show Image Direct in Page Current witout Reload Page
    if (myfile != null)
      setState(() {
        file = File(myfile.path);
      });
    else {}
  }

  Crud crud = new Crud();

  var username, password, email, phone;

  GlobalKey<FormState> settings = new GlobalKey<FormState>();

  editAccount() async {
    var formstate = settings.currentState;
    if (formstate.validate()) {
      setState(() {
        loading = true;
      });
      formstate.save();
      if (file != null) {
        if (loading == true) {
          showLoading(context);
        }
        var usersnew = await crud.editTaxiUsers(
            username, email, password, phone, widget.userid, true, file);
        if (usersnew['status'] == "Success") {
             savePref(usersnew['username'], usersnew['email'], usersnew['phone'], usersnew['password']);
        }
      } else {
        if (loading == true) {
          showLoading(context);
        }
        var usersnew = await crud.editTaxiUsers(
            username, email, password, phone, widget.userid, false);
        if (usersnew['status'] == "Success") {
          savePref(usersnew['username'], usersnew['email'], usersnew['phone'], usersnew['password']);
        }
      }
      setState(() {
        loading = false;
      });

      Navigator.of(context).pushReplacementNamed("home");
    } else {
      print("Not Valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: ChangeNotifierProvider(
          create: (context) {
            return Common();
          },
          child: Scaffold(
              appBar: AppBar(
                title: Text('اضافة عضو جديد'),
              ),
              body: ListView(
                children: <Widget>[
                  Form(
                      key: settings,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: widget.username,
                            onSaved: (val) {
                              username = val;
                            },
                            validator: (val) {
                              return validInput(
                                  val, 4, 20, "يكون اسم المستخدم");
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "الاسم",
                                prefixIcon: Icon(Icons.person)),
                          ),
                          TextFormField(
                            initialValue: widget.phone,
                            onSaved: (val) {
                              phone = val;
                            },
                            validator: (val) {
                              return validInput(val, 4, 20, "يكون رقم الهاتف");
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "الاسم",
                                prefixIcon: Icon(Icons.phone)),
                          ),
                          Consumer<Common>(
                            builder: (context, common, child) {
                              return TextFormField(
                                obscureText: common.showpass,
                                initialValue: widget.password,
                                validator: (val) {
                                  return validInput(
                                      val, 4, 20, "تكون كلمة المرور");
                                },
                                onSaved: (val) {
                                  password = val;
                                },
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: " كلمة المرور ",
                                    prefixIcon: Icon(Icons.vpn_key),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        common.changeShowPass();
                                      },
                                    )),
                              );
                            },
                          ),
                          TextFormField(
                            initialValue: widget.email,
                            onSaved: (val) {
                              email = val;
                            },
                            validator: (val) {
                              return validInput(val, 4, 40,
                                  " يكون البريد الالكتروني ", "email");
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "البريد الالكتروني",
                                prefixIcon: Icon(Icons.email)),
                          ),
                          RaisedButton(
                            color: file == null ? Colors.red : Colors.green,
                            child: Text(
                              "تعديل صورة",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              showbottommenu(context ,_chooseCamera , _chooseGallery );
                            },
                          ),
                          RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              "تعديل",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              editAccount();
                            },
                          )
                        ],
                      ))
                ],
              )),
        ));
  }
 
}

class Common with ChangeNotifier {
  bool showpass = true ;
  changeShowPass() {
    showpass = !showpass;
     notifyListeners() ; 
  }
}
