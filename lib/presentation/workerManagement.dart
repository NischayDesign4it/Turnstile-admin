import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnstile_admin/presentation/workerDetail.dart';
import 'package:turnstile_admin/theme/AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dashboardPage.dart'; // Import url_launcher package

class workerManagement extends StatefulWidget {
  const workerManagement({Key? key}) : super(key: key);

  @override
  State<workerManagement> createState() => _workerManagementState();
}

class _workerManagementState extends State<workerManagement> {
  late Map<String, List<Map<String, dynamic>>> _groupedData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://54.163.33.217:8000/users/'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        // Group workers by company name
        Map<String, List<Map<String, dynamic>>> groupedData = {};
        for (var worker in responseData) {
          final companyName = worker['company_name'];
          if (!groupedData.containsKey(companyName)) {
            groupedData[companyName] = [];
          }
          groupedData[companyName]!.add(worker);
        }

        setState(() {
          _groupedData = groupedData;
          _isLoading = false;
          print(_groupedData);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.workerlist,
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard, onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => dashboardPage()));

      },
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchData(), // Call fetchData method when refreshing
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(), // Loading indicator
              )
            : ListView.builder(
                itemCount: _groupedData.length,
                itemBuilder: (context, index) {
                  final companyName = _groupedData.keys.elementAt(index);
                  final workers = _groupedData[companyName]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ListTile(
                        leading: Icon(Icons.fiber_manual_record, size: 15),
                        title: Text(
                          companyName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: workers.length,
                        itemBuilder: (context, index) {
                          final worker = workers[index];
                          return GestureDetector(
                            onTap: () {
                              _showWorkerDetailsDialog(worker);
                            },
                            child: ListTile(
                              title: Text(
                                worker['name'],
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                'Tag ID: ${worker['tag_id']}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff071390),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkerDetail(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showWorkerDetailsDialog(Map<String, dynamic> worker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(worker['name']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tag ID: ${worker['name']}'),
              Text('Company-Name: ${worker['company_name']}'),
              Text('Job-Role: ${worker['job_role']}'),
              Text('Job-Location: ${worker['job_location']}'),
              Text('Company-ID: ${worker['mycompany_id']}'),
              GestureDetector(
                onTap: () {
                  // Launch the document URL
                  _launchDocument(worker['orientation']);
                },
                child: Text(
                  'Orientation: View Document',
                  style: TextStyle(
                    color: Colors.blue,
                    // Make the text blue to indicate it's clickable
                    decoration: TextDecoration
                        .underline, // Add underline to indicate it's a link
                  ),
                ),
              ),
              // Add more worker details here as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchDocument(String url) async {
    if (await canLaunch(url)) {
      await launch(Uri.parse(url).toString());
    } else {
      throw 'Could not launch $url';
    }
  }
}
