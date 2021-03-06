import 'package:aliaapp/ConsValue.dart';
import 'package:aliaapp/Pages/PageNewsDet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> ScaffoldKey = new GlobalKey<ScaffoldState>();

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
    GetNews();
    super.initState();
  }

  void GetNews() async {
    try {
      var res = await http.post(
        Uri.parse(Myphpurl),
        body: {
          "root": "getNews",
          "routes": "getNews",
          "MyDate": "'${DateTime.now().toString()}'",
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
          msg = "?????? ?????? ?????????? ?????????? ????????????????";
          showModalBottomSheetMSG(context, msg, !error);
        });
      }
    } catch (e) {
      setState(() {
        error = true;
        msg = "?????? ?????? ?????????? ?????????? ????????????????";
        showModalBottomSheetMSG(context, msg, !error);
      });
    }
  }

  void GetNewsDet(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewsDetPage((dataList[index]));
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
          String Days = (-1 *
                  (DateTime.now().difference(
                          DateTime.parse(dataList[i]["News_EndDate"])))
                      .inDays)
              .toString();
          return Card(
            //color: Colors.blue[100 * ((i + 1) % 8)],
            color: Color2,
            shadowColor: Color1,
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (Days == "0")
                        ? "????????????\n??????????"
                        : (int.parse(Days) > 0)
                            ? "${Days}\n??????"
                            : "??????\n????????",
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              minLeadingWidth: 10,
              title: Text(
                "${dataList[i]["News_Name"]}",
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                "${dataList[i]["News_Info"]}",
                textAlign: TextAlign.right,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [InfoIcon()],
              ),
              onTap: () {
                GetNewsDet(i);
              },
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color1!, width: 2),
              borderRadius: BorderRadius.circular(50),
            ),
          );
        },
      );
    }
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
                "?????????????????? ?? ??????????????",
                textAlign: TextAlign.center,
              ),
              textColor: Colors.white,
              onTap: () {
                setState(() {
                  Mypage = MyWait();
                  GetNews();
                });
              },
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
