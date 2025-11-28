import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  
 

  Locale get locale => _locale;
  
  

  final List<Locale> _supportedLocales = const [
    Locale('en'),
    Locale('ar'),
  ];

  void setLocale(Locale locale) {
    if (!_supportedLocales.contains(locale)) return;
    
    _locale = locale;
    
    
    notifyListeners();
  }
}
