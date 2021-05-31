import 'package:book_app/consttants.dart';
import 'package:book_app/widgets/book_rating.dart';
import 'package:book_app/widgets/two_side_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

// ignore: must_be_immutable
class ReadingListCard extends StatelessWidget {
  final String image;
  final String title;
  final String auth;
  final double rating;
  final Function pressDetails;
  final Function pressRead;
  // PDFDocument document;
  PDFDocument document;

  ReadingListCard(
      {Key key,
      this.image,
      this.title,
      this.auth,
      this.rating,
      this.pressDetails,
      this.pressRead,
      this.document})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, bottom: 40),
      height: 245,
      width: 202,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 221,
              decoration: BoxDecoration(
                /* image: DecorationImage(
                      image: AssetImage("assets/images/bg6.png"),
                      fit: BoxFit.fitWidth,
                    ), */
                color: Colors.white,
                borderRadius: BorderRadius.circular(29),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 33,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
          ),
          Image.network(
            image,
            width: 150,
            height: 150,
          ),
          Positioned(
            top: 75,
            right: 20,
            child: Column(
              children: <Widget>[
                // IconButton(
                //   icon: Icon(
                //     Icons.favorite_border,
                //   ),
                //   onPressed: () {},
                // ),
                BookRating(score: rating),
              ],
            ),
          ),
          Positioned(
            top: 160,
            child: Container(
              height: 85,
              width: 202,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: RichText(
                      maxLines: 2,
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
                  Spacer(),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: pressDetails,
                        child: Container(
                          width: 101,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: Text("Chi tiết"),
                        ),
                      ),
                      Expanded(
                        child: TwoSideRoundedButton(
                          text: "Đọc",
                          press: pressRead,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
