import 'dart:convert';
import 'package:aliaapp/ConsValue.dart';
import 'package:aliaapp/Pages/PageItemDet.dart';
import 'package:aliaapp/Pages/PageSearch.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemLastPage extends StatefulWidget {
  ItemLastPage({Key? key}) : super(key: key);

  @override
  State<ItemLastPage> createState() => _ItemLastPageState();
}

class _ItemLastPageState extends State<ItemLastPage>
    with SingleTickerProviderStateMixin {
  _ItemLastPageState() {}

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

  late bool selected1 = true, selected2 = false;
  String type = "المنتجات الجديدة";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    selected1 = true;
    selected2 = false;
    error = false;
    number = 0;
    msg = "";
    indexs = 0;
    //print(Category);
    GetItem(false);
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

  void GetItem(bool isAll) async {
    try {
      var res = await http.post(
        Uri.parse(Myphpurl),
        body: {
          "root": "getItemLast",
          "routes": "getItemLast",
          "NumberOfLastItems": ((isAll) ? "" : NumberOfLastItems),
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
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 50,
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(50),
              ),
              color: Color2,
              child: InkWell(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: SearchData(dataList),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(
                      "اضغط للبحث عن المنتج ضمن $type ...",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 9,
                child: ListTile(
                  title: Text(
                    "المنتجات الجديدة" + "\n( " + NumberOfLastItems + " )",
                    textAlign: TextAlign.center,
                  ),
                  textColor: Colors.white,
                  onTap: () {
                    setState(() {
                      Mypage = MyWait();
                      GetItem(false);
                      type = "المنتجات الجديدة";
                      selected1 = true;
                      selected2 = false;
                    });
                  },
                  selected: selected1,
                  selectedColor: Colors.yellowAccent,
                  selectedTileColor: Color1!.withOpacity(0.7),
                  tileColor: Color1,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 9,
                child: ListTile(
                  title: Text(
                    "جميع المنتجات" + "\n( " + ItemCount + " )",
                    textAlign: TextAlign.center,
                  ),
                  textColor: Colors.white,
                  onTap: () {
                    setState(() {
                      Mypage = MyWait();
                      GetItem(true);
                      type = "جميع المنتجات";
                      selected1 = false;
                      selected2 = true;
                    });
                  },
                  selected: selected2,
                  selectedColor: Colors.yellowAccent,
                  selectedTileColor: Color1!.withOpacity(0.7),
                  tileColor: Color1,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
          Mypage,
        ],
      ),
    );
  }
}
