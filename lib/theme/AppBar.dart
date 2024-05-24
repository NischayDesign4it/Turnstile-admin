import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnstile_admin/theme/language.dart';

import '../controller/language_change_controller.dart';

enum Language { english, spanish }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final IconData? icon;
  final VoidCallback? onPressed;

  CustomAppBar(
      {Key? key,
      required this.title,
      required this.backgroundColor,
      this.icon,
      this.onPressed})
      : super(key: key);

  // void _changeLanguage(Language language) {
  //   print(language.languageCode);
  //   // You can implement your language change logic here
  // }

  @override
  Size get preferredSize => Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.5),
      //       spreadRadius: 5,
      //       blurRadius: 7,
      //       offset: Offset(0, 3),
      //     ),
      //   ],
      // ),
      child: AppBar(
        backgroundColor: backgroundColor,
        title: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            onPressed: onPressed,
          ),
          // PopupMenuButton<Language>(
          //   icon: Icon(Icons.language, color: Colors.white),
          //   onSelected: (Language language) {
          //     _changeLanguage(language);
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return Language.languageList().map((Language lang) {
          //       return PopupMenuItem<Language>(
          //         value: lang,
          //         child: Row(
          //           children: <Widget>[
          //             Text(lang.flag),
          //             SizedBox(width: 8),
          //             Text(lang.name),
          //           ],
          //         ),
          //       );
          //     }).toList();
          //   },
          // ),

          Consumer<LanguageChangeController>(
            builder: (context, provider, child) {
              return PopupMenuButton(
                icon: Icon(Icons.language, color: Colors.white),
                onSelected: (Language item) {
                  if (item == Language.english) {
                    // Logic for changing to English
                    provider.changeLanguage(Locale('en'));
                  } else {
                    // Logic for changing to Spanish
                    provider.changeLanguage(Locale('es'));
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<Language>>[
                  const PopupMenuItem(
                    value: Language.english,
                    child: Text('🇺🇸English'),
                  ),
                  PopupMenuItem(
                    value: Language.spanish,
                    child: Text('🇪🇸Spanish'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
