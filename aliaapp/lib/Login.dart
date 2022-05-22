import 'dart:convert';
import 'package:aliaapp/Home.dart';
import 'package:aliaapp/ConsValue.dart';
import 'package:aliaapp/Pages/PageAddUser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  final bool isSaveColor;
  Login(this.isSaveColor, {Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState(this.isSaveColor);
}

class _LoginState extends State<Login> {
  late bool isSaveColor;
  _LoginState(bool isSaveColor) {
    this.isSaveColor = isSaveColor;
  }
  bool error = false;
  String msg = "";
  List dataList = [];

  TextEditingController Mobile = new TextEditingController();
  TextEditingController Pass = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  savepre() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("UserCount", UserCount);
    pref.setString("ItemCount", ItemCount);
    pref.setString("OfferCount", OfferCount);
    String data = json.encode(Myuser);
    pref.setString("data", data);
    pref.setBool("isSave", true);
  }

  void GetLogin() async {
    try {
      //print(UserName.text);
      //print(Pass.text);
      var res = await http.post(
        Uri.parse(Myphpurl),
        body: {
          "root": "getLogin",
          "routes": "getLogin",
          "UserName": "${Mobile.text}",
          "Pass": "${Pass.text}",
        },
        encoding: Encoding.getByName("utf8_general_ci"),
      );
      //print(this.isMain);
      //print(res.statusCode); //print raw response on console
      if (res.statusCode == 200) {
        //print(res.body); //print raw response on console
        var data = json.decode(res.body); //decoding json to array
        if (data["error"]) {
          setState(() {
            //refresh the UI when error is recieved from server
            error = true;
            msg = data["message"];
            showModalBottomSheetMSG(context, msg, !error);

            Mobile.text = "";
            Pass.text = "";
          });
        } else {
          //after write success, make fields empty
          setState(() {
            dataList.addAll(data["data"]);
            UserCount = data["appData"][0]["UserCount"];
            ItemCount = data["appData"][0]["ItemCount"];
            OfferCount = data["appData"][0]["OfferCount"];
            Myuser = dataList[0];
            if (!isSaveColor) {
              if (dataList[0]["Gender"] == "0") {
                changecolor(Colors.pink);
              } else {
                changecolor(Colors.blue);
              }
            }
            savepre();
            GotoHome();
          });
        }
      } else {
        //there is error
        setState(() {
          error = true;
          msg = "حدث خطأ أثناء ارسال البيانات";
          showModalBottomSheetMSG(context, msg, !error);

          //mark error and refresh UI with setState
        });
      }
    } catch (e) {
      setState(() {
        error = true;
        msg = "حدث خطأ أثناء ارسال البيانات";
        showModalBottomSheetMSG(context, msg, !error);
        //mark error and refresh UI with setState
      });
    }
  }

  void GotoHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

  void GotoAdduser(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddUserPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: Color4,
          body: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                MainImageSmall(),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: Mobile,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          cursorColor: Color1,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text(
                              "الهاتف المحمول",
                              style: TextStyle(fontSize: 20, color: Color1),
                            ),
                            prefixIcon: Icon(
                              Icons.phone_android_outlined,
                              color: Color1,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color1!,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color2!,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: Pass,
                          textInputAction: TextInputAction.done,
                          cursorColor: Color1,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text(
                              "كلمة المرور",
                              style: TextStyle(fontSize: 20, color: Color1),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color1,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color1!,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color2!,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          child: MaterialButton(
                            onPressed: GetLogin,
                            child: Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            color: Color2,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 115,
                                height: 35,
                                child: MaterialButton(
                                  onPressed: () {
                                    GotoAdduser(context);
                                  },
                                  child: Text(
                                    "إنشاء حساب جديد",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  color: Color2,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              Container(
                                width: 115,
                                height: 35,
                                child: MaterialButton(
                                  onPressed: () {
                                    launch(
                                      //100005157482870
                                      "https://wa.me/message/BEBKEFLKDPT3N1",
                                    );
                                  },
                                  child: Text(
                                    "أنسيت  كلمة المرور ؟",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  color: Color2,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),

                              /*
                              InkWell(
                                onTap: () {
                                  launch(
                                    //100005157482870
                                    "https://wa.me/message/BEBKEFLKDPT3N1",
                                  );
                                },
                                child: Text(
                                  "نسيت كلمة المرور ؟",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  GotoAdduser();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "لإنشاء حساب جديد",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Color1),
                                    ),
                                    Icon(
                                      Icons.account_box_outlined,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                              */
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
