//import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

//=====================================================================
String Myphpurl = // "http://alia.platinumpestcontrol.me/getItem.php";
    //  "http://DESKTOP-N2-WORK:88/Laravel/example-app1/public/GetData.php";
    "http://alia.platinumpestcontrol.me/AliaApi/GetData.php";
GlobalKey<ScaffoldState> ScaffoldKeyMain = new GlobalKey<ScaffoldState>();

bool error = false;
int? mainTabCount = 2;
//Color? Color1 = Colors.pink[300];
Color? Color1 =
    getSwatch(Colors.blue)[500]; // Color(0xffb31b72);  Color(0xffb31b72)
Color? Color2 = getSwatch(Colors.blue)[200];
Color? Color3 = getSwatch(Colors.blue)[100];
Color? Color4 = getSwatch(Colors.blue)[50];
int ColorValue = Color1!.value;
//=E3F2FD - 0xFFE3F2FD = pink[50]

void changecolor(Color color) {
  ColorValue = color.value;
  Color1 = getSwatch(color)[500];
  Color2 = getSwatch(color)[200];
  Color3 = getSwatch(color)[100];
  Color4 = getSwatch(color)[50];
  savepre();
}

savepre() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("Color_1", Color1!.value.toString());
  pref.setString("Color_2", Color2!.value.toString());
  pref.setString("Color_3", Color3!.value.toString());
  pref.setString("Color_4", Color4!.value.toString());
  pref.setString("ColorValue", ColorValue.toString());
  pref.setBool("savecolor", true);
}

/*
Color1 = Colors.pink;;
Color2 = Colors.pink[200];
Color3 = Colors.pink[100];
Color4 = Colors.pink[50];
*/
Color? ColorIndicator = Colors.black;
Color? ColorIndicatorSub = Colors.black;
Color? ColorMainLabel = Colors.white;
Color? ColorMainTab = Colors.white;
Color? ColorIcons = Colors.black;
Color? SelectedTab = Colors.red;
Color? SelectedTabSub = Colors.red;
Color? UnSelectedTab = Colors.black;

Color? backGroundImage = Colors.pink[100];
Color? searchColor = Colors.pink[50];
Color? categoryColor = Colors.pink[200];

String? PagesName;
late Map<String, dynamic> Myuser = new Map<String, dynamic>();

Map<int, Color> getSwatch(Color color) {
  final hslColor = HSLColor.fromColor(color);
  final lightness = hslColor.lightness;

  /// if [500] is the default color, there are at LEAST five
  /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
  /// divisor of 5 would mean [50] is a lightness of 1.0 or
  /// a color of #ffffff. A value of six would be near white
  /// but not quite.
  final lowDivisor = 6;

  /// if [500] is the default color, there are at LEAST four
  /// steps above [500]. A divisor of 4 would mean [900] is
  /// a lightness of 0.0 or color of #000000
  final highDivisor = 5;

  final lowStep = (1.0 - lightness) / lowDivisor;
  final highStep = lightness / highDivisor;

  return {
    50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
    100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
    200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
    300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
    400: (hslColor.withLightness(lightness + lowStep)).toColor(),
    500: (hslColor.withLightness(lightness)).toColor(),
    600: (hslColor.withLightness(lightness - highStep)).toColor(),
    700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
    800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
    900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
  };
}

