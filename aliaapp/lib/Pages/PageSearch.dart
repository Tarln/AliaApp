import 'package:aliaapp/ConsValue.dart';
import 'package:aliaapp/Pages/PageItemDet.dart';
import 'package:flutter/material.dart';

class SearchData extends SearchDelegate {
  late List<dynamic> dataList;
  int number = 0;
  SearchData(List<dynamic> dataList)
      : super(
          searchFieldLabel: "البحث ...",
          keyboardType: TextInputType.text,
        ) {
    this.dataList = dataList;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = ThemeData.from(
      colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Color3,
          primarySwatch: MaterialColor(Color2!.value, getSwatch(Color2!))),
    );
    return theme;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(
          Icons.clear_outlined,
          color: Colors.white,
          size: 30,
        ),
        tooltip: "حذف النص",
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back_outlined,
        color: Colors.white,
        size: 30,
      ),
      tooltip: "العودة للقائمة السابقة",
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<dynamic> _foundUsers = dataList
        .where((items) =>
            items["Item_ShortText"]
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            items["Item_Info"].toLowerCase().contains(query.toLowerCase()) ||
            items["Item_Name"].toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (query == "") {
      number = 0;
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: Color4,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Color2,
              shadowColor: Color1,
              child: ListTile(
                leading: MainImageSmallest(),
                minLeadingWidth: 10,
                title: Text(
                  "لا يوجد بيانات لعرضها",
                  textAlign: TextAlign.right,
                ),
                subtitle: Text(
                  "أدخل جزء من الاسم أو الوصف أو الشرح المختصر",
                  textAlign: TextAlign.right,
                ),
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color1!, width: 2),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      );
    } else {
      number = _foundUsers.length;
      if (number == 0) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            color: Color4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: Color2,
                shadowColor: Color1,
                child: ListTile(
                  leading: MainImageSmallest(),
                  minLeadingWidth: 10,
                  title: Text(
                    "لا يوجد منتجات مطابقة",
                    textAlign: TextAlign.right,
                  ),
                  subtitle: Text(
                    "أدخل جزء من الاسم أو الوصف أو الشرح المختصر",
                    textAlign: TextAlign.right,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color1!, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        );
      } else {
        return Container(
          color: Color4,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              color: Color4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    Card(
                      color: Color2,
                      shadowColor: Color1,
                      child: ListTile(
                        leading: MainImageSmallest(),
                        minLeadingWidth: 10,
                        title: Text(
                          "عدد المنجات المطابقة",
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Text(
                          "$number منتج",
                          textAlign: TextAlign.right,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color1!, width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    MyDivider(),
                    ...ListTile.divideTiles(
                      context: context,
                      color: Color1,
                      tiles: _foundUsers.map((data) {
                        String path = data["Image_Path"] == null
                            ? ""
                            : data["Image_Path"];
                        return Card(
                          //color: Colors.blue[100 * ((i + 1) % 8)],
                          color: Color2,
                          shadowColor: Color1,
                          child: ListTile(
                            leading: MainImageNetwork2(path),
                            minLeadingWidth: 10,
                            title: Text(
                              "${data["Item_Info"]}",
                              textAlign: TextAlign.right,
                            ),
                            subtitle: Text(
                              "${data["Item_Name"]}",
                              textAlign: TextAlign.right,
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [InfoIcon()],
                            ),
                            isThreeLine: true,
                            onTap: () {
                              int index = dataList.indexOf(data);
                              GetItemDet(index, context);
                            },
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color1!, width: 2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        );
                      }),
                    ).toList(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> _foundUsers = dataList
        .where((items) =>
            items["Item_ShortText"]
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            items["Item_Info"].toLowerCase().contains(query.toLowerCase()) ||
            items["Item_Name"].toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (query == "") {
      number = 0;
      return Container(
        color: Color4,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            color: Color4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: Color2,
                shadowColor: Color1,
                child: ListTile(
                  leading: MainImageSmallest(),
                  minLeadingWidth: 10,
                  title: Text(
                    "لا يوجد بيانات لعرضها",
                    textAlign: TextAlign.right,
                  ),
                  subtitle: Text(
                    "أدخل جزء من الاسم أو الوصف أو الشرح المختصر",
                    textAlign: TextAlign.right,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color1!, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      number = _foundUsers.length;
      if (number == 0) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            color: Color4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: Color2,
                shadowColor: Color1,
                child: ListTile(
                  leading: MainImageSmallest(),
                  minLeadingWidth: 10,
                  title: Text(
                    "لا يوجد منتجات مطابقة",
                    textAlign: TextAlign.right,
                  ),
                  subtitle: Text(
                    "أدخل جزء من الاسم أو الوصف أو الشرح المختصر",
                    textAlign: TextAlign.right,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color1!, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        );
      } else {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            color: Color4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Card(
                    color: Color2,
                    shadowColor: Color1,
                    child: ListTile(
                      leading: MainImageSmallest(),
                      minLeadingWidth: 10,
                      title: Text(
                        "عدد المنجات المطابقة",
                        textAlign: TextAlign.right,
                      ),
                      subtitle: Text(
                        "$number منتج",
                        textAlign: TextAlign.right,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color1!, width: 2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  MyDivider(),
                  ...ListTile.divideTiles(
                    context: context,
                    color: Color1,
                    tiles: _foundUsers.map((data) {
                      String path =
                          data["Image_Path"] == null ? "" : data["Image_Path"];
                      return Card(
                        //color: Colors.blue[100 * ((i + 1) % 8)],
                        color: Color2,
                        shadowColor: Color1,
                        child: ListTile(
                          leading: MainImageNetwork2(path),
                          minLeadingWidth: 10,
                          title: Text(
                            "${data["Item_Info"]}",
                            textAlign: TextAlign.right,
                          ),
                          subtitle: Text(
                            "${data["Item_Name"]}",
                            textAlign: TextAlign.right,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [InfoIcon()],
                          ),
                          isThreeLine: true,
                          onTap: () {
                            int index = dataList.indexOf(data);
                            GetItemDet(index, context);
                          },
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color1!, width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      );
                    }),
                  ).toList(),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  void GetItemDet(int index, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ItemDetPage(dataList[index]);
    }));
  }
}
