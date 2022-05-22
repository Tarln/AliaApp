import 'dart:convert';
import 'package:aliaapp/ConsValue.dart';
import 'package:aliaapp/Pages/PageOfferGet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OfferPage extends StatefulWidget {
  OfferPage({Key? key}) : super(key: key);

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage>
    with SingleTickerProviderStateMixin {
  _OfferPageState() {}

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
    GetOffers();
    MyController = new TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  void GetOfferItem(int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return GetOffer(dataList[index]);
    }));
  }

  void GetOffers() async {
    try {
      var res = await http.post(
        Uri.parse(Myphpurl),
        body: {
          "root": "getOffer",
          "routes": "getOffer",
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
            //print(dataList);
            //  print(number);
          });
        }
      } else {
        //there is error
        setState(() {
          error = true;
          //mark error and refresh UI with setState
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
                          DateTime.parse(dataList[i]["Offer_EndDate"])))
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
                    (Days == "0") ? "لنهاية\nاليوم" : "${Days}\nيوم",
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              minLeadingWidth: 10,
              title: Text(
                "${dataList[i]["Offer_Name"]}",
                textAlign: TextAlign.start,
              ),
              subtitle: Text(
                "${dataList[i]["Offer_ShortText"]}",
                /*
                (Myuser["AccountType"] == "1")
                    ? "نت / ${dataList[i]["Offer_NetPrice"]} ل . س /\nعموم / ${dataList[i]["Offer_PublicPrice"]} ل . س /"
                    : "/ ${dataList[i]["Offer_PublicPrice"]} ل . س /",
                    */
                textAlign: TextAlign.start,
              ),
              isThreeLine: true,
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Color4,
                    foregroundColor: Colors.black,
                    radius: 25,
                    child: Text(
                      "${dataList[i]["Counter"]}\nصنف",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              onTap: () {
                GetOfferItem(i);
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
                "العروض" +
                    ((OfferCount == "" || OfferCount == "0")
                        ? ""
                        : " ( $OfferCount ) عرض"),
                textAlign: TextAlign.center,
              ),
              textColor: Colors.white,
              onTap: () {
                setState(() {
                  Mypage = MyWait();
                  GetOffers();
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
