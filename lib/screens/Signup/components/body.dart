import 'package:flutter/material.dart';
import 'package:book_app/Screens/Login/login_screen.dart';
import 'package:book_app/Screens/Signup/components/background.dart';
import 'package:book_app/components/already_have_an_account_acheck.dart';
import 'package:book_app/components/rounded_button.dart';
import 'package:book_app/components/rounded_input_field.dart';
import 'package:book_app/components/rounded_user_field.dart';
import 'package:book_app/components/rounded_password_field.dart';
import 'package:book_app/components/rounded_cfpassword_field.dart';
import 'package:requests/requests.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => new _Body();
}

class _Body extends State<Body> {
  String username = "";
  String nameUser = "";
  String emailUser = "";
  String passWord = "";
  String confirmPassWord = "";
  bool successUser = false;
  bool checkSignUp = true;
  Future<void> checkRequest() async {
    try {
      var request = await Requests.post(
              "https://bookapp-server.herokuapp.com/api/register",
              body: {
                'username': username,
                'password': passWord,
                'confirmPassword': confirmPassWord,
                'name': nameUser,
                'email': emailUser,
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
      if (dataReponse["success"] == true) {
        setState(() {
          successUser = true;
          // tokenLogin = dataReponse["data"];
        });
      } else {
        setState(() {
          checkSignUp = false;
        });
      }
    } on Exception {
      rethrow;
    }
    print(username);
    print(nameUser);
    print(emailUser);
    print(passWord);
    print(confirmPassWord);
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
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedUserField(
              hintText: "User",
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            RoundedUserField(
              hintText: "Name",
              onChanged: (value) {
                setState(() {
                  nameUser = value;
                });
              },
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                setState(() {
                  emailUser = value;
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
            RoundedCfPasswordField(
              onChanged: (value) {
                setState(() {
                  confirmPassWord = value;
                });
              },
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () async {
                await checkRequest();
                if (successUser) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                }
              },
            ),
            Text(
              (checkSignUp) ? "" : "Nhập lại thông tin!",
              style: TextStyle(color: Color.fromRGBO(255, 1, 1, 1)),
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
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
