import 'dart:convert';
import 'package:aliaapp/ConsValue.dart';
import 'package:aliaapp/Pages/PageItemDet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetOffer extends StatefulWidget {
  final Map<String, dynamic> Offer;
  GetOffer(this.Offer, {Key? key}) : super(key: key);

  @override
  State<GetOffer> createState() => _GetOfferState(Offer);
}

class _GetOfferState extends State<GetOffer>
    with SingleTickerProviderStateMixin {
  late Map<String, dynamic> Offer;
  _GetOfferState(Map<String, dynamic> Offer) {
    this.Offer = Offer;
  }

  GlobalKey<ScaffoldState> ScaffoldKey = new GlobalKey<ScaffoldState>();
  late TabController MyController;

  String readItem = "قراءة المزيد", read = "قراءة المزيد";
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
    GetOffer();
    MyController = new TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );

    contentText = "";
    contentText1 = "";
    read = "قراءة المزيد";
    readItem = "قراءة المزيد";
    super.initState();
  }

  void GetOffer() async {
    try {
      var res = await http.post(
        Uri.parse(Myphpurl),
        body: {
          "root": "getOfferItem",
          "routes": "getOfferItem",
          "Offer_id": Offer["Offer_id"].toString(),
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
            dataList = [];
            number = data["number"];
            dataList.addAll(data["data"]);

            UserCount = data["appData"][0]["UserCount"];
            ItemCount = data["appData"][0]["ItemCount"];
            OfferCount = data["appData"][0]["OfferCount"];
            Mypage = PagesItems(context);

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

  Widget PagesItems(BuildContext context) {
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
                isThreeLine: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoIcon(),
                  ],
                ),
                title: Text(
                  "${dataList[i]["Item_Qty"]} قطعة : ${dataList[i]["Item_Info"]}",
                  textAlign: TextAlign.right,
                ),
                subtitle: Text(
                  "${dataList[i]["Item_Name"]}",
                  textAlign: TextAlign.right,
                ),
                leading: MainImageNetwork2(path),
                minLeadingWidth: 10,
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
    String Endate = DateTime.parse(Offer["Offer_EndDate"]).day.toString() +
        " / " +
        DateTime.parse(Offer["Offer_EndDate"]).month.toString() +
        " / " +
        DateTime.parse(Offer["Offer_EndDate"]).year.toString();
    String Days = (-1 *
            (DateTime.now().difference(DateTime.parse(Offer["Offer_EndDate"])))
                .inDays)
        .toString();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          key: ScaffoldKey,
          appBar: AppBar(
            //toolbarHeight: 40,
            centerTitle: true,
            backgroundColor: Color2,
            title: Text(Offer["Offer_Name"]),
            //GestureDetector()
            /*
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    // ScaffoldKey.currentState!.showSnackBar(SnackBar(
                    //   content: const Text('Page Refreshed'),
                    // ));
                  });
                },
                icon: Icon(Icons.refresh_outlined)),
          ],
          */
          ),
          backgroundColor: Color4,
          body: ListView(
            shrinkWrap: true,
            children: [
              ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${Offer["Offer_ShortText"]}",
                      style: TextStyle(
                        //color: Color1,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  MyDivider(),
                  Card(
                    //color: Colors.blue[100 * ((i + 1) % 8)],
                    color: Color1,
                    shadowColor: Colors.white,
                    child: ListTile(
                      title: Text(
                        "العرض متاح ${(Days == "0") ? "لنهاية اليوم" : "لغاية : ${Days} يوم"}",
                        textAlign: TextAlign.center,
                      ),
                      textColor: Colors.white,
                      onTap: () {},
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "العرض متاح لغاية : ${Endate}",
                      style: TextStyle(
                          // color: Color1,
                          //fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    textColor: Colors.black,
                    onTap: () {},
                  ),
                  MyDivider(),
                  Column(
                    children: [
                      Card(
                        //color: Colors.blue[100 * ((i + 1) % 8)],
                        color: Color1,
                        shadowColor: Colors.white,
                        child: ListTile(
                          title: Text(
                            "سعر العرض",
                            textAlign: TextAlign.center,
                          ),
                          textColor: Colors.white,
                          onTap: () {},
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: ListTile(
                          title: Text(
                            (Myuser["AccountType"] == "1")
                                ? "سعر التوزيع : / ${Offer["Offer_NetPrice"]} ل . س /\nسعر العموم : / ${Offer["Offer_PublicPrice"]} ل . س /"
                                : "السعر : / ${Offer["Offer_PublicPrice"]} ل . س /",
                            style: TextStyle(
                                // color: Color1,
                                //fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  MyDivider(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        //color: Colors.blue[100 * ((i + 1) % 8)],
                        color: Color1,
                        shadowColor: Colors.white,
                        child: ListTile(
                          title: Text(
                            "التفاصيل",
                            textAlign: TextAlign.center,
                          ),
                          textColor: Colors.white,
                          onTap: () {
                            /*
                            setState(() {
                              if (read == "قراءة المزيد") {
                                read = "قراءة أقل";
                              } else {
                                read = "قراءة المزيد";
                              }
                            });
                            */
                          },
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      InkWell(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: (read == "قراءة المزيد")
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          "عرض المزيد ...",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                              color: Color1),
                                          textAlign: TextAlign.right,
                                        ),
                                        hoverColor: Color2,
                                        onTap: () {
                                          setState(() {
                                            if (read == "قراءة المزيد") {
                                              read = "قراءة أقل";
                                            } else {
                                              read = "قراءة المزيد";
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${Offer["Offer_FullText"]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      InkWell(
                                        child: Text(
                                          "... عرض أقل",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                              color: Color1),
                                          textAlign: TextAlign.right,
                                        ),
                                        hoverColor: Color2,
                                        onTap: () {
                                          setState(() {
                                            if (read == "قراءة المزيد") {
                                              read = "قراءة أقل";
                                            } else {
                                              read = "قراءة المزيد";
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                        onTap: () {
                          setState(() {
                            if (read == "قراءة المزيد") {
                              read = "قراءة أقل";
                            } else {
                              read = "قراءة المزيد";
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  MyDivider(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        //color: Colors.blue[100 * ((i + 1) % 8)],
                        color: Color1,
                        shadowColor: Colors.white,
                        child: ListTile(
                          title: Text(
                            "الأصناف ${dataList.length == 0 ? "" : ": ${number}"} صنف",
                            textAlign: TextAlign.center,
                          ),
                          textColor: Colors.white,
                          onTap: () {
                            setState(() {
                              if (readItem == "قراءة المزيد") {
                                readItem = "قراءة أقل";
                              } else {
                                readItem = "قراءة المزيد";
                              }
                              Mypage = MyWait();
                              GetOffer();
                              if (readItem == "قراءة المزيد") {
                                readItem = "قراءة أقل";
                              } else {
                                readItem = "قراءة المزيد";
                              }
                            });
                          },
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      InkWell(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: (readItem == "قراءة المزيد")
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          "عرض المزيد ...",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                              color: Color1),
                                          textAlign: TextAlign.right,
                                        ),
                                        hoverColor: Color2,
                                        onTap: () {
                                          setState(() {
                                            if (readItem == "قراءة المزيد") {
                                              readItem = "قراءة أقل";
                                            } else {
                                              readItem = "قراءة المزيد";
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Mypage,
                                      // PagesItems(context),
                                      InkWell(
                                        child: Text(
                                          "... عرض أقل",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                              color: Color1),
                                          textAlign: TextAlign.right,
                                        ),
                                        hoverColor: Color2,
                                        onTap: () {
                                          setState(() {
                                            if (readItem == "قراءة المزيد") {
                                              readItem = "قراءة أقل";
                                            } else {
                                              readItem = "قراءة المزيد";
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                        onTap: () {
                          setState(() {
                            if (readItem == "قراءة المزيد") {
                              readItem = "قراءة أقل";
                            } else {
                              readItem = "قراءة المزيد";
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  MyDivider(),
                ],
              ),
            ],
          )

          /*
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: dataList.length == 0
                ? MyWait()
                : PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        indexs = value;
                        read = "قراءة المزيد";
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          Center(
                              child: Container(
                            margin: EdgeInsets.all(5),
                            child: Text(
                              "${dataList[index]["Item_Name"]}",
                              style: TextStylItems,
                              textAlign: TextAlign.center,
                            ),
                          )),
                          Center(
                            child: Container(
                              margin: EdgeInsets.all(5),
                              child: MainImageLarg(),
                            ),
                          ),
                          Center(
                              child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: ListTile(
                                    title: Text(
                                      (Myuser["AccountType"] == "1")
                                          ? "السعر : / ${dataList[index]["Item_NetPrice"]} - ${dataList[index]["Item_PublicPrice"]} / ل . س "
                                          : "السعر : / ${dataList[index]["Item_PublicPrice"]} ل . س /",
                                      style: TextStyle(
                                          color: Color1,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    subtitle: Text(
                                      (dataList[index]["Item_Avilabel"] == "1")
                                          ? "متوفر"
                                          : "غير متوفر",
                                      style: TextStyle(
                                          color: (dataList[index]
                                                      ["Item_Avilabel"] ==
                                                  "1")
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))),
                          ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            children: [
                              InkWell(
                                child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: (read == "قراءة المزيد")
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${dataList[index]["Item_ShortText"]}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.right,
                                              ),
                                              InkWell(
                                                child: Text(
                                                  "عرض المزيد ...",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 17,
                                                      color: Color1),
                                                  textAlign: TextAlign.right,
                                                ),
                                                hoverColor: Color2,
                                                onTap: () {
                                                  setState(() {
                                                    if (read ==
                                                        "قراءة المزيد") {
                                                      read = "قراءة أقل";
                                                    } else {
                                                      read = "قراءة المزيد";
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "${dataList[index]["Item_FullText"]}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.right,
                                              ),
                                              InkWell(
                                                child: Text(
                                                  "... عرض أقل",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 17,
                                                      color: Color1),
                                                  textAlign: TextAlign.right,
                                                ),
                                                hoverColor: Color2,
                                                onTap: () {
                                                  setState(() {
                                                    if (read ==
                                                        "قراءة المزيد") {
                                                      read = "قراءة أقل";
                                                    } else {
                                                      read = "قراءة المزيد";
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          )),
                                onTap: () {
                                  setState(() {
                                    if (read == "قراءة المزيد") {
                                      read = "قراءة أقل";
                                    } else {
                                      read = "قراءة المزيد";
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      */
          ),
    );
  }
}
