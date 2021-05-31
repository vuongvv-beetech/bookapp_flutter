import 'package:book_app/consttants.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final String image;
  final String title;
  final String auth;
  final double rating;
  final Function press;

  SearchCard(
      {Key key, this.image, this.title, this.auth, this.rating, this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: new Container(
        margin: EdgeInsets.only(left: size.width * 0.05, top: 5),
        height: 90,
        width: size.width * 0.9,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              // bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
                  ),
                  // color: Colors.red,
                  // borderRadius: BorderRadius.circular(5),
                  // boxShadow: [
                  //   BoxShadow(
                  //     offset: Offset(0, 10),
                  //     blurRadius: 33,
                  //     color: kShadowColor,
                  //   ),
                  // ],
                ),
              ),
            ),
            Image.network(
              image,
              width: 49,
              height: 80,
            ),
            Positioned(
              top: 10,
              left: 40,
              child: Container(
                height: 85,
                width: size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: RichText(
                        maxLines: 4,
                        text: TextSpan(
                          style: TextStyle(color: kBlackColor),
                          children: [
                            TextSpan(
                              text: "$title\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: auth,
                              style: TextStyle(
                                color: kLightBlackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
