import 'dart:convert';
import 'dart:core';
import 'package:aliaapp/ConsValue.dart';
import 'package:aliaapp/Pages/PageItem.dart';
//import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryPage extends StatefulWidget {
  final Map<String, dynamic> Company;
  final int isMain;

  CategoryPage(this.Company, this.isMain, {Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState(Company, isMain);
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  late Map<String, dynamic> Company;
  late int isMain;
  _CategoryPageState(Map<String, dynamic> Company, int isMain) {
    this.Company = Company;
    this.isMain = isMain;
  }

  GlobalKey<ScaffoldState> ScaffoldKey = new GlobalKey<ScaffoldState>();
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
    GetCategory();
    MyController = new TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  void GetCategory() async {
    try {
      var res = await http.post(
        Uri.parse(Myphpurl),
        body: {
          "root": "getCategory",
          "routes": "getCategory",
          "Company_Id": Company["Company_ID"].toString(),
          "IsMain": isMain.toString(),
        },
        encoding: Encoding.getByName("utf8_general_ci"),
      );
      //print(res.statusCode); //print raw response on console
      if (res.statusCode == 200) {
        dataList = []; //print(res.body); //print raw response on console
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
            // print(dataList);
            //  print(number);
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
      });
    }
  }

  Widget Pages(BuildContext context) {
    if (dataList.length == 0) {
      return MyWait();
    } else {
      return ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: dataList.length,
          itemBuilder: (context, i) {
            String path = dataList[i]["Image_Path"] == null
                ? ""
                : dataList[i]["Image_Path"];
            return Card(
              //color: Colors.blue[100 * ((i + 1) % 8)],
              color: Color2,
              shadowColor: Color1,
              child: ListTile(
                subtitle: Text(
                  "${dataList[i]["Category_Name"]}",
                  textAlign: TextAlign.right,
                ),
                title: Text(
                  "${dataList[i]["Category_Info"]}",
                  textAlign: TextAlign.right,
                ),
                leading: MainImageNetwork2(path),
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
                  GetItem(i);
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color1!, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color1!, width: 2),
                borderRadius: BorderRadius.circular(50),
              ),
            );
          });
    }
  }

  void GetItem(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ItemPage(dataList[index], isMain);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: ScaffoldKey,
        appBar: AppBar(
          //toolbarHeight: 40,
          centerTitle: true,
          backgroundColor: Color2,
          //GestureDetector()
          title: Text(Company["Company_Name"]),
          //GestureDetector()
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  Mypage = MyWait();
                  GetCategory();
                });
              },
              icon: Icon(
                Icons.refresh_outlined,
                size: 30,
              ),
              tooltip: "تحديث",
            ),
          ],
        ),
        backgroundColor: Color4,
        body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15),
            children: [
              Mypage,
            ]),
      ),
    );
  }
}
