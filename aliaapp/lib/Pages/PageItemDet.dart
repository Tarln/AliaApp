import 'package:aliaapp/ConsValue.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class ItemDetPage extends StatefulWidget {
  final Map<String, dynamic> Item;
  ItemDetPage(this.Item, {Key? key}) : super(key: key);

  @override
  State<ItemDetPage> createState() => _ItemDetPageState(Item);
}

class _ItemDetPageState extends State<ItemDetPage>
    with SingleTickerProviderStateMixin {
  late Map<String, dynamic> Item;
  late int isMain;
  _ItemDetPageState(Map<String, dynamic> Item) {
    this.Item = Item;
  }

  GlobalKey<ScaffoldState> ScaffoldKey = new GlobalKey<ScaffoldState>();
  late TabController MyController;

  String read = "قراءة المزيد";
  String countImage = "1";
  String msg = "";
  int number = 0;
  List dataList = [];
  Map<String, dynamic> ItemImage = new Map<String, dynamic>();
  late PageController pc;
  int ImagePage = 0;

  get itemsimage => null;
  final CarouselController _controller = CarouselController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    error = false;
    //print(Category);
    MyController = new TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    getObjectImage();
    countImage = "1";
    read = "قراءة المزيد";
    ImagePage = 0;
    pc = new PageController(initialPage: 0, viewportFraction: 0.8);
    super.initState();
  }

  void getObjectImage() async {
    try {
      var res = await http.post(
        Uri.parse(Myphpurl),
        body: {
          "root": "getObjectImage",
          "routes": "getObjectImage",
          "Object_Type": "'item'",
          "Object_Id": Item["Item_Id"].toString(),
        },
        encoding: Encoding.getByName("utf8_general_ci"),
      );
      //print(res.statusCode); //print raw response on console
      if (res.statusCode == 200) {
        dataList = [];
        ItemImage = new Map<String, dynamic>();
        //print(res.body); //print raw response on console
        var data = json.decode(res.body); //decoding json to array
        if (data["error"]) {
          setState(() {
            //refresh the UI when error is recieved from server
            error = true;
            msg = data["message"]; //error message from server
            // showModalBottomSheetMSG(context, msg, !error);
          });
        } else {
          //after write success, make fields empty
          setState(() {
            number = data["number"];
            dataList.addAll(data["data"]);

            UserCount = data["appData"][0]["UserCount"];
            ItemCount = data["appData"][0]["ItemCount"];
            OfferCount = data["appData"][0]["OfferCount"];
            ItemImage = dataList[0];
            //print(dataList);
            //print(ItemImage);
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
          title: Text("${Item["Item_Info"]}"),
        ),
        backgroundColor: Color4,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: ListTile(
                    title: Text(
                      "${Item["Item_Name"]}",
                      style: TextStylItems,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Center(
                child: (dataList.length == 0)
                    ? MainImageLarg()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            children: [
                              Container(
                                height: 200,
                                child: CarouselSlider(
                                  carouselController: _controller,
                                  options: CarouselOptions(
                                    aspectRatio: 2.0,
                                    enlargeCenterPage: true,
                                    autoPlay:
                                        (dataList.length == 1) ? false : true,
                                    autoPlayInterval: Duration(seconds: 3),
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        ImagePage = index;
                                        countImage = (ImagePage + 1).toString();
                                      });
                                    },
                                  ),
                                  items: List.generate(
                                          dataList.length,
                                          (index) =>
                                              dataList[index]["Image_Path"])
                                      .map(
                                        (item) => Container(
                                          child: Center(
                                            child: MainImageNetwork(
                                                item, 400, 400),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                          (dataList.length == 1)
                              ? Container()
                              : Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.all(5),
                                      onPressed: () {
                                        setState(() {
                                          ImagePage = (ImagePage - 1);
                                          if (ImagePage < 0)
                                            ImagePage = dataList.length - 1;
                                          _controller.animateToPage((ImagePage),
                                              duration: Duration(seconds: 1),
                                              curve: Curves.easeIn);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.skip_next_outlined,
                                        color: Color1,
                                        size: 40,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: CircleAvatar(
                                        backgroundColor: Color1,
                                        foregroundColor: Colors.white,
                                        radius: 15,
                                        child: Text(
                                          countImage,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.all(5),
                                      onPressed: () {
                                        setState(() {
                                          ImagePage = (ImagePage + 1);
                                          if (ImagePage == dataList.length)
                                            ImagePage = 0;
                                          _controller.animateToPage((ImagePage),
                                              duration: Duration(seconds: 1),
                                              curve: Curves.easeIn);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.skip_previous_outlined,
                                        color: Color1,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: (Item["Item_Avilabel"] == "1")
                      ? ListTile(
                          title: Text(
                            (Item["Item_Avilabel"] == "1")
                                ? "متوفر"
                                : "غير متوفر",
                            style: TextStyle(
                                color: (Item["Item_Avilabel"] == "1")
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            ((Myuser["AccountType"] == "1")
                                ? "السعر : / ${Item["Item_NetPrice"]} - ${Item["Item_PublicPrice"]} /\nل . س"
                                : "السعر : / ${Item["Item_PublicPrice"]} ل . س /"),
                            style: TextStyle(
                                color: Color1,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListTile(
                          title: Text(
                            "غير متوفر",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
              Item["Item_ShortText"] == null || Item["Item_ShortText"] == ""
                  ? MyDivider()
                  : (Item["Item_FullText"] == null ||
                          Item["Item_FullText"] == "")
                      ? ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: [
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${Item["Item_ShortText"]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ]),
                            ])
                      : ListView(
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
                                              "${Item["Item_ShortText"] == null ? "" : Item["Item_ShortText"]}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            ),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "${Item["Item_FullText"] == null ? "" : Item["Item_FullText"]}",
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
            ],
          ),
        ),
      ),
    );
  }
}
