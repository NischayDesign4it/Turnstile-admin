

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController with ChangeNotifier {

  Locale? _applocale;
  Locale? get appLocale => _applocale;

  void changeLanguage(Locale type) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    _applocale = type;


    if(type == Locale('en')){
      await sp.setString('language_code', 'en');
    }else {
      await sp.setString('language_code', 'es');
    }
    notifyListeners();

  }
}