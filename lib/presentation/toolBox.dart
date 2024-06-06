import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme/AppBar.dart';
import 'dashboardPage.dart';

class ToolBoxScreen extends StatefulWidget {
  const ToolBoxScreen({super.key});

  @override
  State<ToolBoxScreen> createState() => _ToolBoxScreenState();
}

class _ToolBoxScreenState extends State<ToolBoxScreen> {
  late List<dynamic> toolDocLinks;
  late DateTime selectedDate;
  bool isLoading = true;
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    toolDocLinks = [];
    selectedDate = DateTime.now();
    _callToolBoxAPI(DateTime.now());
  }

  Future<void> _callToolBoxAPI(DateTime date) async {
    setState(() {
      isLoading = true;
    });

    final uri = Uri.parse('http://44.214.230.69:8000/toolbox_api/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      final filteredDocs = responseData.where((doc) {
        return DateTime.parse(doc['date']).isAtSameMomentAs(date);
      }).toList();

      setState(() {
        toolDocLinks = filteredDocs;
        isLoading = false;
      });
    } else {
      print('Failed to load data from API');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _callToolBoxAPI(selectedDate);
      });
    }
  }

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
            content: Text('Please select a file to upload.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    var url = Uri.parse('http://54.163.33.217:8000/toolbox_api/');
    var request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath(
        'document',
        _selectedFile!.path,
      ));

    var response = await request.send();

    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Upload Successful'),
            content: Text('The document has been uploaded successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      _callToolBoxAPI(selectedDate);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Upload Rejected'),
            content: Text('Failed to upload file. Please check the format and try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.tool,
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => dashboardPage()));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Text(AppLocalizations.of(context)!.tool, style: TextStyle(fontSize: 20)),
                Spacer(),
                IconButton(
                  onPressed: () => _selectDate(context),
                  icon: Icon(Icons.calendar_today),
                ),
                IconButton(
                  onPressed: _selectFile,
                  icon: Icon(Icons.upload),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Center(
                child: _selectedFile != null
                    ? Text(_selectedFile!.path)
                    : Text(AppLocalizations.of(context)!.selectionno),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text(AppLocalizations.of(context)!.upload),
            ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: toolDocLinks.length,
                itemBuilder: (context, index) {
                  final docLink = toolDocLinks[index]['document'];
                  return Image.network(
                    docLink,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text('Error loading image'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
