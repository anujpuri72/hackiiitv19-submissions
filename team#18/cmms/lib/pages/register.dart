import 'package:cmms/pages/farmerRegistration.dart';
import 'package:cmms/pages/traderRegistration.dart';
import 'package:cmms/utils/mandiScaffold.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return MandiScaffold(
      isClickable: false,
      title: "Register",
      body: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                height: 180.0,
                width: 180.0,
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
                margin: new EdgeInsets.fromLTRB(0, 80, 0, 80),
                alignment: Alignment.center,
                child: Text(
                  "Register as :",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                    child: Text(
                      "Farmer",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    height: 70,
                    minWidth: 150,
                    color: Colors.green,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(27)),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => FarmerForm()),
                      );
                      ;
                    },
                  ),
                  MaterialButton(
                    child: Text(
                      "Trader",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    height: 70,
                    minWidth: 150,
                    color: Colors.green,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(27)),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => TraderForm()),
                      );
                      ;
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
