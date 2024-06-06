import 'package:flutter/material.dart';
import 'package:turnstile_admin/controller/language_change_controller.dart';
import 'package:turnstile_admin/presentation/dashboardPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnstile_admin/presentation/loginPage.dart';
import 'package:turnstile_admin/presentation/siteManagement.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  final String languageCode = sp.getString("language_code") ?? '';

  runApp(MyApp(locale: languageCode));
}

class MyApp extends StatelessWidget {
  final String locale;
  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageChangeController())
        ],
        child: Consumer<LanguageChangeController>(
            builder: (context, provider, child) {
              if(locale.isEmpty){
                provider.changeLanguage(Locale('en'));
              }
          return MaterialApp(
            locale: locale == '' ? Locale('en') : provider.appLocale == null ? Locale('en') : provider.appLocale,
            supportedLocales: [
              Locale('en', 'US'), // English
              Locale('es', 'ES'), // Spanish
            ],
            localizationsDelegates: [
              AppLocalizations.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            home: LoginPage(),
          );
        }));
  }
}
