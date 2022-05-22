import 'package:aliaapp/Home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aliaapp/ConsValue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AddUserPage extends StatefulWidget {
  AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  late GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  TextEditingController AccountName1 = new TextEditingController();
  TextEditingController UserName1 = new TextEditingController();
  TextEditingController Pass1 = new TextEditingController();
  TextEditingController Mobile1 = new TextEditingController();
  TextEditingController Gender1 = new TextEditingController();
  String id = "";
  String Gender1A = "1", Gender1B = "0", Gender1Value = "1";

  //ColorValue = Colors.red.value;
  bool isPass1 = true;

  bool error = false;
  String msg = "";
  int number = 0;
  List dataList = [];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    ReSetData();
    isPass1 = true;
    error = false;
    number = 0;
    msg = "";
    super.initState();
  }

  void GotoHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

  void savepre() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("UserCount", UserCount);
    pref.setString("ItemCount", ItemCount);
    String data = json.encode(Myuser);
    pref.setString("data", data);
    pref.setBool("isSave", true);
  }

  void AddeUser() async {
    try {
      //print(UserName1.text);
      //print(Pass1.text);
      var res = await http.post(
        Uri.parse(Myphpurl),
        body: {
          "root": "addUser",
          "routes": "addUser",
          "Name": "${AccountName1.text}",
          "UserName": "${UserName1.text}",
          "Pass": "${Pass1.text}",
          "Mobile": "${Mobile1.text}",
          "Gender": "${Gender1Value}",
        },
        encoding: Encoding.getByName("utf8_general_ci"),
      );
      //print(this.isMain);
      //print(res.statusCode); //print raw response on console
      if (res.statusCode == 200) {
        dataList = [];
        //print(res.body); //print raw response on console
        var data = json.decode(res.body); //decoding json to array
        if (data["error"]) {
          setState(() {
            //refresh the UI when error is recieved from server
            error = true;
            msg = data["message"];
            showModalBottomSheetMSG2(context, msg, error);
          });
        } else {
          //after write success, make fields empty
          setState(() {
            dataList.addAll(data["data"]);
            UserCount = data["appData"][0]["UserCount"];
            ItemCount = data["appData"][0]["ItemCount"];
            OfferCount = data["appData"][0]["OfferCount"];
            Myuser = dataList[0];
            if (dataList[0]["Gender"] == "0") {
              changecolor(Colors.pink);
            } else {
              changecolor(Colors.blue);
            }
            //changecolor(Color(ColorValue));
            savepre();
            // msg = "تم تحديث البيانات";
            // showModalBottomSheetMSG2(context, msg, false, isAdd: true);
            GotoHome();
          });
        }
      } else {
        //there is error
        setState(() {
          error = true;
          msg = "حدث خطأ أثناء ارسال البيانات";
          showModalBottomSheetMSG2(context, msg, error);
          //mark error and refresh UI with setState
        });
      }
    } catch (e) {
      setState(() {
        error = true;
        msg = "حدث خطأ أثناء ارسال البيانات";
        showModalBottomSheetMSG2(context, msg, error);
        //mark error and refresh UI with setState
      });
    }
  }

  void ReSetData() {
    AccountName1.text = "";
    UserName1.text = "";
    Pass1.text = "";
    Mobile1.text = "";
    Gender1Value = "1";
    id = "";
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
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: "العودة",
              icon: Icon(
                Icons.arrow_back,
                size: 30,
              ),
            ),
            title: Text(
              "إنشاء حساب جديد",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            centerTitle: true,
            backgroundColor: Color2,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  child: Form(
                    key: _formKey1,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: AccountName1,
                          textInputAction: TextInputAction.next,
                          cursorColor: Color1,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text(
                              "اسم الحساب",
                              style: TextStyle(fontSize: 20, color: Color1),
                            ),
                            prefixIcon: Icon(
                              Icons.account_circle_outlined,
                              color: Color1,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color2!,
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
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(width: 2, color: Color1!),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(width: 2, color: Color1!),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب ادخال البيانات';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: UserName1,
                          textInputAction: TextInputAction.next,
                          cursorColor: Color1,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text(
                              "اسم المستخدم",
                              style: TextStyle(fontSize: 20, color: Color1),
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color1,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color2!,
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
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(width: 2, color: Color1!),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(width: 2, color: Color1!),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب ادخال البيانات';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: Mobile1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          cursorColor: Color1,
                          //maxLength: 10,
                          inputFormatters: [
                            //LengthLimitingTextInputFormatter(12),
                          ],
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            label: Text(
                              "الهاتف المحمول للتواصل",
                              style: TextStyle(fontSize: 20, color: Color1),
                            ),
                            prefixIcon: Icon(
                              Icons.phone_android_outlined,
                              color: Color1,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color2!,
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
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(width: 2, color: Color1!),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(width: 2, color: Color1!),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب ادخال البيانات';
                            } else if (value.length < 10) {
                              return 'يجب ادخال رقم موبايل مكون من 10 أرقام';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: Pass1,
                          textInputAction: TextInputAction.done,
                          cursorColor: Color1,
                          obscureText: isPass1,
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
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPass1 = !isPass1;
                                });
                              },
                              icon: Icon(
                                (isPass1)
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Color1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color2!,
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
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(width: 2, color: Color1!),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(width: 2, color: Color1!),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب ادخال البيانات';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text("ذكر"),
                                Radio(
                                  value: Gender1A,
                                  groupValue: Gender1Value,
                                  onChanged: (value) {
                                    setState(() {
                                      Gender1Value = value.toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("أنثى"),
                                Radio(
                                  value: Gender1B,
                                  groupValue: Gender1Value,
                                  onChanged: (value) {
                                    setState(() {
                                      Gender1Value = value.toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          child: MaterialButton(
                            onPressed: () {
                              if (_formKey1.currentState!.validate()) {
                                AddeUser();
                              } else {
                                showModalBottomSheetMSG2(
                                  context,
                                  "يجب ادخال البيانات",
                                  true,
                                );
                              }
                            },
                            child: Text(
                              "إنشاء الحساب",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            color: Color2,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        MyDivider(),
                        Text(
                          "ملاحظة : في حال كنت صيدلي أو صاحب محل يرجى التواصل مع المسؤولين لتعديل بيانات الحساب",
                          textAlign: TextAlign.center,
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
