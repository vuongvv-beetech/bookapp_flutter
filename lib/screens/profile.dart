import 'package:flutter/material.dart';
import 'package:book_app/widgets/info_card.dart';
import 'package:requests/requests.dart';

// ignore: must_be_immutable
class UserProfile extends StatefulWidget {
  String emailUser = "";
  String nameProfile = "";
  String tokenUser;
  UserProfile({Key key, this.emailUser, this.nameProfile, this.tokenUser})
      : super(key: key);
  @override
  _UserProfile createState() => new _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  List dataBookreaded = [];
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
      print(dataReading);
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
        dataBookreaded.add(infoBook);
      }
      print(dataBookreaded);
      setState(() {});
    } on Exception {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getHalfReading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.brown.shade800,
              child: Text(widget.nameProfile.substring(0, 1),
                  style: TextStyle(fontSize: 60)),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Text(widget.nameProfile),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.teal.shade700,
              ),
            ),
            InfoCard(
              text: widget.emailUser,
              icon: Icons.email,
            ),
            for (var i in dataBookreaded)
              Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 15.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.book),
                  title: Text(i["nameBook"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Time: " + i["time"]),
                      Text("Chương đang đọc: " + i["chapterIndex"]),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
