import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr/Screen/recognization_page.dart';
import 'package:ocr/Utils/image_cropper_page.dart';
import 'package:ocr/Utils/image_picker_class.dart';
import 'package:ocr/Widgets/modal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String text = "";
  String text1 = "";
  final StreamController<String> controller = StreamController<String>();
  final StreamController<String> a = StreamController<String>();

  void setText(value) async {
    controller.add(value);
RegExp regExp = RegExp(r'\d{14}');
    print(value);
    if (value.toString().length > 14) {
      String result = value.toString();
      RegExp regExp = RegExp(r'\d{14}');
      Iterable<RegExpMatch> matches = regExp.allMatches(result);

      String numbersOnly = matches
          .map((match) => match.group(0))
          .join(''); // Join all matched digits into a single string
      String first14Digits = numbersOnly.substring(0, 14);
      String phoneNumber = first14Digits;
      // 'tel:"*123*"+$first14Digits1';
      var c = chosen;
      Uri uri = Uri.parse('tel:$c $phoneNumber+%23');

      try {
        // await intent.launch();
        await launch(uri.toString());
        _list.add(
            value.toString()); // Call the phone number using the URL launcher
      } catch (e) {
        print(e.toString()); // Print the error message to the console
      }
      setState(() {
        text1 = value.toString();
        _saveData();
        print("im the" + value);
      });
    }
    // if (value.toString().length > 14) {
    //   setState(() {
    //     text1 = value.toString();
    //     print("im the"+value);
    //   });
    // }
  }

  void dispose() {
    controller.close();
    super.dispose();
  }

  String _selectedOption = 'Orange';
  String chosen = "*101*";
  String text2 = "";
  int i = 0;
  List<String> _list = [];
  // define a list of options
  List<String> selectedItemValue = <String>[
    'Orange',
    'Ooredo',
    'telecom',
    'other'
  ];

  int filteredList = 0;
  @override
  void initState() {
    // TODO: implement initStateF
    _loadData();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('my_list', _list);
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _list = prefs.getStringList('my_list') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(text1),
      ),
      body:
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DropdownButton(
            items: _dropDownItem(),
            onChanged: (value) {
              setState(() {
                print(' and ${value}');

                filteredList =
                    selectedItemValue.indexWhere((element) => element == value);
                switch (value) {
                  case "Orange":
                    chosen = "*101*";
                    print(chosen);
                    break;

                  case "Ooredo":
                    chosen = "*100*";
                    print(chosen);
                    break;

                  case "telecom":
                    chosen = "*123*";
                    print(chosen);
                    break;
                  default:
                    // Code to execute if none of the above cases match the value
                    print('The value is not recognized');
                }
              });
              print(filteredList);
            },
            value: selectedItemValue[filteredList],
            hint: Text('0'),
          ),
         ScalableOCR(
              paintboxCustom: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
// ..strokeJoin=StrokeJoin.round
// ..blendMode=BlendMode.color
// ..strokeCap=StrokeCap.round
// ..imageFilter=ColorFilter.srgbToLinearGamma()
                ..color = const Color.fromARGB(153, 102, 160, 241),
              boxLeftOff: 4,
              boxBottomOff: 2.7,
              boxRightOff: 4,
              boxTopOff: 2.7,
              boxHeight: MediaQuery.of(context).size.height / 3.5,
              getRawData: (value) {
                inspect(value);
              },
              getScannedText: (value) {
                setText(value);
              }),
          StreamBuilder<String>(
            stream: controller.stream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Result(text: snapshot.data != null ? snapshot.data! : "");
            },
          ),
   Expanded(
            child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_list[index]),
                );
              },
            ),
          ),
        
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          imagePickerModal(context, onCameraTap: () {
            log("Camera");
            pickImage(source: ImageSource.camera).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                          chosin: chosen,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          }, onGalleryTap: () {
            log("Gallery");
            pickImage(source: ImageSource.gallery).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                          chosin: chosen,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          });
        },
        tooltip: 'Increment',
        label: const Text("Scan photo"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> _options1 = <String>['Orange', 'Ooredo', 'telecom', 'other'];
    return _options1
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value.toString()),
            ))
        .toList();
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text("Readed text: $text");
  }
}
