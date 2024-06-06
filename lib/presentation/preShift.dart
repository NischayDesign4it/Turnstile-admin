import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme/AppBar.dart';
import 'dashboardPage.dart';

class PreShiftScreen extends StatefulWidget {
  const PreShiftScreen({Key? key}) : super(key: key);

  @override
  State<PreShiftScreen> createState() => _PreShiftScreenState();
}

class _PreShiftScreenState extends State<PreShiftScreen> {
  late List<dynamic> preshiftDocLinks;
  late DateTime selectedDate; // Define selectedDate variable
  bool isLoading = true; // Loading state
  File? _selectedFile; // Selected file for upload

  @override
  void initState() {
    super.initState();
    preshiftDocLinks = [];
    selectedDate = DateTime.now(); // Initialize selectedDate with current date
    _callPreShiftAPI(DateTime.now()); // Call API with today's date initially
  }

  Future<void> _callPreShiftAPI(DateTime date) async {
    setState(() {
      isLoading = true; // Set loading to true when starting to fetch data
    });

    final uri = Uri.parse('http://44.214.230.69:8000/preshift_api/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      // Filter documents by date
      final filteredDocs = responseData.where((doc) {
        return DateTime.parse(doc['date']).isAtSameMomentAs(date);
      }).toList();

      setState(() {
        preshiftDocLinks = filteredDocs;
        isLoading = false; // Set loading to false after data is fetched
      });
    } else {
      // Handle error
      print('Failed to load data from API');
      setState(() {
        isLoading = false; // Set loading to false if there's an error
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
        _callPreShiftAPI(selectedDate); // Call API again with selected date
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

    var url = Uri.parse('http://44.214.230.69:8000/preshift_api/');
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
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      // Refresh the document list after uploading
      _callPreShiftAPI(selectedDate);
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
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.pre,
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => dashboardPage()));
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.pre,
                  style: TextStyle(fontSize: 20),
                ),
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
                  borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.black, // Adjust the color as needed
                    width: 1, // Adjust the border width as needed
                  )),
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
                  ? Center(child: CircularProgressIndicator()) // Show loading indicator
                  : ListView.builder(
                itemCount: preshiftDocLinks.length,
                itemBuilder: (context, index) {
                  final docLink = preshiftDocLinks[index]['document'];
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
