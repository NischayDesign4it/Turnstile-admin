import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:turnstile_admin/theme/AppBar.dart';

class demoScreen extends StatelessWidget {
  const demoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.helloWorld, backgroundColor: Colors.black,
      ),
    );
  }
}
