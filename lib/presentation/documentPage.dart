import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:turnstile_admin/theme/AppBar.dart';
import 'package:turnstile_admin/theme/CustomButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dashboardPage.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedFile;

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Upload Rejected'),
            content: Text('Please upload the file'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
    var url = Uri.parse('http://54.163.33.217:8000/post_orientation_sheet/');

    var request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath(
        'attachments',
        _selectedFile!.path,
      ));

    var response = await request.send();

    if (response.statusCode == 201) {
      // File uploaded successfully
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Upload Successful'),
            content: Text('The document has been uploaded successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Upload Rejected'),
            content: Text('Check the format that you trying to upload'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.documents, backgroundColor: Color(0xff071390),
        icon: Icons.dashboard, onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => dashboardPage()));

        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                    border: Border.all(
                      color: Colors.black, // Adjust the color as needed
                      width: 5, // Adjust the border width as needed
                    )),
                child: _selectedFile != null
                    ? Text(_selectedFile!.path)
                    : Text(AppLocalizations.of(context)!.selectionno),
              ),
              SizedBox(height: 20),

              CustomButton(
                onPressed: _selectFile,
                text: AppLocalizations.of(context)!.selectDoc,

              ),
              SizedBox(height: 20),
              CustomButton(
                onPressed: _uploadFile,
                text: AppLocalizations.of(context)!.upload,

              ),


            ],
          ),
        ),
      ),
    );
  }
}
