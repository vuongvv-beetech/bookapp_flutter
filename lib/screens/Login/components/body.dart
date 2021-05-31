import 'package:book_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:book_app/Screens/Login/components/background.dart';
import 'package:book_app/Screens/Signup/signup_screen.dart';
import 'package:book_app/components/already_have_an_account_acheck.dart';
import 'package:book_app/components/rounded_button.dart';
import 'package:book_app/components/rounded_user_field.dart';
import 'package:book_app/components/rounded_password_field.dart';
// import 'package:flutter_svg/svg.dart';

import 'package:requests/requests.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => new _Body();
}

class _Body extends State<Body> {
  // const Body({
  //   Key key,
  // }) : super(key: key);
  String username = "";
  String passWord = "";
  bool checkUser = false;
  String tokenLogin = "";
  String emailUser = "";
  String nameProfile = "";
  int userID;
  bool checkLogin = true;
  Future<void> checkRequest() async {
    try {
      var request =
          await Requests.post("https://bookapp-server.herokuapp.com/api/login",
                  body: {
                    'username': username,
                    'password': passWord,
                  },
                  bodyEncoding: RequestBodyEncoding.JSON)
              .timeout(
        Duration(seconds: 10),
        onTimeout: () {
          return null;
        },
      );
      var dataReponse;
      if (request != null) {
        dataReponse = request.json();
      } else {
        throw Exception('Failed to load album');
      }
      if (dataReponse["success"] == true) {
        setState(() {
          checkUser = true;
          tokenLogin = dataReponse["data"];
          userID = dataReponse["userId"];
          emailUser = dataReponse["userEmail"];
          nameProfile = dataReponse["userName"];
        });
      } else {
        setState(() {
          checkLogin = false;
          // tokenLogin = dataReponse["data"];
        });
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            /*SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),*/
            SizedBox(height: size.height * 0.03),
            RoundedUserField(
              hintText: "User",
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() {
                  passWord = value;
                });
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                try {
                  await checkRequest();
                  if (checkUser) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen(
                            tokenUser: tokenLogin,
                            userId: userID,
                            emailUser: emailUser,
                            nameProfile: nameProfile,
                          );
                        },
                      ),
                    );
                  }
                } catch (e) {
                  throw e;
                }
              },
            ),
            Text(
              (checkLogin) ? "" : "Sai tài khoản hoặc mật khẩu",
              style: TextStyle(color: Color.fromRGBO(255, 1, 1, 1)),
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
