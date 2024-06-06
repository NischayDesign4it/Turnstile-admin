import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:turnstile_admin/theme/AppBar.dart';
import 'package:turnstile_admin/theme/CustomButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'QRScanner.dart';
import 'dashboardPage.dart';

class AssetDetail extends StatefulWidget {
  final int assetId;

  AssetDetail({Key? key, required this.assetId}) : super(key: key);

  @override
  State<AssetDetail> createState() => _AssetDetailState(assetId);
}

class _AssetDetailState extends State<AssetDetail> {
  late TextEditingController asset_nameController;
  late TextEditingController asset_idController;
  late TextEditingController descriptionController;
  late TextEditingController asset_categoryController;

  String selectedStatus = 'active'; // Default status

  _AssetDetailState(int assetId) {
    asset_nameController = TextEditingController();
    asset_idController = TextEditingController(text: assetId.toString());
    descriptionController = TextEditingController();
    asset_categoryController = TextEditingController();
  }

  Future<void> AssetRegister(
      BuildContext context,
      String asset_name,
      int asset_id,
      String description,
      String asset_category,
      String status) async {
    final String apiUrl = 'http://44.214.230.69:8000/asset_api/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'asset_name': asset_name,
          'asset_id': asset_id.toString(),
          'description': description,
          'asset_category': asset_category,
          'status': status,
        },
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.success),
              content: Text(AppLocalizations.of(context)!.assetCreate),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
                ),
              ],
            );
          },
        );
      } else {
        print('Registration failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect info... Please try again.'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Error during registration: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred. Please try again later.',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> statusOptions = ['active', 'inactive'];

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.assetdetail,
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard, onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => dashboardPage()));

      },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            TextField(
              controller: asset_nameController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: AppLocalizations.of(context)!.assetname,
                labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                prefixIcon: Icon(Icons.category_outlined),
                suffixIcon: Icon(Icons.mic),
                contentPadding: EdgeInsets.only(top: 12, bottom: 12),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: asset_idController,
              cursorColor: Colors.black,
              enabled: false, // Disable editing
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: AppLocalizations.of(context)!.assetid,
                labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                prefixIcon: Icon(Icons.numbers),
                suffixIcon: Icon(Icons.mic),
                contentPadding: EdgeInsets.only(top: 12, bottom: 12),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: AppLocalizations.of(context)!.desc,
                labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                prefixIcon: Icon(Icons.description),
                suffixIcon: Icon(Icons.mic),
                contentPadding: EdgeInsets.only(top: 12, bottom: 12),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: asset_categoryController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: AppLocalizations.of(context)!.category,
                labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                prefixIcon: Icon(Icons.category),
                suffixIcon: Icon(Icons.mic),
                contentPadding: EdgeInsets.only(top: 12, bottom: 12),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField(
              value: selectedStatus,
              items: statusOptions.map((String status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: AppLocalizations.of(context)!.status,
                labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                prefixIcon: Icon(Icons.check_circle_outline),
                contentPadding: EdgeInsets.only(top: 12, bottom: 12),
              ),
            ),
            SizedBox(height: 10),
            CustomButton(
              text: AppLocalizations.of(context)!.submit,
              onPressed: () {
                AssetRegister(
                  context,
                  asset_nameController.text,
                  int.parse(asset_idController.text),
                  descriptionController.text,
                  asset_categoryController.text,
                  selectedStatus,
                );
              },
            ),
            SizedBox(height: 10),
            CustomButton(
              text: AppLocalizations.of(context)!.qr,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScanner()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
