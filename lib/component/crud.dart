import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'dart:io';

  String basicAuth = 'Basic ' + base64Encode(utf8.encode('TalabGoUser@58421710942258459:TalabGoPassword@58421710942258459'));
  Map<String, String> myheaders = {
    // 'content-type': 'application/json',
    // 'accept': 'application/json',
    'authorization': basicAuth
 };

class Crud {
  var server_name = "talabgo.com/food";
  // var server_name ="phpcloud-303817.uc.r.appspot.com";
  // const serverName = "phpcloud-303817.uc.r.appspot.com";
  // var server_name = "almotorkw.com/talabgo/food";

  // var server_name = "10.0.2.2:8080/food";

  // var server_name = "192.168.1.3:8080/food";

  readData(String type) async {
    var url;
   

    try {
      var response = await http.get(Uri.parse(url)  , headers: myheaders  );
      if (response.statusCode == 200) {
        print(response.body);
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("page not found");
      }
    } catch (e) {
      print("error caught : ");
      print(e);
    }
  }

  readDataWhere(String type, String value) async {
    var url;
    var data;
     if (type == "categories") {
      url = "https://${server_name}/categories/categories.php";
      data = {"type" : value} ; 
    }
     
    if (type == "settings") {
      url = "https://${server_name}/settings/settings.php";
      data = {"id": value};
    }if (type == "messages") {
            url = "https://${server_name}/message/messagetaxi.php";
      data = {"taxiid": value};
    }

    try {
      var response = await http.post(Uri.parse(url)  , body: data , headers: myheaders);
      if (response.statusCode == 200) {
        print(response.body);
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("page not found");
      }
    } catch (e) {
      print("error caught : ");
      print(e);
    }
  }

  writeData(String type, var data) async {
    var url;

     if (type == "orders") {
       
          url = "https://${server_name}/taxi/orderstaxidriver.php";

     }   if (type == "approveorderstaxi") {
        
          url = "https://${server_name}/taxi/approveorderstaxi.php";

    } if (type == "donedelivery") {
          url = "https://${server_name}/taxi/donedelivery.php";
    }

    if (type == "login") {
      url = "https://${server_name}/auth/taxilogin.php";
    }if (type == "logout") {
      url = "https://${server_name}/auth/taxilogout.php";
    }
    if (type == "transfermoney") {
      url = "https://${server_name}/money/transfermoneyusers.php";
    }
    if (type == "resetpassword") {
      url = "https://${server_name}/resetpassword.php";
    }
    if (type == "verfiycode") {
      url = "https://${server_name}/verfiycode.php";
    }
    if (type == "newpassword") {
      url = "https://${server_name}/newpassword.php";
    }if (type == "updatelocation") {
          url ="https://${server_name}/taxi/updatelocation.php";

    }
 
    try {
      var response = await http.post(Uri.parse(url) , body: data , headers: myheaders);
      if (response.statusCode == 200) {
        print(response.body);
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("page Not found");
      }
    } catch (e) {
      print("error caught : ");
      print(e);
    }
  }

  Future addTaxiUsers(email, password, username, phone, File imagefile) async {
    var stream = new http.ByteStream(imagefile.openRead());
    stream.cast();
    var length = await imagefile.length();
    var uri = Uri.parse("https://${server_name}/auth/taxisignup.php");
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(myheaders);  
    var multipartFile = new http.MultipartFile("file", stream, length,
        filename: basename(imagefile.path));
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["username"] = username;
    request.fields["phone"] = phone;
    // لانو خاص بالتكسي
    request.fields["role"] = "4";
    request.files.add(multipartFile);
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  }

  Future editTaxiUsers(username, email, password, phone, id, bool issfile,
      [File imagefile]) async {
    var uri = Uri.parse("https://${server_name}/taxi/edittaxiusers.php");

    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(myheaders);

    if (issfile == true) {
      var stream = new http.ByteStream(imagefile.openRead());
      stream.cast();
      var length = await imagefile.length();
      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: basename(imagefile.path));
      request.files.add(multipartFile);
    }
    request.fields["username"] = username;
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["userid"] = id;
    request.fields["phone"] = phone;
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  }

  Future addTaxi(
      String taxiemail,
      String taxiModel,
      String taxiYear,
      String taxiBrand,
      String taxiDescription,
      String taxiPrice,
      File image,
      File imagelisence) async {
    var stream = new http.ByteStream(image.openRead());
    stream.cast();
    var streamtwo = new http.ByteStream(imagelisence.openRead());
    stream.cast();
    var length = await image.length();
    var lengthtwo = await imagelisence.length();
    var uri = Uri.parse("https://${server_name}/taxi/addtaxi.php");
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(myheaders);
    var multipartFile = new http.MultipartFile("file", stream, length,
        filename: basename(image.path));
    var multipartFileTwo = new http.MultipartFile(
        "filetwo", streamtwo, lengthtwo,
        filename: basename(imagelisence.path));
    // add Data to request
    request.fields["email"]       = taxiemail;
    request.fields["model"]       = taxiModel;
    request.fields["year"]        = taxiYear;
    request.fields["brand"]       = taxiBrand;
    request.fields["description"] = taxiDescription;
    // add Data to request
    request.files.add(multipartFile);
    request.files.add(multipartFileTwo);
    // Send Request
    var myrequest = await request.send();
    // For get Response Body
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print(response.body);
      return jsonDecode(response.body);
    }
  }
}
