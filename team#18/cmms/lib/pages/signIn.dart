import 'package:cmms/pages/register.dart';
import 'package:cmms/utils/mandiScaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _phoneController = TextEditingController();
  FirebaseAuth _auth;
  FirebaseUser user;
  UserUpdateInfo userInfo;
  FocusNode _numberNode = FocusNode();

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    userInfo = UserUpdateInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MandiScaffold(
      isClickable: false,
      title: "Sign In",
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 200.0,
                width: 200.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: new AssetImage(
                      'assets/images/wheat.png',
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
              ),
              TextFormField(
                controller: _phoneController,
                focusNode: _numberNode,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter(
                    RegExp("[0-9]"),
                  ),
                ],
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your phone number";
                  }
                  if (value.length != 10) {
                    return "Please enter 10 digits";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0,
                    ),
                  ),
                  hintText: "10-digit mobile number",
                ),
              ),
              MaterialButton(
                child: Text(
                  "Sign in",
                  style: TextStyle(color: Colors.white),
                ),
                height: 40,
                minWidth: 200,
                color: Colors.green,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(27)),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0,
                  ),
                ),
                onPressed: () {
                  _verifyPhoneNumber();
                },
              ),
              Container(
                margin: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: 30,
                child: Text(
                  "Or",
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
              MaterialButton(
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
                height: 40,
                minWidth: 200,
                color: Colors.green,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(27)),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91" + _phoneController.text,
      codeSent: (String verficationID, [int resendcodeTimeout]) {
        print("Code Sent to device");
      },
      timeout: Duration(seconds: 30),
      verificationFailed: (AuthException exception) {
        print("Verification Failed: $exception");
      },
      verificationCompleted: (AuthCredential credentials) async {
        print("Phone Verification Complete");
        await _auth.signInWithCredential(credentials).then((user) {
          // Fluttertoast.showToast(
          //   msg: "Successfully Signed in",
          //   backgroundColor: Colors.grey,
          //   gravity: ToastGravity.BOTTOM,
          // );
        });
      },
      codeAutoRetrievalTimeout: (String verificaionID) {
        print("Timed out");
      },
    );
  }
}