List dataColor = [
  {"name": "الكهرمان 1", "value": Colors.amber.value},
  {"name": "الكهرمان 2", "value": Colors.amberAccent.value},
  {"name": "الأزرق 1", "value": Colors.blue.value},
  {"name": "الأزرق 2", "value": Colors.blueAccent.value},
  {"name": "الأزرق الغامق", "value": Colors.blueGrey.value},
  {"name": "الأزرق الفاتح 1", "value": Colors.lightBlue.value},
  {"name": "الأزرق الفاتح 2", "value": Colors.lightBlueAccent.value},
  {"name": "البني", "value": Colors.brown.value},
  {"name": "سماوي 1", "value": Colors.cyan.value},
  {"name": "سماوي 2", "value": Colors.cyanAccent.value},
  {"name": "البرتقالي 1", "value": Colors.orange.value},
  {"name": "البرتقالي 2", "value": Colors.orangeAccent.value},
  {"name": "البرتقالي 3", "value": Colors.deepOrange.value},
  {"name": "البرتقالي 4", "value": Colors.deepOrangeAccent.value},
  {"name": "البنفسجي 1", "value": Colors.purple.value},
  {"name": "البنفسجي 2", "value": Colors.purpleAccent.value},
  {"name": "البنفسجي الغامق 1", "value": Colors.deepPurple.value},
  {"name": "البنفسجي الغامق 2", "value": Colors.deepPurpleAccent.value},
  {"name": "النيلي 1", "value": Colors.indigo.value},
  {"name": "النيلي 2", "value": Colors.indigoAccent.value},
  {"name": "الأخضر 1", "value": Colors.green.value},
  {"name": "الأخضر 2", "value": Colors.greenAccent.value},
  {"name": "الأخضر الفاتح 1", "value": Colors.lightGreen.value},
  {"name": "الأخضر الفاتح 2", "value": Colors.lightGreenAccent.value},
  {"name": "الفضي", "value": Colors.grey.value},
  {"name": "الليم 1", "value": Colors.lime.value},
  {"name": "الليم 2", "value": Colors.limeAccent.value},
  {"name": "الزهري 1", "value": Colors.pink.value},
  {"name": "الزهري 2", "value": Colors.pinkAccent.value},
  {"name": "الأحمر 1", "value": Colors.red.value},
  {"name": "الأحمر 2", "value": Colors.redAccent.value},
  {"name": "شرشيري 1", "value": Colors.teal.value},
  {"name": "شرشيري 2", "value": Colors.tealAccent.value},
  {"name": "الأصفر 1", "value": Colors.yellow.value},
  {"name": "الأصفر 2", "value": Colors.yellowAccent.value},
];

//=================================================
/*
Future<PermissionStatus> getPermission() async {
  final PermissionStatus permission = await Permission.contacts.status;
  if (permission != PermissionStatus.granted ||
      permission != PermissionStatus.denied) {
    final Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.contacts].request();
    return permissionStatus[Permission.contacts] ??
        PermissionStatus.permanentlyDenied;
  } else {
    return permission;
  }
}
*/
String storePhone = "0212246411";
String storeMobile = "0933704715";
String storeMobileWhatsapp = "963933704715";
String AgentMobile = "0962019556";
String AgentMobileWhatsapp = "0962019556";
String NumberOfLastItems = "10";
String UserCount = "0";
String ItemCount = "0";
String OfferCount = "0";
late String mobile;
late String pss;
late String Color_1;
late String Color_2;
late String Color_3;
late String Color_4;
late bool isSave = false;
//=================================================

TextDirection TextDirectionMain = TextDirection.rtl;

TextStyle TextStyleMain =
    TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold);

TextStyle TextStylItems =
    TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold);
TextStyle TextStylePrice =
    TextStyle(color: Color1, fontSize: 20, fontWeight: FontWeight.bold);

TextStyle TextStyleSub =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

//=================================================
void showMsg(BuildContext context, Widget content, {bool? iserror = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: content,
    backgroundColor: Color4,
    duration: Duration(seconds: iserror! ? 2 : 1),
  ));
}

Widget InfoIcon() {
  return Icon(
    Icons.info_outlined,
    color: Color4,
    size: 35,
  );
}

Widget MyDivider() {
  return Divider(
    color: Color3,
    thickness: 3,
  );
}

void showModalBottomSheetMSG(BuildContext context, String msg, bool type) {
  if (type) {
    ScaffoldKeyMain.currentState!.openDrawer();
    Navigator.pop(context);
  }
  showModalBottomSheet(
    context: context,
    barrierColor: Color4!.withOpacity(0.5),
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: 75,
          color: Color4,
          child: Center(
            child: Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: type ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    },
  );
}

void showModalBottomSheetMSG2(BuildContext context, String msg, bool isError,
    {bool? isAdd = false}) {
  if (!isError && !isAdd!) {
    ScaffoldKeyMain.currentState!.openDrawer();
    Navigator.pop(context);
  }
  showMsg(
    context,
    Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 20,
          color: isError ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold),
    ),
    iserror: isError,
  );
}

