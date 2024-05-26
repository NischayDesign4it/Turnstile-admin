import 'package:flutter/material.dart';
import 'package:turnstile_admin/presentation/assetManagement.dart';
import 'package:turnstile_admin/presentation/docViewPage.dart';
import 'package:turnstile_admin/presentation/workerManagement.dart';
import 'package:turnstile_admin/theme/AppBar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dashboardPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class siteManagement extends StatefulWidget {
  const siteManagement({super.key});

  @override
  State<siteManagement> createState() => _siteManagementState();
}

class _siteManagementState extends State<siteManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.sitemanage,
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => dashboardPage()));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.fiber_manual_record, size: 15),
              title: Text(
                AppLocalizations.of(context)!.usermanage,
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
              title: Text(
                AppLocalizations.of(context)!.assetmanage,
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
              title: Text(
                AppLocalizations.of(context)!.docView,
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
            // Divider(),

            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 50.0,
                  columns: [
                    DataColumn(label: Text(AppLocalizations.of(context)!.workerdetail)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.numberUser)),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text(AppLocalizations.of(context)!.enroll)),
                      DataCell(Text('             10', )),
                    ]),
                    DataRow(cells: [
                      DataCell(Text(AppLocalizations.of(context)!.active)),
                      DataCell(Text('             7', )),
                    ]),
                    DataRow(cells: [
                      DataCell(Text(AppLocalizations.of(context)!.inactive)),
                      DataCell(Text('             3', )),
                    ]),
                    DataRow(cells: [
                      DataCell(Text(AppLocalizations.of(context)!.onsite)),
                      DataCell(Text('             5', )),
                    ]),

                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 50.0,
                  columns: [
                    DataColumn(label: Text(AppLocalizations.of(context)!.onsite)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.time)),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('Emp 1')),
                      DataCell(Text('2024-05-24T3:56PM')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Emp 2')),
                      DataCell(Text('2024-05-24T6:56PM')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Emp 3')),
                      DataCell(Text('2024-05-24T1:56PM')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Emp 4')),
                      DataCell(Text('2024-05-24T4:56PM')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Emp 5')),
                      DataCell(Text('2024-05-24T2:56PM')),
                    ]),

                  ],
                ),
              ),
            ),



            // Add more ListTiles as needed
          ],
        ),
      ),
    );
  }
}
