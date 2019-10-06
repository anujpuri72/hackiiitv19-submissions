import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmms/models/mandi.dart';
import 'package:cmms/pages/mandiDetails.dart';
import 'package:cmms/utils/mandiScaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;

  HomePage({@required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String id;

  Future _scanqr() async {
    try {
      String result = await BarcodeScanner.scan();
      setState(() {
        id = result;
        print("-------------------------------");
        print(id);
        print("-------------------------------");
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          id = "camera permission denied";
        });
      } else {
        setState(() {
          id = "an error occured $e";
        });
      }
    } on FormatException {
      setState(() {
        id = " back button pressed";
      });
    } catch (e) {
      setState(() {
        id = "an error occured $e";
      });
    }
  }

  List<String> statesList;
  List<String> districtList = ["ahmedabad", "gandhinagar", "himmatnagar"];
  List<String> mandiList;
  List<String> commodityList;

  String stateValue = "GJ";
  String districtValue = "gandhinagar";

  String commodityValue = "tomato";

  Future<QuerySnapshot> _mandiFuture;
  Future<DocumentSnapshot> _statesFuture;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<Mandi> availableMandis;

  @override
  void initState() {
    super.initState();
    _mandiFuture = Firestore.instance.collection("mandi").getDocuments();
    _statesFuture =
        Firestore.instance.collection("states").document("data").get();
  }

  @override
  Widget build(BuildContext context) {
    return MandiScaffold(
      floatingButton: new FloatingActionButton.extended(
        icon: Icon(Icons.camera),
        label: Text("Scan me"),
        onPressed: _scanqr,
        tooltip: "scan code",
      ),
      isClickable: true,
      title: "Home Page",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: FutureBuilder<DocumentSnapshot>(
              future: _statesFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                      child: Text("Error Occured: ${snapshot.error}"),
                    );
                  } else {
                    statesList = List(snapshot.data.data["states"].length);
                    districtList =
                        List<String>(snapshot.data.data["GJ"].length);
                    mandiList = List<String>(30);
                    commodityList =
                        List<String>(snapshot.data.data["commodities"].length);

                    for (int i = 0;
                        i < snapshot.data.data["states"].length;
                        i++) {
                      statesList[i] = snapshot.data.data["states"][i];
                    }

                    for (int i = 0;
                        i < snapshot.data.data["commodities"].length;
                        i++) {
                      commodityList[i] = snapshot.data.data["commodities"][i];
                    }

                    for (int i = 0; i < snapshot.data.data["GJ"].length; i++) {
                      districtList[i] = snapshot.data.data["GJ"][i];
                    }

                    return Form(
                      key: _formKey,
                      autovalidate: true,
                      child: new ListView(
                        children: <Widget>[
                          new FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.home),
                                  labelText: 'State',
                                ),
                                isEmpty: stateValue == '',
                                child: new DropdownButtonHideUnderline(
                                  child: new DropdownButton(
                                    value: stateValue,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      for (int i = 0;
                                          i <
                                              snapshot
                                                  .data.data[newValue].length;
                                          i++) {
                                        districtList[i] =
                                            snapshot.data.data[newValue][i];
                                      }
                                      setState(() {
                                        stateValue = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: statesList.map((String value) {
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
                                  labelText: 'Districts',
                                ),
                                isEmpty: districtValue == '',
                                child: new DropdownButtonHideUnderline(
                                  child: new DropdownButton(
                                    value: districtValue,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        districtValue = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: districtList.map((String value) {
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
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("mandi")
                  .document(stateValue + "-" + districtValue)
                  .collection("sundar")
                  .document("data")
                  .collection("commodities")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.none ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitWanderingCubes(
                      color: Colors.red,
                    ),
                  );
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error"),
                    );
                  } else {
                    List<ListTile> listTile = List();
                    for (int i = 0; i < snapshot.data.documents.length; i++) {
                      listTile.add(
                        ListTile(
                          leading: SizedBox(
                            width: 60,
                            child: Text(
                              "${snapshot.data.documents[i].data["name"]}",
                              textScaleFactor: 1.2,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          title: Text(
                              "Demand: ${snapshot.data.documents[i].data["demand"]}"),
                          subtitle: Text(
                              "Supply: ${snapshot.data.documents[i].data["supply"]}"),
                          trailing: Text(
                              "Price per Q ${snapshot.data.documents[i].data["price"]}"),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MandiDetails(
                                    docName: stateValue + "-" + districtValue,
                                    i: i,
                                    snapshot: snapshot,
                                    user: widget.user,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Column(
                      children: listTile,
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
