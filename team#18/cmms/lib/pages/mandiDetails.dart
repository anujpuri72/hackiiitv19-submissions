import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmms/utils/Mandi.dart';
import 'package:cmms/utils/mandiScaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MandiDetails extends StatefulWidget {
  final FirebaseUser user;
  final AsyncSnapshot snapshot;
  final int i;
  final String docName;
  MandiDetails({
    @required this.docName,
    @required this.user,
    @required this.snapshot,
    @required this.i,
  });

  @override
  _MandiDetailsState createState() => _MandiDetailsState();
}

class _MandiDetailsState extends State<MandiDetails> {
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MandiScaffold(
      title: "Real Time Details",
      isClickable: true,
      user: widget.user,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              showCard("name"),
              SizedBox(
                height: 30,
              ),
              Wrap(
                runSpacing: 15,
                spacing: 15,
                children: <Widget>[
                  showCard("demand"),
                  showCard("supply"),
                  showCard("farmers"),
                  showCard("traders"),
                  showCard("price"),
                  showCard("mandi"),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              MaterialButton(
                child: Text(
                  "Book my Slot",
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
                  return showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                            "Enter Amount of ${widget.snapshot.data.documents[widget.i].data["name"]} you are bringing: "),
                        content: TextFormField(
                          controller: _amountController,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {},
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () async {
                              await Firestore.instance
                                  .collection("farmers")
                                  .document(
                                      Mandi.pref.getString(Mandi.phonePref))
                                  .setData(
                                {
                                  "isEligible": false,
                                },
                                merge: true,
                              );
                              await Firestore.instance
                                  .collection("farmers")
                                  .document(
                                      Mandi.pref.getString(Mandi.phonePref))
                                  .collection("history")
                                  .document(DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString())
                                  .setData({
                                "commodity": widget.snapshot.data
                                    .documents[widget.i].data["name"],
                                "quantity": _amountController.text,
                                "time": DateTime.now().millisecondsSinceEpoch,
                              });

                              await Firestore.instance
                                  .collection("mandi")
                                  .document(widget.docName)
                                  .collection("sundar")
                                  .document("data")
                                  .collection("commodities")
                                  .document(widget.snapshot.data
                                      .documents[widget.i].data["name"])
                                  .updateData({
                                "supply": FieldValue.increment(
                                    int.parse(_amountController.text)),
                                "farmers": FieldValue.increment(1),
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showCard(String parameter) {
    return SizedBox(
      height: 100,
      width: 160,
      child: Card(
        elevation: 7,
        child: ListTile(
          title: Text(
            "${widget.snapshot.data.documents[widget.i].data[parameter]}",
            style: TextStyle(
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            parameter,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
