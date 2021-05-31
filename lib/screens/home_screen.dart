import 'package:book_app/consttants.dart';
import 'package:book_app/screens/details_screen.dart';
import 'package:book_app/screens/profile.dart';
import 'package:book_app/screens/read_screen.dart';
import 'package:book_app/widgets/book_rating.dart';
import 'package:book_app/widgets/reading_card_list.dart';
import 'package:book_app/widgets/two_side_rounded_button.dart';
import 'package:requests/requests.dart';
import 'package:flutter/material.dart';
import 'package:book_app/widgets/search_bar.dart';
// import 'package:requests/requests.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  String tokenUser;
  int userId;
  String emailUser;
  String nameProfile;
  HomeScreen(
      {Key key, this.tokenUser, this.userId, this.emailUser, this.nameProfile})
      : super(key: key);
  @override
  @override
  _HomeScreen createState() => new _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List dataBook = [];
  List dataHalfBook = [];
  List dataHalfBook2 = [];
  List dataHalfBook1 = [];
  int checked = 0;
  // print(widget.tokenUser);
  Future<void> getData() async {
    print("-----");
    print(widget.tokenUser);
    print(widget.userId);
    print(widget.emailUser);
    print(widget.nameProfile);
    try {
      var request = await Requests.get(
              "https://bookapp-server.herokuapp.com/api/list-book?name=&author=")
          .timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return null;
        },
      );
      var dataRes = request.json();
      // print(dataRes["data"].length);
      for (int i = 0; i < dataRes['data'].length; i++) {
        var items = new Map();
        var nameBook = dataRes['data'][i]["name"];
        var authorBook = dataRes['data'][i]['author'];
        var urlImgBook = dataRes["data"][i]["imageUrl"];
        var idBook = dataRes["data"][i]["id"];
        // print(dataRes["data"][i]["chapters"].length);
        List dataChapter = [];
        for (int k = 0; k < dataRes["data"][i]["chapters"].length; k++) {
          var chapters = new Map();
          var nameChapter = dataRes["data"][i]["chapters"][k]["name"];
          var linkPdf = dataRes["data"][i]["chapters"][k]["linkPdf"];
          var idChapter = dataRes["data"][i]["chapters"][k]["id"];
          chapters["nameChapter"] = nameChapter;
          chapters["linkPdf"] = linkPdf;
          chapters["idChapter"] = idChapter;
          dataChapter.add(chapters);
        }
        List dataComment = [];
        for (int k = 0; k < dataRes["data"][i]["comments"].length; k++) {
          var comments = new Map();
          var content = dataRes["data"][i]["comments"][k]["comment"];
          var userCmt = dataRes["data"][i]["comments"][k]["user"]["name"];
          comments["content"] = content;
          comments["userCmt"] = userCmt;
          dataComment.add(comments);
        }

        print(dataComment);
        items["idBook"] = idBook;
        items["nameBook"] = nameBook;
        items["authorBook"] = authorBook;
        items["urlImgBook"] = urlImgBook;
        items["chapters"] = dataChapter;
        items["comments"] = dataComment;
        // items["voteBook"] = voteBook;
        var voteBook = dataRes['data'][i]["votes"];
        double voteAverage = 0;
        for (int j = 0; j < voteBook.length; j++) {
          int votes = dataRes['data'][i]["votes"][j]["vote"];
          // print("-----");
          // print(votes);
          voteAverage += votes;
        }
        if (voteAverage == 0) {
          items["voteBook"] = 0.0;
        } else {
          double temp = voteAverage / voteBook.length;
          items["voteBook"] = double.parse(temp.toStringAsExponential(1));
        }
        // print(voteBook.length);
        // print(items);
        dataBook.add(items);
      }
      if (checked == 0) {
        setState(() {});
        checked = 1;
      }
    } on Exception {
      rethrow;
    }
  }

  Future<void> getHalfReading() async {
    try {
      var request = await Requests.get(
        "https://bookapp-server.herokuapp.com/api/read",
        headers: {"x-access-token": widget.tokenUser},
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return null;
        },
      );
      var dataReading = request.json();
      print("+++++++++++++++++++++++");
      print(dataReading["data"].length);
      for (int s = 0; s < dataReading["data"].length; s++) {
        var infoBook = new Map();
        String linkChapter = dataReading["data"][s]["chapter"]["linkPdf"];
        String linkImg = dataReading["data"][s]["book"]["imageUrl"];
        String author = dataReading["data"][s]["book"]["author"];
        String nameBook = dataReading["data"][s]["book"]["name"];
        String chapterIndex = dataReading["data"][s]["chapter"]["name"];
        int idChapter = dataReading["data"][s]["id"];
        var time = dataReading["data"][s]["lastReading"];
        infoBook["linkChapter"] = linkChapter;
        infoBook["linkImg"] = linkImg;
        infoBook["author"] = author;
        infoBook["nameBook"] = nameBook;
        infoBook["chapterIndex"] = chapterIndex;
        infoBook["idChapter"] = idChapter;
        infoBook["time"] = time;
        dataHalfBook2.add(infoBook);
      }

      print("=============================");
      var tempt = 0;
      var maxtemp = 0;
      for (var t = 0; t < dataHalfBook2.length; t++) {
        var maxtime =
            DateTime.parse(dataHalfBook2[t]["time"]).millisecondsSinceEpoch;
        print(maxtime);
        if (maxtime >= maxtemp) {
          maxtemp = maxtime;
          tempt = t;
        }
      }
      print(maxtemp);
      print(tempt);
      var infoBook = new Map();
      String linkChapter = dataReading["data"][tempt]["chapter"]["linkPdf"];
      String linkImg = dataReading["data"][tempt]["book"]["imageUrl"];
      String author = dataReading["data"][tempt]["book"]["author"];
      String nameBook = dataReading["data"][tempt]["book"]["name"];
      String chapterIndex = dataReading["data"][tempt]["chapter"]["name"];
      int idChapter = dataReading["data"][tempt]["id"];
      var time = dataReading["data"][tempt]["lastReading"];
      infoBook["linkChapter"] = linkChapter;
      infoBook["linkImg"] = linkImg;
      infoBook["author"] = author;
      infoBook["nameBook"] = nameBook;
      infoBook["chapterIndex"] = chapterIndex;
      infoBook["idChapter"] = idChapter;
      infoBook["time"] = time;
      dataHalfBook.add(infoBook);
      print(dataHalfBook);
// format time ---------------------
      // print(DateTime.parse(time).hour);
// format time -------------------------
// getnamebook ------------------------------------------
      String linkRequest =
          "https://bookapp-server.herokuapp.com/api/list-book?name=" +
              nameBook +
              "&author=";
      var request1 = await Requests.get(linkRequest).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return null;
        },
      );
      print(request1);
      var dataRes1;
      if (request1 != null) {
        dataRes1 = request1.json();
      } else {
        throw Exception('Failed to load album');
      }
      // var dataRes1 = request1.json();
      for (int i = 0; i < dataRes1['data'].length; i++) {
        var items = new Map();
        var nameBook = dataRes1['data'][i]["name"];
        var authorBook = dataRes1['data'][i]['author'];
        var urlImgBook = dataRes1["data"][i]["imageUrl"];
        var idBook = dataRes1["data"][i]["id"];
        List dataChapter = [];
        for (int k = 0; k < dataRes1["data"][i]["chapters"].length; k++) {
          var chapters = new Map();
          var nameChapter = dataRes1["data"][i]["chapters"][k]["name"];
          var linkPdf = dataRes1["data"][i]["chapters"][k]["linkPdf"];
          var idChapter = dataRes1["data"][i]["chapters"][k]["id"];
          chapters["nameChapter"] = nameChapter;
          chapters["linkPdf"] = linkPdf;
          chapters["idChapter"] = idChapter;
          dataChapter.add(chapters);
        }
        List dataComment = [];
        for (int k = 0; k < dataRes1["data"][i]["comments"].length; k++) {
          var comments = new Map();
          var content = dataRes1["data"][i]["comments"][k]["comment"];
          var userCmt = dataRes1["data"][i]["comments"][k]["user"]["name"];
          comments["content"] = content;
          comments["userCmt"] = userCmt;
          dataComment.add(comments);
        }

        print(dataChapter.length);
        items["idBook"] = idBook;
        items["nameBook"] = nameBook;
        items["authorBook"] = authorBook;
        items["urlImgBook"] = urlImgBook;
        items["chapters"] = dataChapter;
        items["comments"] = dataComment;
        var voteBook = dataRes1['data'][i]["votes"];
        double voteAverage = 0;
        for (int j = 0; j < voteBook.length; j++) {
          int votes = dataRes1['data'][i]["votes"][j]["vote"];
          voteAverage += votes;
        }
        if (voteAverage == 0) {
          items["voteBook"] = 0.0;
        } else {
          double temp = voteAverage / voteBook.length;
          items["voteBook"] = double.parse(temp.toStringAsExponential(1));
        }
        dataHalfBook1.add(items);
      }
      print("----------------------------------==================");
      print(dataHalfBook1[0]["chapters"]);
      setState(() {});
