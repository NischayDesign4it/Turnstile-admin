import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:turnstile_admin/presentation/siteManagement.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/AppBar.dart';
import 'dashboardPage.dart';

class sitePage extends StatefulWidget {
  const sitePage({super.key});

  @override
  State<sitePage> createState() => _sitePageState();
}

class _sitePageState extends State<sitePage> {
  late List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
      final response = await http.get(Uri.parse('http://54.163.33.217:8000/sites_api/'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          _data = List<Map<String, dynamic>>.from(responseData);
          _isLoading = false;
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
        title: AppLocalizations.of(context)!.site,
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard, onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => dashboardPage()));

      },
      ),
      body:RefreshIndicator(
    onRefresh: () => fetchData(), // Call fetchData method when refreshing
    child: _isLoading
    ? Center(
    child: CircularProgressIndicator(), // Loading indicator
    ):
      ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final site = _data[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => siteManagement(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: ListTile(
                leading: Icon(Icons.fiber_manual_record, size: 15),
                title: Text(site['name'],
                style: TextStyle(fontSize: 20),
                ),
                // You can add more details here if needed
              ),
            ),
          );
        },
      ),
      )
    );
  }
}
