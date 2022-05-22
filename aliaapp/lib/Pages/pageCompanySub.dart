import 'dart:convert';
import 'package:aliaapp/ConsValue.dart';
import 'package:aliaapp/Pages/pageCategory.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompanyPageSub extends StatefulWidget {
  CompanyPageSub({Key? key}) : super(key: key);

  @override
  State<CompanyPageSub> createState() => _CompanyPageSubState();
}

class _CompanyPageSubState extends State<CompanyPageSub>
    with SingleTickerProviderStateMixin {
  _CompanyPageSubState() {}

  GlobalKey<ScaffoldState> ScaffoldKey = new GlobalKey<ScaffoldState>();
  late int isMain = 0;
  late TabController MyController;

  bool error = false;
  String msg = "";
  int number = 0;
  List dataList = [];
  late Widget Mypage = MyWait();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    error = false;
    number = 0;
    msg = "";
    GetCompany();
    MyController = new TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  void GetCompany() async {
    try {
      var res = await http.post(
        Uri.parse(Myphpurl),
        body: {
          "root": "getCompany",
          "routes": "getCompany",
          "IsMain": isMain.toString(),
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
            msg = data["message"]; //error message from server
            showModalBottomSheetMSG(context, msg, !error);
          });
        } else {
          //after write success, make fields empty
          setState(() {
            number = data["number"];
            dataList.addAll(data["data"]);

            UserCount = data["appData"][0]["UserCount"];
            ItemCount = data["appData"][0]["ItemCount"];
            OfferCount = data["appData"][0]["OfferCount"];
            Mypage = Pages(context);
            //   print(dataList);
            //  print(number);
          });
        }
      } else {
        //there is error
        setState(() {
          error = true;
          msg = "حدث خطأ أثناء ارسال البيانات";
          showModalBottomSheetMSG(context, msg, !error);
        });
      }
    } catch (e) {
      setState(() {
        error = true;
        msg = "حدث خطأ أثناء ارسال البيانات";
        showModalBottomSheetMSG(context, msg, !error);
      });
    }
  }

  Widget Pages(BuildContext context) {
    if (dataList.length == 0) {
      return MyWait();
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: dataList.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, i) {
            String path = dataList[i]["Image_Path"] == null
                ? ""
                : dataList[i]["Image_Path"];
            return Card(
              //color: Colors.blue[100 * ((i + 1) % 8)],
              color: Color2,
              shadowColor: Color1,
              child: ListTile(
                title: Text(
                  "${dataList[i]["Company_Name"]}",
                  textAlign: TextAlign.right,
                ),
                leading: MainImageNetwork2(path),
                subtitle: Text(
                  "${dataList[i]["Company_Info"]}",
                  textAlign: TextAlign.right,
                ),
                minLeadingWidth: 10,
                trailing: CircleAvatar(
                  backgroundColor: Color4,
                  foregroundColor: Colors.black,
                  child: Text(
                    "${dataList[i]["Counter"]}",
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  GetCategory(i);
                },
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color1!, width: 2),
                borderRadius: BorderRadius.circular(50),
              ),
            );
          });
    }
  }

  void GetCategory(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CategoryPage((dataList[index]), isMain);
    }));
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
                "المنتجات الفرعية",
                textAlign: TextAlign.center,
              ),
              textColor: Colors.white,
              onTap: () {
                setState(() {
                  Mypage = MyWait();
                  GetCompany();
                });
              },

              //trailing: Text("${Mobile[i]["cpu"]}"),
              //  leading: Icon(Icons.mobile_friendly),
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Mypage,
        ],
      ),
    );
  }
}
