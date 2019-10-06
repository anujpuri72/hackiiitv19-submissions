import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cmms/utils/mandiScaffold.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FarmerForm extends StatefulWidget {
  @override
  _FarmerFormState createState() => _FarmerFormState();
}

class _FarmerFormState extends State<FarmerForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  FirebaseAuth _auth;
  FirebaseUser user;
  UserUpdateInfo userInfo;

  List<String> _states = <String>['', 'GJ', 'MP', 'UP', 'JK'];
  String _state = '';
  List<String> _districts = <String>[
    '',
    'gandhinagar',
    'himmatnagar',
    'ahmedabad',
  ];
  String _district = '';

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    userInfo = UserUpdateInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MandiScaffold(
      isClickable: false,
      title: "Registration Form",
      body: new Container(
        child: new Form(
          key: _formKey,
          autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              new TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter your full name',
                  labelText: 'Name',
                ),
              ),
              new TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  hintText: 'Enter your phone number',
                  labelText: 'Phone',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.home),
                      labelText: 'State',
                    ),
                    isEmpty: _state == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _state,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _state = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _states.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.home),
                      labelText: 'District',
                    ),
                    isEmpty: _district == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _district,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(
                            () {
                              _district = newValue;
                              state.didChange(newValue);
                            },
                          );
                        },
                        items: _districts.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              new Container(
                margin: new EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: MaterialButton(
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
                  onPressed: () async {
                    await _auth.verifyPhoneNumber(
                      phoneNumber: "+91" + _phoneController.text,
                      codeSent: (String verficationID,
                          [int resendcodeTimeout]) {
                        print("Code Sent to device");
                      },
                      timeout: Duration(seconds: 30),
                      verificationFailed: (AuthException exception) {
                        print("Verification Failed: $exception");
                        Fluttertoast.showToast(
                          msg: "Verification Failed",
                          backgroundColor: Colors.grey,
                          gravity: ToastGravity.BOTTOM,
                        );
                      },
                      verificationCompleted:
                          (AuthCredential credentials) async {
                        print("Phone Verification Complete");
                        await _auth
                            .signInWithCredential(credentials)
                            .then((user) {
                          // Navigator.of(context).pop();
                          Fluttertoast.showToast(
                            msg: "Succesfully Registered",
                            backgroundColor: Colors.grey,
                            gravity: ToastGravity.BOTTOM,
                          );
                        });
                        print("user: $user");
                        await Firestore.instance
                            .collection("farmers")
                            .document(_phoneController.text)
                            .setData({
                          "phone": _phoneController.text,
                          "name": _nameController.text,
                          "location": {
                            "district": _district,
                            "state": _state,
                          }
                        });
                      },
                      codeAutoRetrievalTimeout: (String verificaionID) {
                        print("Timed out");
                        Fluttertoast.showToast(
                          msg: "Timed out. Try again",
                          backgroundColor: Colors.grey,
                          gravity: ToastGravity.BOTTOM,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber() async {}
}
