import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  final String? chosin;
  const RecognizePage({Key? key, this.path, this.chosin}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

final TextEditingController _phoneNumberController = TextEditingController();

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;
  List<String> _list = [];

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _list = prefs.getStringList('my_list') ?? [];
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('my_list', _list);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("recognized page")),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration:
                          const InputDecoration(hintText: "Text goes here..."),
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
                  // TextField(
                  //   controller: _phoneNumberController,
                  //   keyboardType: TextInputType.phone,
                  //   decoration: InputDecoration(
                  //     labelText: 'Enter phone number',
                  //   ),
                  // ),
                  // SizedBox(height: 16),
                  // ElevatedButton(
                  //   onPressed: _callNumber,
                  //   child: Text('Call'),
                  // ),
                ),
              ));
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);
    String result = recognizedText.text;
    RegExp regExp = RegExp(r'\d{14}');
    Iterable<RegExpMatch> matches = regExp.allMatches(result);

    String numbersOnly = matches
        .map((match) => match.group(0))
        .join(''); // Join all matched digits into a single string
    String first14Digits = numbersOnly.substring(0, 15);
    // String first14Digits1 = 'tel:"*123*' + first14Digits + '%23"';
    print(
        numbersOnly); // Prints only the extracted numbers from the recognized textR
    controller.text = first14Digits;
    String phoneNumber = first14Digits;
    // 'tel:"*123*"+$first14Digits1';
    var c = widget.chosin;

    Uri uri =
        Uri.parse('tel:$c+$phoneNumber+%23'); // Construct the phone number URL
    // final AndroidIntent intent = AndroidIntent(
    //   action: 'android.intent.action.DIAL', // The action to perform
    //   data: Uri.encodeFull(first14Digits1), // The phone number to call
    // );
    setState(() {
      _list.add(phoneNumber);
      _saveData();
    });
    try {
      // await intent.launch();
      await launch(
          uri.toString()); // Call the phone number using the URL launcher
    } catch (e) {
      print(e.toString()); // Print the error message to the console
    }

    ///End busy state
    setState(() {
      _isBusy = false;
    });
  }

  void _callNumber() async {
    String phoneNumber = _phoneNumberController.text;
    Uri uri1 = Uri.parse('tel:*123*$phoneNumber+%23');

    try {
// ignore: deprecated_member_use
      await launch(uri1.toString());
      // final AndroidIntent intent = AndroidIntent(
      //   action: 'android.intent.action.DIAL',
      //   data: Uri.parse(uri1),
      // );
      // await intent.launch();
    } catch (e) {
      print(e.toString()); // print the error message to the console
    }
  }
}
