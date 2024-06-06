import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:turnstile_admin/presentation/assetDetail.dart';
import 'package:turnstile_admin/presentation/exitStatus.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/AppBar.dart';
import 'dashboardPage.dart';

class assetManagement extends StatefulWidget {
  const assetManagement({Key? key});

  @override
  State<assetManagement> createState() => _assetManagementState();
}

class _assetManagementState extends State<assetManagement> {
  late List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://44.214.230.69:8000/get_assets_api/'));

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
        title: AppLocalizations.of(context)!.assetlist,
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
    ): ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final asset = _data[index];
          return GestureDetector(
            onTap: () {
              _showAssetDetailsDialog(asset);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                leading: Icon(Icons.fiber_manual_record, size: 15), // Use a bullet point icon
                title: Text(
                  asset['asset_name'],
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  'Asset ID: ${asset['asset_id']}',
                  style: TextStyle(fontSize: 16),
                ),
                // You can add more details here if needed
              ),
            ),
          );
        },
      ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Color(0xff071390),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssetDetail(assetId: 00)
                  ),
                );
              },
              child: Icon(Icons.add, color: Colors.white),
            ),
            SizedBox(width: 10),
            FloatingActionButton(
              backgroundColor: Color(0xff071390),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExitStatus(),
                  ),
                );
              },
              child: Icon(Icons.exit_to_app, color: Colors.white),
            ),
          ],
        ),
      ),

    );
  }


  void _showAssetDetailsDialog(Map<String, dynamic> asset) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(asset['asset_name']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Asset Name: ${asset['asset_name']}'),
              Text('Asset ID: ${asset['asset_id']}'),
              Text('Description: ${asset['description']}'),
              Text('Cateory: ${asset['asset_category']}'),
              // Add more asset details here as needed
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
}
