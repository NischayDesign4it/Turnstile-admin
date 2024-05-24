import 'package:flutter/material.dart';
import 'package:turnstile_admin/presentation/assetManagement.dart';
import 'package:turnstile_admin/presentation/docViewPage.dart';
import 'package:turnstile_admin/presentation/workerManagement.dart';
import 'package:turnstile_admin/theme/AppBar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dashboardPage.dart';


class siteManagement extends StatefulWidget {
  const siteManagement({super.key});

  @override
  State<siteManagement> createState() => _siteManagementState();
}

class _siteManagementState extends State<siteManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.sitemanage, backgroundColor: Color(0xff071390),
        icon: Icons.dashboard, onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => dashboardPage()));

        },
      ),
      body: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.fiber_manual_record, size: 15),
              title: Text(AppLocalizations.of(context)!.usermanage,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => workerManagement(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.fiber_manual_record, size: 15),
              title: Text(AppLocalizations.of(context)!.assetmanage,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => assetManagement(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.fiber_manual_record, size: 15),
              title: Text(AppLocalizations.of(context)!.docView,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocViewScreen(),
                  ),
                );
              },
            ),
            // Add more ListTiles as needed
          ],
        ),

    );
  }
}
