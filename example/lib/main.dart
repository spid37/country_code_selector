import 'package:flutter/material.dart';
import 'package:country_code_selector/country_code_selector.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CountryCode _countryCode;

  void _updateCountryCode(CountryCode countryCode) {
    setState(() {
      _countryCode = countryCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (_countryCode == null)
                ? new Text(
                    'I have no dial code',
                  )
                : new Text(
                    'Got country dial code :  ' + _countryCode.dialCode,
                  ),
            Container(
              padding: EdgeInsets.only(right: 16.0),
              child: new Row(
                children: <Widget>[
                  CountryCodeSelector(
                    onChange: _updateCountryCode,
                    defaultIsoCode: "AU",
                  ),
                  Expanded(
                    child: new TextField(
                      style: TextStyle(fontSize: 22.00, color: Colors.black),
                      decoration: new InputDecoration(
                        hintText: "Mobile number",
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
