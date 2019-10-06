import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmms/utils/Mandi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cmms/utils/mandiScaffold.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TraderForm extends StatefulWidget {
  @override
  _TraderFormState createState() => _TraderFormState();
}

class _TraderFormState extends State<TraderForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _states = <String>['', 'GJ', 'MP', 'UP', 'JK'];
  String _state = '';
  List<String> _districts = <String>[
    '',
    'gandhinagar',
    'himmatnagar',
    'ahmedabad',
  ];
  String _district = '';
  List<String> _mandis = <String>[
    '',
    'sundar',
    'prayagraj',
  ];
  String _mandi = '';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _firmController = TextEditingController();

  FirebaseAuth _auth;
  FirebaseUser user;
  UserUpdateInfo userInfo;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    userInfo = UserUpdateInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MandiScaffold(
      isClickable: false,
      title: "Trader Form",
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
                  hintText: 'Enter your first and last name',
                  labelText: 'Name',
                ),
              ),
              new TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  hintText: 'Enter a phone number',
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
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.home),
                      labelText: 'Mandi',
                    ),
                    isEmpty: _mandi == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _mandi,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(
                            () {
                              _mandi = newValue;
                              state.didChange(newValue);
                            },
                          );
                        },
                        items: _mandis.map((String value) {
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
              new TextFormField(
                controller: _firmController,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.local_offer),
                  hintText: 'Enter Firm name',
                  labelText: 'Firm Name',
                ),
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
                        await Mandi.pref
                            .setString(Mandi.namePref, _nameController.text);
                        await Mandi.pref
                            .setString(Mandi.phonePref, _phoneController.text);
                        await Mandi.pref.setString(Mandi.statePref, _state);
                        await Mandi.pref
                            .setString(Mandi.districtPref, _district);

                        await Firestore.instance
                            .collection("traders")
                            .document(_phoneController.text)
                            .setData({
                          "firm": _firmController.text,
                          "phone": _phoneController.text,
                          "name": _nameController.text,
                          "location": {
                            "district": _district,
                            "state": _state,
                            "mandi": _mandi,
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
}