Widget MyWait() {
  return Center(
    child: Container(
      child: CircularProgressIndicator(
        backgroundColor: Color2,
        color: Color1,
      ),
    ),
  );
}

Widget MyListTile(String mytitle, String mytsubtitle, IconData myticon,
    bool mySelected, var myFunction) {
  return Container(
    child: ListTile(
      selected: mySelected,
      selectedColor: SelectedTab,
      title: Text(
        mytitle,
        style: TextStyle(
          fontSize: 17,
          decoration: TextDecoration.underline,
        ),
      ),
      subtitle: Text(
        mytsubtitle,
        style: TextStyle(fontSize: 13),
      ),
      leading: Icon(
        myticon,
        color: Color1,
      ),
      textColor: Colors.black,
      onTap: myFunction,
    ),
  );
}

Widget MyListTile2(
    String mytitle, IconData myticon, bool mySelected, var myFunction) {
  return Container(
    child: ListTile(
      selected: mySelected,
      selectedColor: SelectedTab,
      title: Text(
        mytitle,
        style: TextStyle(fontSize: 17),
      ),
      leading: Icon(
        myticon,
        color: Color1,
      ),
      textColor: Colors.black,
      onTap: myFunction,
    ),
  );
}

_makingPhoneCall(String phone) async {
  var url = "tel:$phone";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'لايمكن الاتصال بالرقم $url';
  }
}

Widget infoAppWidget() {
  return Container(
    padding: EdgeInsets.all(10),
    child: ListView(
      shrinkWrap: true,
      children: [
        Container(
          child: CircleAvatar(
            backgroundColor: Color3,
            radius: 85,
            child: MainImageSmall(),
          ),
        ),
        MyDivider(),
        MyListTile("برنامج خدمي بتصميم بسيط", "بأقسام وتبويبات منوعة",
            Icons.work_outline, false, () {}),
        MyListTile(
            "يضم المنتجات الحصرية والمنتجات الثانوية",
            " يتم إضافة المنتجات تباعاً",
            Icons.category_outlined,
            false,
            () {}),
        MyListTile("ضمن : شركة - فئة - منتج", "يتم عرض الصور مع شرح عن المنتج",
            Icons.list, false, () {}),
        MyListTile(
            "مع امكانية رؤية العروض ومواعيدها",
            "والخدمات والإعلانات و الأخبار الجديدة",
            Icons.notifications_outlined,
            false,
            () {}),
        MyListTile("الإعدادات", "تعديل السمة العامة للتطبيق",
            Icons.settings_outlined, false, () {}),
        MyListTile(
          "إحصائيات",
          "عدد المستخدمين : " +
              UserCount +
              " مستخدم" +
              "\n" +
              "عدد المنتجات الحالية  : " +
              ItemCount +
              " منتج" +
              "\n" +
              "عدد العروض الحالية  : " +
              OfferCount +
              " عرض" +
              "\n",
          Icons.add_chart_outlined,
          false,
          () {},
        ),
        MyDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("للحصول على التحديثات والتواصل"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("عالية : "),
            InkWell(
              onTap: () {
                launch(
                  "https://www.facebook.com/108640237675825/", //108640237675825
                );
              },
              child: Image.asset(
                "MyImages/Logo/Min/FacebookLogoMin.png",
                height: 35,
                width: 35,
              ),
            ),
            Text("المندوب : "),
            InkWell(
              onTap: () {
                launch(
                  "https://www.facebook.com/108997481598105",
                );
              },
              child: Image.asset(
                "MyImages/Logo/Min/FacebookLogoMin.png",
                height: 35,
                width: 35,
              ),
            ),
          ],
        ),
        MyDivider(),
        InkWell(
          onTap: () {
            launch(
              //100005157482870
              "https://wa.me/message/BEBKEFLKDPT3N1",
            );
          },
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "عبد الرحيم للبرامج " +
                      "2022" +
                      ((DateTime.now().year.toString() == "2022")
                          ? ""
                          : ("-" + DateTime.now().year.toString())),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "جميع الحقوق محفوظة",
                    ),
                    Icon(Icons.copyright_rounded),
                  ],
                ),
              ]),
        ),
        MyDivider(),
        /*
        C9nIl3KeZWUU
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("اهداء لشمسي الغالية"),
            SizedBox(
              width: 15,
            ),
            Text("( Z )"),
            SizedBox(
              width: 15,
            ),
            Icon(
              Icons.wb_sunny_outlined,
              color: Colors.amber,
            ),
          ],
        ),
      */
      ],
    ),
    color: Color4,
  );
}

