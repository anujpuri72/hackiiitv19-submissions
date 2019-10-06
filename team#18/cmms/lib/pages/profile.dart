import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Profile extends StatefulWidget {
  final FirebaseUser user;

  Profile({@required this.user});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // var document = await Firestore.instance.collection("farmers").document(widget.user.phoneNumber).get();
    // String name,phone,district,state;
    // name=document.data["name"]
    print("=========================================");
    // print(widget.user.phoneNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Profile"),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/wheat.png"),
          ),
        ),
      ),
      body: FutureBuilder(
        future: Firestore.instance.collection("farmers").document("an").get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: SpinKitWanderingCubes(
                color: Colors.red,
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error occured"),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/wheat.png"),
                        radius: 100,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      padding: const EdgeInsets.all(30),
                      child: Table(children: [
                        TableRow(children: [
                          TableCell(
                            child: Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w500),
                            ),
                          ),
                          TableCell(
                              child: Text(
                                "Anuj",
                                style: TextStyle(fontSize: 33),
                              ),
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle)
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Text(
                              "Phone",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w500),
                            ),
                          ),
                          TableCell(
                              child: Text(
                                // snapshot.data["phone"],
                                "7889561310",
                                style: TextStyle(fontSize: 30),
                              ),
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle)
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Text(
                              "State",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w500),
                            ),
                          ),
                          TableCell(
                              child: Text(
                                // snapshot.data["state"],
                                "GJ",
                                style: TextStyle(fontSize: 30),
                              ),
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle)
                        ]),
                        TableRow(children: [
                          TableCell(
                            child: Text(
                              "District",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w500),
                            ),
                          ),
                          TableCell(
                              child: Text(
                                // snapshot.data["state"],
                                "g-nagar",
                                style: TextStyle(fontSize: 30),
                              ),
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle)
                        ]),
                      ]),
                    )
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
