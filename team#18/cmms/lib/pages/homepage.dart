import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmms/models/mandi.dart';
import 'package:cmms/utils/mandiScaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;

  HomePage({@required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> statesList; // = ["GJ", "UP"];
  List<String> districtList = ["ahmedabad", "gandhinagar", "himmatnagar"];
  List<String> mandiList; // = ["sundar", "prayagraj"];
  List<String> commodityList; // = ["tomato", "onion"];

  String stateValue = "GJ";
  String districtValue = "gandhinagar";
  // String mandiValue = "prayagraj";
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
      isClickable: true,
      title: "Home Page",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
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
                    // print(snapshot.data.data["gandhinagar"]);
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

                    print("Values: ${statesList}");
                    print("Values: ${commodityList}");
                    print("Values: ${districtList}");

                    //   //this is where the magic happens
                    //   statesList = List<String>(snapshot.data.documents.length);
                    //   for (int i = 0; i < snapshot.data.documents.length; i++) {
                    //     statesList[i] = snapshot.data.documents[i].documentID;
                    //   }
                    //   print(statesList);
                    //   // print(snapshot.data.documents.length);
                    //   // locations = Locations();
                    //   print(snapshot.data.documents[0].data.length);
                    //   print(snapshot.data.documents[0].data.keys.toList()[0]);
                    //   districtList
                    //       .addAll(snapshot.data.documents[0].data.keys.toList());
                    //   print(districtList);
                    //   // for (int i = 0;
                    //   //     i < snapshot.data.documents[0].data.length;
                    //   //     i++) {
                    //   //     }

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
                                      // print(newValue);
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
                          new FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.home),
                                  labelText: 'Comodities',
                                ),
                                isEmpty: commodityValue == '',
                                child: new DropdownButtonHideUnderline(
                                  child: new DropdownButton(
                                    value: commodityValue,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        commodityValue = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: commodityList.map((String value) {
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
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("mandi")
                    .document(stateValue + "-" + districtValue)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                      print(
                        "Accessing document: " +
                            stateValue +
                            "-" +
                            districtValue,
                      );

                      // print(snapshot.data["mandis"].length);
                      // print(snapshot.data["mandis"][0]);
                      // print(snapshot.data["mandis"]);
                      // for (int i = 0; i < snapshot.data["mandis"].length; i++) {
                      // print("index $i  ${snapshot.data["mandis"][i]}");
                      // for (int j = 0;
                      //     j < snapshot.data["mandis"]["commodities"];
                      //     j++) {}
                      // print(
                      //     "index $i  ${snapshot.data["mandis"][i]["commodities"]}");
                      // print("index $i  ${snapshot.data.data}");
                      // availableMandis[i].toJson();
                      // print(mandi.mandis);
                      // }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ListTile(),
                        ],
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ListTile> giveListTiles() {}

  // List<TableRow> completetable(AsyncSnapshot<QuerySnapshot> snapshot) {
  //   List<TableRow> row = List<TableRow>();
  //   row.add(tableHeader());
  //   for (int i = 0; i < 2; i++) {
  //     // row.add(tableElements(snapshot));
  //   }
  //   return row;
  // }

  // TableRow tableHeader() {
  //   return TableRow(
  //     children: <Widget>[
  //       Text("Mandi"),
  //       Text("Commodity"),
  //       Text("Price"),
  //       Text("Supply"),
  //       Text("Demand"),
  //     ],
  //   );
  // }

  // TableRow tableElements(AsyncSnapshot<DocumentSnapshot> snapshot) {
  //   // print(snapshot.data.documentID);
  //   return TableRow(
  //     children: <Widget>[
  //       Text("sundar"),
  //       Text("${snapshot.data["name"]}"),
  //       Text("${snapshot.data["price_modal"]}"),
  //       Text("${snapshot.data["supply"]}"),
  //       Text("${snapshot.data["demand"]}"),
  //     ],
  //   );
  // }
}
