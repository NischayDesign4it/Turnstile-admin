import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart'; // Add this import for file picking

import '../theme/AppBar.dart';
import 'dashboardPage.dart';

class ToolBoxScreen extends StatefulWidget {
  const ToolBoxScreen({super.key});

  @override
  State<ToolBoxScreen> createState() => _ToolBoxScreenState();
}

class _ToolBoxScreenState extends State<ToolBoxScreen> {
  late List<dynamic> ToolDocLinks;
  late DateTime selectedDate; // Define selectedDate variable
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    ToolDocLinks = [];
    selectedDate = DateTime.now(); // Initialize selectedDate with current date
    _callToolBoxAPI(DateTime.now()); // Call API with today's date initially
  }

  Future<void> _callToolBoxAPI(DateTime date) async {
    setState(() {
      isLoading = true; // Set loading to true when starting to fetch data
    });

    final uri = Uri.parse('http://54.163.33.217:8000/toolbox_api/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      // Filter documents by date
      final filteredDocs = responseData.where((doc) {
        // Replace 'date' with the key corresponding to the date field in your JSON data
        // Here I'm assuming 'date' is the key, you might need to replace it accordingly
        return DateTime.parse(doc['date']).isAtSameMomentAs(date);
      }).toList();

      setState(() {
        ToolDocLinks = filteredDocs;
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
        _callToolBoxAPI(selectedDate); // Call API again with selected date
      });
    }
  }

  Future<void> _uploadDocument() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = result.files.single;
      final uri = Uri.parse('http://54.163.33.217:8000/toolbox_api/');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', file.path!));

      final response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully');
        // Optionally, you can refresh the document list after uploading
        _callToolBoxAPI(selectedDate);
      } else {
        print('Failed to upload file');
      }
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => dashboardPage()));
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
                  onPressed: _uploadDocument, // Call _uploadDocument method
                  icon: Icon(Icons.upload),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator()) // Show loading indicator
                  : ListView.builder(
                itemCount: ToolDocLinks.length,
                itemBuilder: (context, index) {
                  final docLink = ToolDocLinks[index]['document'];
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
