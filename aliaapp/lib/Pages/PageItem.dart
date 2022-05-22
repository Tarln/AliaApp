import 'dart:convert';
import 'package:aliaapp/ConsValue.dart';
import 'package:aliaapp/Pages/PageItemDet.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemPage extends StatefulWidget {
  final Map<String, dynamic> Category;
  final int isMain;
  ItemPage(this.Category, this.isMain, {Key? key}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState(Category, isMain);
}

class _ItemPageState extends State<ItemPage>
    with SingleTickerProviderStateMixin {
  late Map<String, dynamic> Category;
  late int isMain;
  _ItemPageState(Map<String, dynamic> Category, int isMain) {
    this.Category = Category;
    this.isMain = isMain;
  }

  GlobalKey<ScaffoldState> ScaffoldKey = new GlobalKey<ScaffoldState>();
  late TabController MyController;

  String read = "قراءة المزيد";
  String contentText = "";
  String contentText1 = "";
  String contentText2 = "";
  bool error = false;
  int? indexs;
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
    indexs = 0;
    //print(Category);
    GetItem();
    MyController = new TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );

    contentText = "";
    contentText1 = "";
    read = "قراءة المزيد";
    super.initState();
  }

  void GetItem() async {
    try {
      var res = await http.post(
        Uri.parse(Myphpurl),
        body: {
          "root": "getItem",
          "routes": "getItem",
          "Category_Id": Category["Category_ID"].toString(),
          "IsMain": isMain.toString(),
        },
        encoding: Encoding.getByName("utf8_general_ci"),
      );
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
        //mark error and refresh UI with setState
      });
    }
  }

  void GetItemDet(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ItemDetPage(dataList[index]);
    }));
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
                leading: MainImageNetwork2(path),
                minLeadingWidth: 10,
                title: Text(
                  "${dataList[i]["Item_Info"]}",
                  textAlign: TextAlign.right,
                ),
                subtitle: Text(
                  "${dataList[i]["Item_Name"]}",
                  textAlign: TextAlign.right,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [InfoIcon()],
                ),
                isThreeLine: true,
                onTap: () {
                  GetItemDet(i);
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
          title: Text(Category["Category_Info"]),
          //GestureDetector()
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  Mypage = MyWait();
                  GetItem();
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
