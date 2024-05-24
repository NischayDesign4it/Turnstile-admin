import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme/AppBar.dart';
import 'dashboardPage.dart';
import 'loginPage.dart';

class settingPage extends StatefulWidget {
  const settingPage({super.key});

  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.settings,
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard, onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => dashboardPage()));

      },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            ListTile( title: Text(AppLocalizations.of(context)!.profile, style: TextStyle(fontSize: 20),),
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => LoginPage()));
              },
            ),
            Divider(),
            ListTile( title: Text(AppLocalizations.of(context)!.faq, style: TextStyle(fontSize: 20),),
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => LoginPage()));
              },
            ),
            Divider(),
            ListTile( title: Text(AppLocalizations.of(context)!.logout, style: TextStyle(fontSize: 20),),
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