Widget infoStoreWidget() {
  return Container(
    padding: EdgeInsets.all(10),
    child: ListView(
      shrinkWrap: true,
      children: [
        Container(
          child: CircleAvatar(
            backgroundColor: Color3,
            radius: 85,
            child: MainImageSmall(),
          ),
        ),
        MyDivider(),
        MyListTile(
            "وكيل لمنتجات حصرية ضمن مدينة حلب",
            "موزع بأسعار منافسة لمنتجات أخرى",
            Icons.work_outline,
            false,
            () {}),
        MyListTile(
            "منتجات طبية تجميلية",
            "كل مايهم العناية بالجسم والبشرة وغيرها",
            Icons.category_outlined,
            false,
            () {}),
        MyListTile("عروض دائمة وأسعار منافسة", "المبيع : جملة و مفرّق",
            Icons.price_change_outlined, false, () {}),
        MyListTile(
            "سورية - حلب - الجميلية",
            "شارع المخفر القديم - ثاني مفرق على اليمين",
            Icons.location_on_outlined,
            false,
            () {}),
        MyDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                _makingPhoneCall(storePhone);
              },
              child: Image.asset(
                "MyImages/Logo/Min/OldPhoneLogoMin.png",
                height: 35,
                width: 35,
              ),
            ),
            InkWell(
              onTap: () {
                _makingPhoneCall(storeMobile);
              },
              child: Image.asset(
                "MyImages/Logo/Min/mobileLogMin.png",
                height: 35,
                width: 35,
              ),
            ),
            InkWell(
              onTap: () {
                launch(
                  "https://api.whatsapp.com/send?phone=$storeMobileWhatsapp&text=عن_طريق_عبد_الرحيم_للتوزيع",
                );
              },
              child: Image.asset(
                "MyImages/Logo/Min/WhatsappLogoMin.png",
                height: 35,
                width: 35,
              ),
            ),
            InkWell(
              onTap: () {
                launch(
                  "https://www.facebook.com/108640237675825/", //108640237675825
                );
              },
              child: Image.asset(
                "MyImages/Logo/Min/FacebookLogoMin.png",
                height: 35,
                width: 35,
              ),
            )
          ],
        ),
        MyDivider(),
      ],
    ),
    color: Color4,
  );
}

Widget infoAgentWidget() {
  return Container(
    padding: EdgeInsets.all(10),
    child: ListView(
      shrinkWrap: true,
      children: [
        Container(
          child: CircleAvatar(
            backgroundColor: Color3,
            radius: 85,
            child: MainImageSmall(),
          ),
        ),
        MyDivider(),
        MyListTile("عبد الرحيم", "مندوب مبيعات في أغلب أحياء حلب",
            Icons.account_box_outlined, false, () {}),
        MyListTile(
            "عروض دائمة وأسعار منافسة والمبيع : جملة و مفرّق",
            "تابعوا منصاتنا على مواقع التواصل الاجتماعي",
            Icons.price_change_outlined,
            false,
            () {}),
        MyListTile(
            "عالية : سورية - حلب - الجميلية",
            "شارع المخفر القديم - ثاني مفرق على اليمين",
            Icons.location_on_outlined,
            false,
            () {}),
        MyDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                _makingPhoneCall(AgentMobile);
              },
              child: Image.asset(
                "MyImages/Logo/Min/mobileLogMin.png",
                height: 35,
                width: 35,
              ),
            ),
            InkWell(
              onTap: () {
                launch(
                  //100005157482870
                  "https://wa.me/message/BEBKEFLKDPT3N1",
                );
              },
              child: Image.asset(
                "MyImages/Logo/Min/WhatsappLogoMin.png",
                height: 35,
                width: 35,
              ),
            ),
            InkWell(
              onTap: () {
                launch(
                  "https://www.facebook.com/108997481598105",
                );
              },
              child: Image.asset(
                "MyImages/Logo/Min/FacebookLogoMin.png",
                height: 35,
                width: 35,
              ),
            ),
            InkWell(
              onTap: () {
                launch(
                  "https://www.facebook.com/1003919713548906",
                );
              },
              child: Image.asset(
                "MyImages/Logo/Min/FacebookGroupLogoMin.png",
                height: 35,
                width: 35,
              ),
            ),
            InkWell(
              onTap: () {
                launch(
                  "https://t.me/AbdulRahim_Aleppo",
                );
              },
              child: Image.asset(
                "MyImages/Logo/Min/TelegramChannelLogoMin.png",
                height: 35,
                width: 35,
              ),
            ),
          ],
        ),
        MyDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("اهداء لشمسي الغالية"),
            SizedBox(
              width: 15,
            ),
            Text("( Z )"),
            SizedBox(
              width: 15,
            ),
            Icon(
              Icons.wb_sunny_outlined,
              color: Colors.amber,
            ),
          ],
        ),
      ],
    ),
    color: Color4,
  );
}

