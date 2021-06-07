import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
// import "package:book_app/screens/drop_down.dart";
// import 'package:dropdown_formfield/dropdown_formfield.dart';
// import "package:book_app/screens/drop_form.dart";
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';

// ignore: must_be_immutable
class ReadScreen extends StatefulWidget {
  final String linkPdf;
  final String tokenUser;
  final int idChapter;
  List chapters = [];
  ReadScreen(
      {Key key, this.linkPdf, this.chapters, this.tokenUser, this.idChapter})
      : super(key: key);
  @override
  _ReadScreen createState() => _ReadScreen();
}

enum TtsState { playing, stopped, paused, continued }

class _ReadScreen extends State<ReadScreen> {
//--------------------------- text to speech ---------------------------
  FlutterTts flutterTts;
  dynamic languages;
  String language = "vi-VN";
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 1;

  String _newVoiceText = "Vương";

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;
  PDFDoc _pdfDoc;
  bool checkTTS = true;
  Future _pickPDFText(String linkPdf) async {
    _pdfDoc = await PDFDoc.fromURL(linkPdf);
    String text = await _pdfDoc.text;
    // print(text);
    setState(() {
      _newVoiceText = text;
      checkTTS = false;
    });
  }

  @override
  initState() {
    super.initState();
    initTts();
    loadDocument(widget.linkPdf);
    cutData();
    _pickPDFText(widget.linkPdf);
    postChapterRead(widget.idChapter);
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        _getEngines();
      }
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (kIsWeb || Platform.isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(_newVoiceText);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

//--------------------------- text to speech ---------------------------

  Future<void> postChapterRead(int idChap) async {
    try {
      var request = await Requests.post(
              "https://bookapp-server.herokuapp.com/api/create-read",
              headers: {"x-access-token": widget.tokenUser},
              body: {"chapterId": idChap},
              bodyEncoding: RequestBodyEncoding.JSON)
          .timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return null;
        },
      );
      print("-----------");
      print(idChap);
      print("-----------");
      
      var dataReponse = request.json();
      print(dataReponse);
    } on Exception {
      rethrow;
    }
  }

  bool _isLoading = true;
  PDFDocument document;
  // void initState() {
  //   super.initState();
  //   loadDocument(widget.linkPdf);
  //   cutData();
  // }

  List<dynamic> nameChapters = [];
  List linkPDFs = [];
  List idChapters = [];
  cutData() {
    print(widget.chapters.length);
    for (int i = 0; i < widget.chapters.length; i++) {
      nameChapters.add(widget.chapters[i]["nameChapter"]);
      linkPDFs.add(widget.chapters[i]["linkPdf"]);
      idChapters.add(widget.chapters[i]["idChapter"]);
    }
    setState(() {
      dataChapter = nameChapters;
    });
    print(nameChapters);
    print(linkPDFs);
    print(idChapters);
  }

  loadDocument(String linkpdf) async {
    document = await PDFDocument.fromURL(linkpdf);

    setState(() => _isLoading = false);
  }

  changePDF(String value) async {
    setState(() => _isLoading = true);
    document = await PDFDocument.fromURL(
      value,
    );
    _pdfDoc = await PDFDoc.fromURL(value);
    String text = await _pdfDoc.text;
    // print(text);
    setState(() {
      _newVoiceText = text;
      checkTTS = false;
    });
    setState(() => _isLoading = false);
  }

  bool checkData = false;
  List<dynamic> dataChapter = [
    'Chương 1:...',
    'Chương 2:...',
    'Chương 3:...',
    'Chương 4:...'
  ];
  dynamic dropdownValue = 'Chương 1:...';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) {
                                //       return DetailsScreen();
                                //     },
                                //   ),
                                // );
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: <Widget>[
                            DropdownButton<dynamic>(
                              isExpanded: true,
                              value: checkData ? dropdownValue : null,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  checkData = true;
                                  dropdownValue = newValue;
                                  print(dataChapter.indexOf(dropdownValue));
                                  print(linkPDFs[
                                      dataChapter.indexOf(dropdownValue)]);
                                  changePDF(linkPDFs[
                                      dataChapter.indexOf(dropdownValue)]);
                                  postChapterRead(idChapters[
                                      dataChapter.indexOf(dropdownValue)]);
                                });
                              },
                              items: dataChapter.map((dynamic value) {
                                return DropdownMenuItem<dynamic>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.volume_up),
                                  // color: Colors.amber,
                                  color: Colors.green,
                                  splashColor: Colors.greenAccent,
                                  onPressed: checkTTS ? null : () => _speak()),
                              IconButton(
                                  icon: Icon(Icons.stop),
                                  // color: Colors.amber,
                                  color: Colors.red,
                                  splashColor: Colors.redAccent,
                                  onPressed: checkTTS ? null : () => _stop()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  presentChapter(size, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container presentChapter(Size size, BuildContext context) {
    return Container(
      // child: _isLoading
      //         ? Center(child: CircularProgressIndicator())
      //         : PDFViewer(
      //             document: document,)
      // zoomSteps: 1,
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.89,
            // width: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : PDFViewer(
                      document: document,
                      zoomSteps: 1,
                      // lazyLoad: false,
                      scrollDirection: Axis.vertical,
                    ),
              padding: EdgeInsets.only(left: 0, top: 0, right: 0),
              height: MediaQuery.of(context).size.height * 0.9,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class DropDownList extends StatefulWidget {
//   List chapters = [];
//   DropDownList({
//     Key key,
//     this.chapters,
//   }) : super(key: key);

//   @override
//   _DropDownListState createState() => _DropDownListState();
// }

// class _DropDownListState extends State<DropDownList> {
//   @override
//   void initState() {
//     super.initState();
//     // cutData();
//     setState(() {
//       dataChapter = widget.chapters;

//     });
//   }

//   bool checkData = false;
//   List<dynamic> dataChapter = [
//     'Chương 1:...',
//     'Chương 2:...',
//     'Chương 3:...',
//     'Chương 4:...'
//   ];
//   dynamic dropdownValue = 'Chương 1:...';
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<dynamic>(
//       isExpanded: true,
//       value: checkData ? dropdownValue : null,
//       icon: Icon(Icons.arrow_drop_down),
//       iconSize: 24,
//       elevation: 16,
//       style: TextStyle(color: Colors.deepPurple),
//       underline: Container(
//         height: 2,
//         color: Colors.deepPurpleAccent,
//       ),
//       onChanged: (dynamic newValue) {
//         setState(() {
//           checkData = true;
//           dropdownValue = newValue;
//           print(dataChapter.indexOf(dropdownValue));
//         });
//       },
//       items: dataChapter.map((dynamic value) {
//         return DropdownMenuItem<dynamic>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }
