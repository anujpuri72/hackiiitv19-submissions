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
            Wrap(
              children: <Widget>[
                showCard("demand"),
                showCard("supply"),
                showCard("farmers"),
                showCard("traders"),
                showCard("price"),
                showCard("district"),
                showCard("name"),
              ],
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
      child: ListTile(
        // elevation: 5,
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
    );
  }
}
