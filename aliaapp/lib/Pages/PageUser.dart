import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aliaapp/ConsValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController AccountName = new TextEditingController();
  TextEditingController UserName = new TextEditingController();
  TextEditingController Pass = new TextEditingController();
  TextEditingController Mobile = new TextEditingController();
  TextEditingController Gender = new TextEditingController();
  String id = "";
  String GenderA = "1", GenderB = "0", GenderValue = "1";

  //ColorValue = Colors.red.value;
  bool isPass = true;

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
    GetData();
    isPass = true;
    error = false;
    number = 0;
    msg = "";
    super.initState();
  }

  void savepre() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("UserCount", UserCount);
    pref.setString("ItemCount", ItemCount);
    pref.setString("OfferCount", OfferCount);

    String data = json.encode(Myuser);
    pref.setString("data", data);
    pref.setBool("isSave", true);
  }

  void UpdateUser() async {
    try {
      //print(UserName.text);
      //print(Pass.text);
      var res = await http.post(
        Uri.parse(Myphpurl),
        body: {
          "root": "updateUser",
          "routes": "updateUser",
          "Name": "${AccountName.text}",
          "UserName": "${UserName.text}",
          "Pass": "${Pass.text}",
          "Mobile": "${Mobile.text}",
          "Gender": "${GenderValue}",
          "id": "${id.toString()}",
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
            //changecolor(Color(ColorValue));
            savepre();
            GetData();
            msg = "تم تحديث البيانات";
            showModalBottomSheetMSG2(context, msg, false);
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

  void GetData() {
    AccountName.text = Myuser["Name"];
    UserName.text = Myuser["UserName"];
    Pass.text = Myuser["Pass"];
    Mobile.text = Myuser["Mobile"];
    GenderValue = Myuser["Gender"];
    id = Myuser["id"];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        shrinkWrap: true,
        children: [
          Card(
            //color: Colors.blue[100 * ((i + 1) % 8)],
            color: Color1,
            shadowColor: Colors.white,
            child: ListTile(
              title: Text(
                "الحساب : ${Myuser["id"]} - ${Myuser["Name"]} ",
                textAlign: TextAlign.center,
              ),
              textColor: Colors.white,
              onTap: () {
                setState(() {
                  GetData();
                });
              },
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: AccountName,
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
                    controller: UserName,
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
                    controller: Mobile,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    cursorColor: Color1,
                    textAlign: TextAlign.right,
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
                    controller: Pass,
                    textInputAction: TextInputAction.done,
                    cursorColor: Color1,
                    obscureText: isPass,
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
                            isPass = !isPass;
                          });
                        },
                        icon: Icon(
                          (isPass)
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
                            value: GenderA,
                            groupValue: GenderValue,
                            onChanged: (value) {
                              setState(() {
                                GenderValue = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("أنثى"),
                          Radio(
                            value: GenderB,
                            groupValue: GenderValue,
                            onChanged: (value) {
                              setState(() {
                                GenderValue = value.toString();
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
                        if (_formKey.currentState!.validate()) {
                          UpdateUser();
                        } else {
                          showModalBottomSheetMSG2(
                            context,
                            "يجب ادخال البيانات",
                            true,
                          );
                        }
                      },
                      child: Text(
                        "تحديث البيانات",
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
