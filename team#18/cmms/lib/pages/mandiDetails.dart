import 'package:cmms/utils/mandiScaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MandiDetails extends StatefulWidget {
  final FirebaseUser user;
  final AsyncSnapshot snapshot;
  final int i;
  MandiDetails({
    @required this.user,
    @required this.snapshot,
    @required this.i,
  });

  @override
  _MandiDetailsState createState() => _MandiDetailsState();
}

class _MandiDetailsState extends State<MandiDetails> {
  @override
  Widget build(BuildContext context) {
    return MandiScaffold(
      title: "Real Time Details",
      isClickable: true,
      user: widget.user,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
                showCard("district"),
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget showCard(String parameter) {
    return SizedBox(
      height: 80,
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
