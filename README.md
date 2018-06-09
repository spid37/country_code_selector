# country code selector

Flutter package for selecting country dial codes

```dart
// callback on change
void _updateCountryCode(CountryCode countryCode) {
   setState(() {
     _countryCode = countryCode;
   });
 }

// widget to display the country code selector
CountryCodeSelector(
   onChange: _updateCountryCode,
   defaultIsoCode: "AU",
),
```

example images.

![country code screenshot selected](https://raw.githubusercontent.com/spid37/country_code_selector/master/example/screenshots/selectedcountrycode.png 'Selected country code')

![country code screenshot ](https://raw.githubusercontent.com/spid37/country_code_selector/master/example/screenshots/selectcountrycode.png 'Select country code')

![country code screenshot](https://raw.githubusercontent.com/spid37/country_code_selector/master/example/screenshots/searchcountrycode.png 'Search country code')

---

Flag icons designed by Freepik from Flaticon,
[https://www.flaticon.com/packs/flags-collection](https://www.flaticon.com/packs/flags-collection)