Text TextInfo(String data) {
  return Text(data, textDirection: TextDirectionMain);
}

Text TextItems(String data) {
  return Text(
    data,
    textAlign: TextAlign.center,
    textDirection: TextDirectionMain,
    style: TextStylItems,
  );
}

Image MainImageNetwork(String path, double width1, double height1) {
  return Image.network(
    path,
    width: width1,
    height: height1,
    fit: BoxFit.contain,
  );
}

Image MainImageNetwork1(String path) {
  return Image.network(
    path,
    fit: BoxFit.fill,
  );
}

Widget MainImageNetwork2(String path) {
  return Container(
    height: 75,
    width: 75,
    color: Color3,
    child: path == "" ? MainImageSmallest() : MainImageNetwork(path, 90, 100),
  );
}

Image MainImageSmallest() {
  return Image.asset(
    "MyImages/Logo/alia.png",
    height: 75,
    width: 75,
  );
}

Image MainImageSmall() {
  return Image.asset(
    "MyImages/Logo/alia.png",
    height: 110,
    width: 110,
  );
}

Image MainImage() {
  return Image.asset(
    "MyImages/Logo/alia.png",
  );
}

Image MainImageLarg() {
  return Image.asset(
    "MyImages/Logo/aliaLarg.png",
    height: 200,
    width: 200,
  );
}

Image MainImageIcon() {
  return Image.asset("MyImages/alia.ico");
}

//=================================================

Widget TabInfo(String data, IconData icon) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(data, textDirection: TextDirectionMain),
      SizedBox(
        width: 15,
      ),
      Icon(
        icon,
        color: ColorIcons,
        size: 30,
      ),
    ],
  );
}

onTapItem(BuildContext context, List array, int i) {
  // Navigator.of(context).pushNamed(MaterialPageRoute(
  // builder: (context) {
  //return Page1(data: array[i]["Page"], color: Color1!);

  PagesName = (array[i]["Name"] == null) ? "Hi" : array[i]["Name"];
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(title: TextInfo(PagesName!));
    },
  );
}

Tab TabMain(String data, IconData icon) {
  return Tab(
    child: TabInfo(data, icon),
    height: 40,
  );
}

BottomNavigationBarItem BottomNavigationBarItemInfo(
    String data, IconData icon) {
  return BottomNavigationBarItem(
    tooltip: data,
    label: data,
    backgroundColor: Color4,
    icon: Icon(icon),
  );
}

BottomNavigationBarItem BottomNavigationBarItemSub(String data, IconData icon) {
  return BottomNavigationBarItem(
    label: data,
    tooltip: data,
    icon: Icon(
      icon,
      color: ColorIcons,
      size: 40,
    ),
  );
}

/*
BeePharmaLozenges
BeePharmaCream
BeePharmaShampoo
BeePharmaSoap
BeePharmaGel
BeePharmaToothpaste
BeePharmaDeodorant
BeePharmaGum
BeePharmaOilHairTreatment
BeePharmaMouthRefreshingSpray
BeePharmaHoney
*/
//https://www.facebook.com/lc.larin.cosmetics/?ref=page_internal