// getnamebook ------------------------------------------
    } on Exception {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    getHalfReading();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return SearchBarDemoHome(
          //             // listBook: dataBook,
          //           );
          //         },
          //       ),
          //     );
          //   },
          // ),
          Expanded(
            flex: 8,
            child: Container(
              margin: EdgeInsets.only(left: 60, top: 18),
              child: Text(
                "Hi! " + widget.nameProfile,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchBarDemoHome(
                        tokenUser: widget.tokenUser,
                        userID: widget.userId,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UserProfile(
                        nameProfile: widget.nameProfile,
                        emailUser: widget.emailUser,
                        tokenUser: widget.tokenUser,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/main_page.png"),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: size.height * .1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headline4,
                        children: [
                          TextSpan(text: "Đề xuất cho "),
                          TextSpan(
                              text: "bạn",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for (var i in dataBook)
                          ReadingListCard(
                            image: i["urlImgBook"].toString(),
                            title: i["nameBook"].toString(),
                            auth: i["authorBook"].toString(),
                            rating: i["voteBook"],
                            pressRead: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ReadScreen(
                                      linkPdf: i["chapters"][0]["linkPdf"],
                                      chapters: i["chapters"],
                                      tokenUser: widget.tokenUser,
                                      idChapter: i["chapters"][0]["idChapter"],
                                    );
                                  },
                                ),
                              );
                            },
                            pressDetails: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return DetailsScreen(
                                      chapters: i["chapters"],
                                      nameBook: i["nameBook"].toString(),
                                      image: i["urlImgBook"].toString(),
                                      rating: i["voteBook"],
                                      tokenUser: widget.tokenUser,
                                      userID: widget.userId,
                                      idBook: i["idBook"],
                                      comments: i["comments"],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        SizedBox(height: 10),
                        SizedBox(width: 30),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headline4,
                            children: [
                              TextSpan(text: "Xu "),
                              TextSpan(
                                text: "hướng",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        bestOfTheDayCard(size, context),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headline4,
                            children: [
                              TextSpan(text: "Đọc "),
                              TextSpan(
                                text: "tiếp...",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ReadScreen(
                                    linkPdf: dataHalfBook[0]["linkChapter"],
                                    chapters: dataHalfBook1[0]["chapters"],
                                    tokenUser: widget.tokenUser,
                                    idChapter: dataHalfBook[0]["idChapter"],
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/bg5.png"),
                                fit: BoxFit.fitWidth,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(38.5),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 10),
                                  blurRadius: 33,
                                  color: Color(0xFFD3D3D3).withOpacity(.84),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(38.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  for (var i in dataHalfBook)
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 25),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    i["nameBook"],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    i["author"],
                                                    style: TextStyle(
                                                      color: kLightBlackColor,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                      i["chapterIndex"],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: kLightBlackColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                ],
                                              ),
                                            ),
                                            Image.network(
                                              i["linkImg"],
                                              width: 55,
                                              height: 60,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  // Container(
                                  //   height: 7,
                                  //   width: size.width * .65,
                                  //   decoration: BoxDecoration(
                                  //     color: kProgressIndicator,
                                  //     borderRadius: BorderRadius.circular(7 ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Scaffold(
            //   bottomNavigationBar: BottomNavigationBar(
            //               items: const <BottomNavigationBarItem>[
            //               BottomNavigationBarItem(
            //                 icon: Icon(Icons.home),
            //                 title: Text('a'),
            //               ),
            //               BottomNavigationBarItem(
            //                 icon: Icon(Icons.business),
            //                 title: Text('b')
            //               ),
            //               BottomNavigationBarItem(
            //                 icon: Icon(Icons.school),
            //                 title: Text('c')
            //               ),
            //             ],
            //           ),
            // )
          ],
        ),
      ),
    );
  }

  Container bestOfTheDayCard(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 245,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                top: 24,
                right: size.width * .35,
              ),
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg7.png"),
                  fit: BoxFit.fitWidth,
                ),
                color: Color(0xFFEAEAEA).withOpacity(.45),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      "Hà Nội, 6 tháng Mười Một 2020",
                      style: TextStyle(
                        fontSize: 9,
                        color: kLightBlackColor,
                      ),
                    ),
                  ),
                  Text(
                    "Ngày nắng \nchói chang",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    "Trương Tiểu Tố",
                    style: TextStyle(color: kLightBlackColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: BookRating(score: 4.9),
                        ),
                        Expanded(
                          child: Text(
                            "Lớp 12 năm ấy, Cố Tu Nhiên vẫn nhớ rõ có một cô gái xinh xắn, làn da trắng….",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: kLightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              "assets/images/truyen-3.png",
              width: size.width * .37,
              height: size.height * .27,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              width: size.width * .3,
              child: TwoSideRoundedButton(
                text: "Đọc",
                radious: 24,
                press: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
