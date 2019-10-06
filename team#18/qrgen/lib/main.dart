import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrgen/Qr.dart';
import 'package:qrgen/gen.dart';

// static var jsonData;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DForm(),
      theme: ThemeData.dark(),
    );
  }
}

class DForm extends StatefulWidget {
  @override
  _DFormState createState() => _DFormState();
}

class _DFormState extends State<DForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _comodities = <String>[
    '',
    'onion',
    'Potato',
    'corn',
    'vegies',
  ];
  String _comodity = '';
  final myControllerp = TextEditingController();
  final myControllers = TextEditingController();
  // var jsonData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hey"),
        centerTitle: true,
      ),
      body: new Container(
        child: new Form(
          key: _formKey,
          autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  hintText: 'Enter a phone number',
                  labelText: 'Phone',
                ),
                controller: myControllerp,
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
                      labelText: 'Comodities',
                    ),
                    isEmpty: _comodity == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _comodity,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _comodity = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _comodities.map((String value) {
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
                decoration: const InputDecoration(
                  icon: const Icon(Icons.local_offer),
                  hintText: '(In Kgs)',
                  labelText: 'Supply',
                ),
                controller: myControllers,
                keyboardType: TextInputType.phone,
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
                  onPressed: () {
                    print("++++++++++++++++++++++++++++++++++++++");
                    print(myControllerp.text);
                    print(myControllers.text);
                    print(_comodity);
                    QR.jsonData =
                        '{ "phone" : "${myControllerp.text}", "supply" : "${myControllers.text}", "comodity" : "$_comodity"  }';
                    print(QR.jsonData.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QrScreen()),
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
