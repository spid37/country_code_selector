library country_code_selector;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class CountryCode {
  final String country;
  final String isoCode;
  final String dialCode;
  final String image;

  CountryCode({this.dialCode, this.country, this.isoCode, this.image});

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return new CountryCode(
      dialCode: json['dialCode'] as String,
      country: json['country'] as String,
      isoCode: json['isoCode'] as String,
      image: json['image'] as String,
    );
  }
}

class CountryCodeSelector extends StatefulWidget {
  final String defaultIsoCode;
  final Function(CountryCode) onChange;

  CountryCodeSelector({
    @required this.onChange,
    this.defaultIsoCode = 'AU', // default selected country
  });

  @override
  _CountryCodeSelectorState createState() => new _CountryCodeSelectorState();
}

class _CountryCodeSelectorState extends State<CountryCodeSelector> {
  List<CountryCode> _countryCodes;
  CountryCode _countryCode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    try {
      _loadCountryCodes();
    } catch (e) {}
  }

  void _loadCountryCodes() async {
    final countryCodesData = await rootBundle
        .loadString('packages/country_code_selector/assets/countryCodes.json');
    final parsed = json.decode(countryCodesData).cast<Map<String, dynamic>>();
    // add the country codes to a list
    List<CountryCode> countryCodes = parsed
        .map<CountryCode>((json) => new CountryCode.fromJson(json))
        .toList();

    // get the default code or the first in the list
    CountryCode defaultCountryCode = countryCodes.singleWhere(
      (c) => c.isoCode == widget.defaultIsoCode,
      orElse: () => countryCodes[0],
    );

    // set country codes the state
    setState(() {
      _countryCodes = countryCodes;
      _countryCode = defaultCountryCode;
      _isLoading = false;
    });

    // send parent default counrty code
    widget.onChange(defaultCountryCode);
  }

  void setCountryCode(CountryCode code) {
    setState(() {
      _countryCode = code;
    });
    // call the parent callback
    widget.onChange(code);
  }

  Future<Null> _showDialog() async {
    CountryCode selectedCode = await showDialog(
      context: context,
      builder: (context) => new SelectDialog(_countryCodes),
    );

    if (selectedCode != null) {
      setCountryCode(selectedCode);
    }
  }

  Widget _selectButton() {
    return new FlatButton(
      child: Row(
        children: <Widget>[
          new Image(
            width: 38.00,
            image: new AssetImage(
              _countryCode.image,
              package: "country_code_selector",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text(
              "${_countryCode.isoCode} (+${_countryCode.dialCode}) ▼",
              style: TextStyle(fontSize: 16.00),
            ),
          ),
        ],
      ),
      onPressed: () {
        _showDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? new Container() : new Container(child: _selectButton());
  }
}

class SelectDialog extends StatefulWidget {
  @override
  _SelectDialogState createState() => _SelectDialogState();
  final List<CountryCode> countryCodes;

  SelectDialog(this.countryCodes);
}

class _SelectDialogState extends State<SelectDialog> {
  String _countryCodesSearch = "";
  List<CountryCode> _countryCodes;

  @override
  void initState() {
    // set countryCodes to state
    _countryCodes = widget.countryCodes;
    super.initState();
  }

  void _updateSearch(String s) {
    setState(() {
      _countryCodesSearch = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Column(
        children: <Widget>[
          new Text("Select country code"),
          new TextField(
            onChanged: _updateSearch,
            decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.search),
                hintText: "Search country or code"),
          ),
        ],
      ),
      children: <Widget>[]..addAll(
          _filterCountryCodes(_countryCodesSearch).map((c) {
            return new SimpleDialogOption(
              child: _dialogCountryCodeOption(c),
              onPressed: () {
                Navigator.pop(context, c);
              },
            );
          }),
        ),
    );
  }

  List<CountryCode> _filterCountryCodes(String s) {
    s = s.toLowerCase();
    if (s.length == 0) {
      return _countryCodes;
    }
    return _countryCodes
        .where((i) =>
            i.dialCode.startsWith(s) ||
            i.isoCode.toLowerCase().startsWith(s) ||
            i.country.toLowerCase().contains(s))
        .toList();
  }

  Widget _dialogCountryCodeOption(CountryCode c) {
    return new Row(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: new Image(
            width: 35.00,
            image: new AssetImage(
              c.image,
              package: "country_code_selector",
            ),
          ),
        ),
        new Expanded(
          child: new Text(
            "${c.country} (${c.isoCode})",
            maxLines: 2,
          ),
        ),
        new Text("+${c.dialCode}"),
      ],
    );
  }
}
