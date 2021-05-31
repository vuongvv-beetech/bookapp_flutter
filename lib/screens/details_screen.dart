import 'package:book_app/consttants.dart';
import 'package:book_app/screens/read_screen.dart';
import 'package:book_app/widgets/book_rating.dart';
import 'package:book_app/widgets/rounded_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatefulWidget {
  List chapters = [];
  List comments = [];
  final double rating;
  final String nameBook;
  final String image;
  final String tokenUser;
  final int userID;
  final int idBook;
  DetailsScreen({
    Key key,
    this.chapters,
    this.comments,
    this.rating,
    this.nameBook,
    this.image,
    this.tokenUser,
    this.userID,
    this.idBook,
  }) : super(key: key);
  @override
  _DetailsScreen createState() => new _DetailsScreen();
}

class _DetailsScreen extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    print("--------");
    print(widget.chapters);
    print(widget.userID);
    print(widget.comments);
  }

  var lists = [
    {'name': "Cõi mộng", "chapterNumber": 1, "tag": "Thi cử thôi mà cũng mệt"},
    {'name': "Tin dữ", "chapterNumber": 2, "tag": "Hai người cảnh sát đó"},
    {
      'name': "Mật thất",
      "chapterNumber": 3,
      "tag": "Một chiếc taxi bình thường"
    },
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                        top: size.height * .12,
                        left: size.width * .1,
                        right: size.width * .02),
                    height: size.height * .5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg3.png"),
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: BookInfo(
                      size: size,
                      image: widget.image,
                      rating: widget.rating,
                      nameBook: widget.nameBook,
                      chapters: widget.chapters,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: size.height * .48 - 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (var i in widget.chapters)
                          ChapterCard(
                            name: i['nameChapter'],
                            // chapterNumber: i["chapterNumber"],
                            // tag: i["tag"],
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (content) {
                                    return ReadScreen(
                                      linkPdf: i["linkPdf"],
                                      chapters: widget.chapters,
                                      idChapter: i["idChapter"],
                                      tokenUser: widget.tokenUser,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        SizedBox(height: 10),
                      ],
                    )
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     ChapterCard(
                    //       name: "Cõi mộng",
                    //       chapterNumber: 1,
                    //       tag: "Thi cử thôi mà cũng mệt",
                    //       press: () {},
                    //     ),
                    //     ChapterCard(
                    //       name: "Tin dữ",
                    //       chapterNumber: 2,
                    //       tag: "Hai người cảnh sát đó ",
                    //       press: () {},
                    //     ),
                    //     ChapterCard(
                    //       name: "Mật thất",
                    //       chapterNumber: 3,
                    //       tag: "Một chiếc taxi bình thường ",
                    //       press: () {},
                    //     ),
                    //     ChapterCard(
                    //       name: "Nhân vật thần bí",
                    //       chapterNumber: 4,
                    //       tag: "Sau một hồi ồn ào vang lên",
                    //       press: () {},
                    //     ),
                    //     SizedBox(height: 10),
                    //   ],
                    // ),
                    ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headline5,
                        children: [
                          TextSpan(
                            text: "Nhận xét và đánh giá...",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          CommentScreen(
                            token: widget.tokenUser,
                            userId: widget.userID,
                            idBook: widget.idBook,
                            cmtUser: widget.comments,
                            nameBook: widget.nameBook,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headline5,
                      children: [
                        TextSpan(
                          text: "Có thể bạn sẽ ",
                        ),
                        TextSpan(
                          text: "thích….",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 180,
                        width: double.infinity,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 24, top: 24, right: 150),
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(29),
                            image: DecorationImage(
                              image: AssetImage("assets/images/bg4.png"),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: kBlackColor),
                                  children: [
                                    TextSpan(
                                      text: "Ngày nắng chói chang \n",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Trương Tiểu Tố",
                                      style: TextStyle(color: kLightBlackColor),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  BookRating(
                                    score: widget.rating,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: RoundedButton(
                                      text: "Đọc",
                                      verticalPadding: 10,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Image.network(
                          widget.image,
                          // "assets/images/truyen-3.png",
                          width: 130,
                          height: 160,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class ChapterCard extends StatelessWidget {
  final String name;
  final String tag;
  final int chapterNumber;
  final Function press;
  const ChapterCard({
    Key key,
    this.name,
    this.tag,
    this.chapterNumber,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      margin: EdgeInsets.only(bottom: 16),
      width: size.width - 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38.5),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 20),
            blurRadius: 15,
            color: Color(0xFFD3D3D6).withOpacity(.84),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Text(
              "$name",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: kLightBlackColor,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              onPressed: press,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class BookInfo extends StatelessWidget {
  BookInfo(
      {Key key,
      this.size,
      this.image,
      this.rating,
      this.nameBook,
      this.chapters})
      : super(key: key);
  List chapters = [];
  final Size size;
  final String image;
  final double rating;
  final String nameBook;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$nameBook",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontSize: 26),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: this.size.height * .005),
                  //   alignment: Alignment.centerLeft,
                  //   padding: EdgeInsets.only(top: 0),
                  //   child: Text(
                  //     "kỳ quái",
                  //     style: Theme.of(context).textTheme.subtitle1.copyWith(
                  //           fontSize: 25,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //   ),
                  // ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Container(
                          //   width: this.size.width * .3,
                          //   padding:
                          //       EdgeInsets.only(top: this.size.height * .02),
                          //   child: Text(
                          //     "Lâm Ngữ Đường vẫn như mọi người, thong thả từ trường về nhà, không ngờ lại gặp phải chuyện kỳ quái...",
                          //     maxLines: 5,
                          //     style: TextStyle(
                          //       fontSize: 10,
                          //       color: kLightBlackColor,
                          //     ),
                          //   ),
                          // ),
                          Container(
                            margin:
                                EdgeInsets.only(top: this.size.height * .065),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (content) {
                                      return ReadScreen(
                                        linkPdf: chapters[0]["linkPdf"],
                                        chapters: chapters,
                                        idChapter: chapters[0]["idChapter"],
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                "Đọc",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                          ),
                          BookRating(
                            score: rating,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.transparent,
                child: Image.network(
                  image,
                  height: 180,
                  width: 200,
                ),
              )),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CommentScreen extends StatefulWidget {
  final String token;
  final int userId;
  final int idBook;
  final String nameBook;
  List cmtUser = [];
  CommentScreen(
      {Key key,
      this.token,
      this.userId,
      this.idBook,
      this.cmtUser,
      this.nameBook})
      : super(key: key);
  @override
  createState() => new CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  List listCmt = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    setState(() {
      listCmt = widget.cmtUser;
    });
  }

  Future<void> postVote(double rating) async {
    try {
      var request = await Requests.post(
              "https://bookapp-server.herokuapp.com/api/vote",
              headers: {"x-access-token": widget.token},
              body: {
                "vote": rating,
                "bookId": widget.idBook,
                "userId": widget.userId
              },
              bodyEncoding: RequestBodyEncoding.JSON)
          .timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return null;
        },
      );
      var dataReponse = request.json();
      print(dataReponse);
    } on Exception {
      rethrow;
    }
  }

  Future<void> postComment(String comment) async {
    try {
      await Requests.post(
              "https://bookapp-server.herokuapp.com/api/create-comment",
              headers: {"x-access-token": widget.token},
              body: {
                "comment": comment,
                "bookId": widget.idBook,
                "userId": widget.userId
              },
              bodyEncoding: RequestBodyEncoding.JSON)
          .timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return null;
        },
      );
      // var dataReponse = request.json();
      // print(dataReponse);
      updateComment();
    } on Exception {
      rethrow;
    }
  }

  Future<void> updateComment() async {
    // print(widget.token);
    // print(widget.userId);
    // print(widget.idBook);
    try {
      String linkRequest =
          "https://bookapp-server.herokuapp.com/api/list-book?name=" +
              widget.nameBook +
              "&author=";
      var request = await Requests.get(linkRequest).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return null;
        },
      );
      var dataReponse = request.json();
      print(dataReponse["data"][0]["comments"].length);
      List dataComment = [];
      for (int i = 0; i < dataReponse["data"][0]["comments"].length; i++) {
        var comments = new Map();
        var content = dataReponse["data"][0]["comments"][i]["comment"];
        var userCmt = dataReponse["data"][0]["comments"][i]["user"]["name"];
        comments["content"] = content;
        comments["userCmt"] = userCmt;
        dataComment.add(comments);
      }
      setState(() {
        listCmt = dataComment;
      });
    } on Exception {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6,
      child: Column(
        children: <Widget>[
          TextField(
            onSubmitted: (String submittedStr) {
              // _addComment(submittedStr);
              // print(submittedStr);
              postComment(submittedStr);
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20.0),
              hintText: 'Nhận xét...',
            ),
          ),
          SizedBox(height: 10),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
              postVote(rating);
            },
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (var i in listCmt)
                  ListTile(
                    leading: Container(
                      child: Text(i["userCmt"].substring(0, 1),
                          style: TextStyle(fontSize: 30, color: Colors.white)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(30, 136, 229, 1),
                      ),
                      alignment: Alignment.center,
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(left: 0),
                    ),
                    title: Text(i["userCmt"]),
                    subtitle: Text(i["content"]),
                  ),
                SizedBox(height: 10),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
