import 'package:flutter/material.dart';
import 'package:turnstile_admin/theme/AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dashboardPage.dart';

class ExitStatus extends StatefulWidget {
  const ExitStatus({Key? key}) : super(key: key);

  @override
  State<ExitStatus> createState() => _ExitStatusState();
}

class _ExitStatusState extends State<ExitStatus> {
  late List<Map<String, dynamic>> _data = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('http://54.163.33.217:8000/exits/'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          _data = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await fetchData();
  }

  void _handleImageTap(String imageUrl) async {
    if (await canLaunch(imageUrl)) {
      await launch(imageUrl);
    } else {
      throw 'Could not launch $imageUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.exit,
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => dashboardPage()),
          );
        },
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text(AppLocalizations.of(context)!.sr)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.assetid)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.tagid)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.assetname)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.location)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.time)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.image)),
                  ],
                  rows: _data.asMap().entries.map((entry) {
                    int serialNumber = entry.key + 1;
                    Map<String, dynamic> data = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(serialNumber.toString())),
                      DataCell(Text(data['asset_id'].toString())),
                      DataCell(Text(data['tag_id'].toString())),

                      DataCell(Text(data['asset_name'].toString())),
                      DataCell(Text(data['location'].toString())),
                      DataCell(Text(data['time_log'].toString())),
                      DataCell(
                        // Wrap the image text with GestureDetector
                        GestureDetector(
                          onTap: () {
                            _handleImageTap(data['footage'].toString());
                          },
                          child: Text(
                            'View Image',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
