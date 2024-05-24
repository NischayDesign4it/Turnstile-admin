import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:turnstile_admin/presentation/preShift.dart';
import 'package:turnstile_admin/presentation/toolBox.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:turnstile_admin/theme/CustomButton.dart';

import '../theme/AppBar.dart';
import 'dashboardPage.dart';

class DocViewScreen extends StatefulWidget {
  const DocViewScreen({Key? key}) : super(key: key);

  @override
  _DocViewScreenState createState() => _DocViewScreenState();
}

class _DocViewScreenState extends State<DocViewScreen> {
  late TextEditingController _dateController;
  late List<dynamic> preshiftDocLinks;
  late List<dynamic> toolboxDocLinks;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    preshiftDocLinks = [];
    toolboxDocLinks = [];
  }

  Future<void> _callAPI({String? dateFilter}) async {
    final preshiftUri = Uri.parse('http://54.163.33.217:8000/preshift_api/');
    final toolboxUri = Uri.parse('http://54.163.33.217:8000/toolbox_api/');

    final preshiftResponse = await http.get(preshiftUri);
    final toolboxResponse = await http.get(toolboxUri);

    if (preshiftResponse.statusCode == 200 && toolboxResponse.statusCode == 200) {
      final List<dynamic> preshiftData = jsonDecode(preshiftResponse.body);
      final List<dynamic> toolboxData = jsonDecode(toolboxResponse.body);

      setState(() {
        if (dateFilter != null && dateFilter.isNotEmpty) {
          preshiftDocLinks = preshiftData
              .where((data) => data['date'] == dateFilter)
              .toList();
          toolboxDocLinks = toolboxData
              .where((data) => data['date'] == dateFilter)
              .toList();
        } else {
          preshiftDocLinks = preshiftData;
          toolboxDocLinks = toolboxData;
        }
      });
    } else {
      // Handle error
      print('Failed to load data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: AppLocalizations.of(context)!.docView, backgroundColor: Color(0xff071390),
          icon: Icons.dashboard, onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => dashboardPage()));

          },
        ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.fiber_manual_record, size: 15),
              title: Text(AppLocalizations.of(context)!.pre,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreShiftScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.fiber_manual_record, size: 15),
              title: Text(AppLocalizations.of(context)!.tool,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToolBoxScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      )


      // Padding(
      //   padding: const EdgeInsets.all(20.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: <Widget>[
      //       SizedBox(height: 20),
      //       TextField(
      //         controller: _dateController,
      //         decoration: InputDecoration(labelText: 'Enter Date'),
      //       ),
      //       SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () {
      //           final dateFilter = _dateController.text.trim();
      //           _callAPI(dateFilter: dateFilter);
      //         },
      //         child: Text('Filter by Date'),
      //       ),
      //       SizedBox(height: 20),
      //       Text("PRE-SHIFT"),
      //       SizedBox(height: 20),
      //       Expanded(
      //         child: ListView.builder(
      //           itemCount: preshiftDocLinks.length,
      //           itemBuilder: (context, index) {
      //             final docLink = preshiftDocLinks[index]['document'];
      //             return AspectRatio(
      //               aspectRatio: 16 / 9, // Adjust aspect ratio as needed
      //               child: Image.network(
      //                 docLink,
      //                 fit: BoxFit.contain,
      //                 errorBuilder: (context, error, stackTrace) {
      //                   return Center(
      //                     child: Text('Error loading image'),
      //                   );
      //                 },
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //       Text("TOOLBOX"),
      //       SizedBox(height: 20),
      //       Expanded(
      //         child: ListView.builder(
      //           itemCount: toolboxDocLinks.length,
      //           itemBuilder: (context, index) {
      //             final docLink = toolboxDocLinks[index]['document'];
      //             return AspectRatio(
      //               aspectRatio: 16 / 12, // Adjust aspect ratio as needed
      //               child: Image.network(
      //                 docLink,
      //                 fit: BoxFit.contain,
      //                 errorBuilder: (context, error, stackTrace) {
      //                   return Center(
      //                     child: Text('Error loading image'),
      //                   );
      //                 },
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
