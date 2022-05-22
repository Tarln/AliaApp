import 'package:aliaapp/CloseApp.dart';
import 'package:aliaapp/ConsValue.dart';
import 'package:aliaapp/Login.dart';
import 'package:aliaapp/Pages/PageItemLast.dart';
import 'package:aliaapp/Pages/PageNews.dart';
import 'package:aliaapp/Pages/PageOffer.dart';
import 'package:aliaapp/Pages/PageSetting.dart';
import 'package:aliaapp/Pages/PageUser.dart';
import 'package:aliaapp/Pages/pageCompany.dart';
import 'package:aliaapp/Pages/pageCompanySub.dart';
//import 'package:flutter_launcher_icons/xml_templates.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //ScaffoldKeyMain = new GlobalKey<ScaffoldState>();
  _HomePageState() {}

  late Widget myPage;
  late bool mySelected1;
  late bool mySelected2;
  late bool mySelected3;
  late bool mySelected4;
  late bool mySelected5;
  late bool mySelected6;
  late bool mySelected7;
  late bool mySelected8;
  late int selectedInfo = 0;

  late Color selectedInfoColor;
  late Color selectedItemColor;
  late double op;
  late double fontS;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    mySelected1 = false;
    mySelected2 = false;
    mySelected3 = false;
    mySelected4 = false;
    mySelected5 = false;
    mySelected6 = false;
    mySelected7 = false;
    mySelected8 = false;
    selectedInfoColor = Colors.red;
    selectedItemColor = Colors.black;
    op = 1;
    selectedInfo = 0;
    fontS = 12;
    myPage = infoStoreWidget();
    super.initState();
  }

  void setinfoPage() {
    selectedInfoColor = Colors.black;
    selectedItemColor = Color1!;
    op = 0.6;
    fontS = 10;
  }

  delref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("mobile");
    pref.remove("pass");
    pref.remove("data");
    pref.setBool("isSave", false);
  }

  void GotoLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      delref();
      return Login(true);
    }));
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
          onDrawerChanged: (ischange) {
            setState(() {});
          },
          key: ScaffoldKeyMain,
          appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  ScaffoldKeyMain.currentState!.openDrawer();
                },
                tooltip: "القائمة",
                icon: Icon(
                  Icons.menu,
                  size: 30,
                ),
              ),
              backgroundColor: Color2,
              centerTitle: false,
              title: Text(
                "${Myuser["UserName"]}",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        barrierColor: Color4!.withOpacity(0.5),
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              child: BottomNavigationBar(
                                onTap: (value) {
                                  setState(
                                    () {
                                      selectedInfo = value;
                                      selectedInfoColor = Colors.red;
                                      selectedItemColor = Colors.black;
                                      op = 1;
                                      fontS = 12;
                                      mySelected1 = false;
                                      mySelected2 = false;
                                      mySelected3 = false;
                                      mySelected4 = false;
                                      mySelected5 = false;
                                      mySelected6 = false;
                                      mySelected7 = false;
                                      mySelected8 = false;
                                      Navigator.pop(context);
                                      switch (value) {
                                        case 0:
                                          myPage = infoStoreWidget();
                                          break;
                                        case 1:
                                          myPage = infoAgentWidget();
                                          break;
                                        case 2:
                                          myPage = infoAppWidget();
                                          break;
                                        case 3:
                                          GotoLogin();
                                          break;
                                        default:
                                          selectedInfoColor = Colors.black;
                                          selectedItemColor = Color1!;
                                          op = 0.6;
                                          fontS = 10;
                                          break;
                                      }
                                    },
                                  );
                                },
                                currentIndex: selectedInfo,
                                showUnselectedLabels: true,
                                showSelectedLabels: true,
                                selectedItemColor: selectedInfoColor,
                                unselectedItemColor: Colors.black,
                                selectedLabelStyle: TextStyle(
                                    fontSize: fontS,
                                    fontWeight: FontWeight.bold),
                                unselectedLabelStyle: TextStyle(fontSize: 10),
                                selectedIconTheme: IconThemeData(
                                    size: 35,
                                    color: selectedItemColor,
                                    opacity: op),
                                unselectedIconTheme: IconThemeData(
                                    size: 30, color: Color1, opacity: 0.6),
                                items: [
                                  BottomNavigationBarItemInfo(
                                      "حول المستدوع", Icons.store_outlined),
                                  BottomNavigationBarItemInfo("حول المندوب",
                                      Icons.account_box_outlined),
                                  BottomNavigationBarItemInfo(
                                      "حول التطبيق", Icons.touch_app_outlined),
                                  BottomNavigationBarItemInfo(
                                      "تسجيل الخروج", Icons.logout_outlined),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  icon: Icon(
                    Icons.info_outline,
                    size: 30,
                  ),
                  tooltip: "حول",
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return CloseApp();
                      }));
                      //myPage = CloseApp();
                    });
                  },
                  icon: Icon(
                    Icons.door_back_door_outlined,
                    size: 30,
                  ),
                  tooltip: "مغادرة البرنامج",
                ),
              ]),
          drawerScrimColor: Color4!.withOpacity(0.5),
          drawer: Drawer(
            backgroundColor: Color4,
            child: ListView(
              shrinkWrap: true,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(7),
                  color: Color3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainImageSmall(),
                    ],
                  ),
                ),
                MyDivider(),
                MyListTile(
                  "المنتجات الرئيسية",
                  "الوكيل المعتمد لها في محافظة حلب",
                  Icons.margin_outlined,
                  mySelected1,
                  () {
                    setState(() {
                      setinfoPage();
                      Navigator.pop(context);
                      myPage = CompanyPageMain();
                      mySelected1 = true;
                      mySelected2 = false;
                      mySelected3 = false;
                      mySelected4 = false;
                      mySelected5 = false;
                      mySelected6 = false;
                      mySelected7 = false;
                      mySelected8 = false;
                    });
                  },
                ),
                MyDivider(),
                MyListTile(
                  "المنتجات الفرعية",
                  "مجموعة منتجات يتم توزيعها بسعر منافس",
                  Icons.category_outlined,
                  mySelected2,
                  () {
                    setState(() {
                      setinfoPage();
                      Navigator.pop(context);
                      myPage = CompanyPageSub();
                      mySelected1 = false;
                      mySelected2 = true;
                      mySelected3 = false;
                      mySelected4 = false;
                      mySelected5 = false;
                      mySelected6 = false;
                      mySelected7 = false;
                      mySelected8 = false;
                    });
                  },
                ),

                MyDivider(),
                MyListTile(
                  "المنتجات الجديدة",
                  "عرض آخر $NumberOfLastItems منتجات مضافة",
                  Icons.new_releases_outlined,
                  mySelected3,
                  () {
                    setState(() {
                      setinfoPage();
                      Navigator.pop(context);
                      myPage = ItemLastPage();
                      mySelected1 = false;
                      mySelected2 = false;
                      mySelected3 = true;
                      mySelected4 = false;
                      mySelected5 = false;
                      mySelected6 = false;
                      mySelected7 = false;
                      mySelected8 = false;
                    });
                  },
                ),
                MyDivider(),
                MyListTile(
                  "العروض",
                  "تشمل عروض على الكميات و الأسعار",
                  Icons.local_offer_outlined,
                  mySelected4,
                  () {
                    setState(() {
                      setinfoPage();
                      Navigator.pop(context);
                      myPage = OfferPage();
                      mySelected1 = false;
                      mySelected2 = false;
                      mySelected3 = false;
                      mySelected4 = true;
                      mySelected5 = false;
                      mySelected6 = false;
                      mySelected7 = false;
                      mySelected8 = false;
                    });
                  },
                ),
                MyDivider(),
                MyListTile(
                  "الخدمات",
                  "عرض آخر الإعلانات والخدمات والأخبار من قبل عالية أو من قبل أصحاب المنشآت",
                  Icons.notifications_outlined,
                  mySelected5,
                  () {
                    setState(() {
                      setinfoPage();
                      Navigator.pop(context);
                      myPage = NewsPage();
                      mySelected1 = false;
                      mySelected2 = false;
                      mySelected3 = false;
                      mySelected4 = false;
                      mySelected5 = true;
                      mySelected6 = false;
                      mySelected7 = false;
                      mySelected8 = false;
                    });
                  },
                ),
                MyDivider(),
                MyListTile(
                  "الحساب : ${Myuser["id"]} - ${Myuser["Name"]}",
                  "عرض وتحديث البيانات",
                  Icons.account_circle_outlined,
                  mySelected6,
                  () {
                    setState(() {
                      setinfoPage();
                      Navigator.pop(context);
                      myPage = UserPage();
                      mySelected1 = false;
                      mySelected2 = false;
                      mySelected3 = false;
                      mySelected4 = false;
                      mySelected5 = false;
                      mySelected6 = true;
                      mySelected7 = false;
                    });
                  },
                ),
                /*
                MyDivider(),
                MyListTile2(
                  "المندوب : عبد الرحيم ",
                  Icons.account_box_outlined,
                  mySelected3,
                  () {
                    setState(() {
                      Navigator.pop(context);
                      myPage = infoAgentWidget();
      
                      mySelected1 = false;
                      mySelected2 = false;
                      mySelected3 = true;
                      mySelected4 = false;
                      mySelected5 = false;
                      mySelected6 = false;
                    });
                  },
                ),
                MyDivider(),
                MyListTile2(
                  "حول المستودع",
                  Icons.store_outlined,
                  mySelected4,
                  () {
                    setState(() {
                      Navigator.pop(context);
                      myPage = infoStoreWidget();
                      mySelected1 = false;
                      mySelected2 = false;
                      mySelected3 = false;
                      mySelected4 = true;
                      mySelected5 = false;
                      mySelected6 = false;
                    });
                  },
                ),
                MyDivider(),
                MyListTile2(
                  "حول التطبيق",
                  Icons.info_outline,
                  mySelected5,
                  () {
                    setState(() {
                      Navigator.pop(context);
                      myPage = infoAppWidget();
                      mySelected1 = false;
                      mySelected2 = false;
                      mySelected3 = false;
                      mySelected4 = false;
                      mySelected5 = true;
                      mySelected6 = false;
                    });
                  },
                ),
               
                MyDivider(),
                MyListTile2(
                  "تسجيل خروج",
                  Icons.logout_outlined,
                  false,
                  () {
                    setState(() {
                      Navigator.pop(context);
                      GotoLogin();
                    });
                  },
                ),
                 */
                MyDivider(),
                /*
                MyListTile2(
                  "خروج",
                  Icons.exit_to_app_outlined,
                  false,
                  () {
                    setState(() {
                      setinfoPage();
                      Navigator.pop(context);
                      myPage = CloseApp();
                      mySelected1 = false;
                      mySelected2 = false;
                      mySelected3 = false;
                      mySelected4 = false;
                      mySelected5 = false;
                      mySelected6 = false;
                    });
                  },
                ),
                MyDivider(),
               */
                MyListTile(
                  "الإعدادات",
                  "الاعدادات العامة للبرنامج",
                  Icons.settings_outlined,
                  mySelected7,
                  () {
                    setState(() {
                      setinfoPage();
                      Navigator.pop(context);
                      myPage = SettinrPage();
                      mySelected1 = false;
                      mySelected2 = false;
                      mySelected3 = false;
                      mySelected4 = false;
                      mySelected5 = false;
                      mySelected6 = false;
                      mySelected7 = true;
                      mySelected8 = false;
                    });
                  },
                ),
                MyDivider(),
                MyListTile(
                  "عبد الرحيم للبرامج - 2022",
                  "جميع الحقوق محفوظة\nاهداء لشمسي الغالية ( Z )",
                  Icons.copyright_rounded,
                  mySelected8,
                  () {
                    setState(() {
                      setinfoPage();
                      Navigator.pop(context);
                      myPage = infoAgentWidget();
                      mySelected1 = false;
                      mySelected2 = false;
                      mySelected3 = false;
                      mySelected4 = false;
                      mySelected5 = false;
                      mySelected6 = false;
                      mySelected7 = false;
                      mySelected8 = true;
                      selectedInfo = 1;
                      selectedInfoColor = Colors.red;
                      selectedItemColor = Colors.black;
                      op = 1;
                      fontS = 12;
                    });
                  },
                ),
                //   MyDivider(),
              ],
            ),
          ),
          body: Padding(padding: const EdgeInsets.all(15), child: myPage),
          backgroundColor: Color4,
        ),
      ),
    );
  }
}
