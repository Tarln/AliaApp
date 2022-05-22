import 'package:flutter/material.dart';
import 'package:aliaapp/ConsValue.dart';

class SettinrPage extends StatefulWidget {
  SettinrPage({Key? key}) : super(key: key);

  @override
  State<SettinrPage> createState() => _SettinrPageState();
}

class _SettinrPageState extends State<SettinrPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Card(
                color: Color1,
                shadowColor: Colors.white,
                child: ListTile(
                  title: Text(
                    "تحديث اللون العام للتطبيق",
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
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              color: Color1,
              child: Center(
                child: DropdownButton(
                  itemHeight: 50,
                  isExpanded: true,
                  iconEnabledColor: Colors.white,
                  iconDisabledColor: Colors.black,
                  dropdownColor: Color3,
                  iconSize: 30,
                  underline: Text(""),
                  items: dataColor
                      .map((e) => DropdownMenuItem(
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              color: Color(e["value"]),
                              child: Center(
                                child: Text("اللون : ${e["name"]}",
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                            value: e["value"],
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      ColorValue = int.parse(value.toString());
                      changecolor(Color(ColorValue));
                      ScaffoldKeyMain.currentState!.openDrawer();
                      Navigator.pop(context);
                    });
                  },
                  onTap: () {},
                  value: ColorValue,
                ),
              ),
            ),
          ],
        ),
        /*
        Row(
          children: [
            Container(
              width: 135,
              child: RadioListTile(
                title: Text("الأحمر"),
                groupValue: ColorValue,
                value: ColorE,
                onChanged: (value) {
                  setState(() {
                    ColorValue = int.parse(value.toString());
                    changecolor(Color(ColorValue));
                    ScaffoldKeyMain.currentState!.openDrawer();
                    Navigator.pop(context);
                  });
                },
                selected: ColorValue == ColorE ? true : false,
                selectedTileColor: Color(ColorE),
              ),
            ),
            Container(
              width: 135,
              child: RadioListTile(
                title: Text("أخضر"),
                groupValue: ColorValue,
                value: ColorC,
                onChanged: (value) {
                  setState(() {
                    ColorValue = int.parse(value.toString());
                    changecolor(Color(ColorValue));
                    ScaffoldKeyMain.currentState!.openDrawer();
                    Navigator.pop(context);
                  });
                },
                selected: ColorValue == ColorC ? true : false,
                selectedTileColor: Color(ColorC),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 135,
              child: RadioListTile(
                title: Text("أزرق"),
                groupValue: ColorValue,
                value: ColorA,
                onChanged: (value) {
                  setState(() {
                    ColorValue = int.parse(value.toString());
                    changecolor(Color(ColorValue));
                    ScaffoldKeyMain.currentState!.openDrawer();
                    Navigator.pop(context);
                  });
                },
                selected: ColorValue == ColorA ? true : false,
                selectedTileColor: Color(ColorA),
              ),
            ),
            Container(
              width: 135,
              child: RadioListTile(
                title: Text("سيان"),
                groupValue: ColorValue,
                value: ColorG,
                onChanged: (value) {
                  setState(() {
                    ColorValue = int.parse(value.toString());
                    changecolor(Color(ColorValue));
                    ScaffoldKeyMain.currentState!.openDrawer();
                    Navigator.pop(context);
                  });
                },
                selected: ColorValue == ColorG ? true : false,
                selectedTileColor: Color(ColorG),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 135,
              child: RadioListTile(
                title: Text("زهري"),
                groupValue: ColorValue,
                value: ColorB,
                onChanged: (value) {
                  setState(() {
                    ColorValue = int.parse(value.toString());
                    changecolor(Color(ColorValue));
                    ScaffoldKeyMain.currentState!.openDrawer();
                    Navigator.pop(context);
                  });
                },
                selected: ColorValue == ColorB ? true : false,
                selectedTileColor: Color(ColorB),
              ),
            ),
            Container(
              width: 135,
              child: RadioListTile(
                title: Text("بنفسجي"),
                groupValue: ColorValue,
                value: ColorI,
                onChanged: (value) {
                  setState(() {
                    ColorValue = int.parse(value.toString());
                    changecolor(Color(ColorValue));
                    ScaffoldKeyMain.currentState!.openDrawer();
                    Navigator.pop(context);
                  });
                },
                selected: ColorValue == ColorI ? true : false,
                selectedTileColor: Color(ColorI),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 135,
              child: RadioListTile(
                title: Text("برتقالي"),
                groupValue: ColorValue,
                value: ColorH,
                onChanged: (value) {
                  setState(() {
                    ColorValue = int.parse(value.toString());
                    changecolor(Color(ColorValue));
                    ScaffoldKeyMain.currentState!.openDrawer();
                    Navigator.pop(context);
                  });
                },
                selected: ColorValue == ColorH ? true : false,
                selectedTileColor: Color(ColorH),
              ),
            ),
            Container(
              width: 135,
              child: RadioListTile(
                title: Text("أصفر"),
                groupValue: ColorValue,
                value: ColorD,
                onChanged: (value) {
                  setState(() {
                    ColorValue = int.parse(value.toString());
                    changecolor(Color(ColorValue));
                    ScaffoldKeyMain.currentState!.openDrawer();
                    Navigator.pop(context);
                  });
                },
                selected: ColorValue == ColorD ? true : false,
                selectedTileColor: Color(ColorD),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("بني"),
                  Radio(
                    value: ColorF,
                    groupValue: ColorValue,
                    onChanged: (value) {
                      setState(() {
                        ColorValue = int.parse(value.toString());
                        changecolor(Color(ColorValue));
                        ScaffoldKeyMain.currentState!.openDrawer();
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: EdgeInsets.all(
                20,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                  color: Colors.red,
                  width: 5,
                ),
              ),
              child: DropdownButton(
                itemHeight: 50,
                isExpanded: true,
                iconEnabledColor: Colors.white,
                iconDisabledColor: Colors.black,
                iconSize: 40,
                underline: Text(""),
                hint: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    right: 20,
                  ),
                  child: Text(
                    "أختر البلد :",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                items: ["SYR", "A", "B", "C"]
                    .map((e) => DropdownMenuItem(
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            color: Colors.green,
                            child: Text("البلد : $e",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                )),
                          ),
                          value: e,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVal = value.toString();
                    print("onChanged : $selectedVal");
                  });
                },
                onTap: () {
                  print("onTap");
                },
                value: selectedVal,
              ),
            ),
            Container(
              width: 135,
              child: RadioListTile(
                title: Text("بني"),
                groupValue: ColorValue,
                value: ColorF,
                onChanged: (value) {
                  setState(() {
                    ColorValue = int.parse(value.toString());
                    changecolor(Color(ColorValue));
                    ScaffoldKeyMain.currentState!.openDrawer();
                    Navigator.pop(context);
                  });
                },
                selected: ColorValue == ColorF ? true : false,
                selectedTileColor: Color(ColorF),
              ),
            ),
            Container(
              width: 135,
              child: RadioListTile(
                title: Text("فضي"),
                groupValue: ColorValue,
                value: ColorK,
                onChanged: (value) {
                  setState(() {
                    ColorValue = int.parse(value.toString());
                    changecolor(Color(ColorValue));
                    ScaffoldKeyMain.currentState!.openDrawer();
                    Navigator.pop(context);
                  });
                },
                selected: ColorValue == ColorK ? true : false,
                selectedTileColor: Color(ColorK),
              ),
            ),
          ],
        ),
     */
      ],
    );
  }
}
