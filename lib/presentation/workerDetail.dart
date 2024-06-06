import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/AppBar.dart';
import '../theme/CustomButton.dart';
import 'dashboardPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class WorkerDetail extends StatefulWidget {
  WorkerDetail({Key? key}) : super(key: key);

  @override
  State<WorkerDetail> createState() => _WorkerDetailState();
}

class _WorkerDetailState extends State<WorkerDetail> {
  TextEditingController nameController = TextEditingController();
  TextEditingController companynameController = TextEditingController();
  TextEditingController companyIdController = TextEditingController();
  TextEditingController tagIdController = TextEditingController();
  TextEditingController jobLocationController = TextEditingController();
  File? _selectedFile;
  String selectedJobRole = 'role1';
  String selectedStatus = 'active';

  List<String> statusOptions = ['active', 'inactive'];
  List<String> jobRoleOptions = ['role1', 'role2', 'role3', 'role4'];



  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> workerRegister(
      BuildContext context,
      String name,
      String companyName,
      String jobRole,
      int companyId,
      int tagId,
      String jobLocation,
      String status,
      File? file,
      ) async {
    var url = Uri.parse('http://44.214.230.69:8000/users/');

    try {
      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath(
          'orientation',
          _selectedFile!.path,
        ));

      request.fields.addAll({
        'name': name,
        'company_name': companyName,
        'job_role': jobRole,
        'mycompany_id': companyId.toString(),
        'tag_id': tagId.toString(),
        'job_location': jobLocation,
        'status': status,
      });



      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.success),
              content: Text(AppLocalizations.of(context)!.workerDetailCreate),
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


  Future<void> updateWorkerDetails() async {
    var url = Uri.parse('http://44.214.230.69:8000/users/${tagIdController.text}/');
    var headers = {'Content-Type': 'application/json'};

    print(tagIdController.text);

    try {
      var request = http.Request('PATCH', url)
        ..headers.addAll(headers)
        ..body = jsonEncode({
          'name': nameController.text,
          'company_name': companynameController.text,
          'job_role': jobRoleOptions,
          'mycompany_id': int.tryParse(companyIdController.text) ?? 0,
          'tag_id': int.tryParse(tagIdController.text) ?? 0,
          'job_location': jobLocationController.text,
          'status': statusOptions,
        });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.success),
              content: Text('Worker details updated successfully!'),
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
        print('Update failed. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update worker details. Please try again.'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Error during update: $e');
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


  Future<void> deleteWorkerDetails() async {
    var url = Uri.parse('http://44.214.230.69:8000/users/${tagIdController.text}/');
    var headers = {'Content-Type': 'application/json'};

    try {
      var request = http.Request('DELETE', url)
        ..headers.addAll(headers);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 204) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.success),
              content: Text(AppLocalizations.of(context)!.workerDetailDelete),
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

        print('Worker details deleted successfully!');
      } else {
        print('Delete failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during delete: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.workerdetail,
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard, onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => dashboardPage()));

      },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: AppLocalizations.of(context)!.name,
                  labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: Icon(Icons.mic),

                  contentPadding: EdgeInsets.only(top: 12, bottom: 12),

                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: companynameController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: AppLocalizations.of(context)!.companyname,
                  labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: Icon(Icons.mic),

                  contentPadding: EdgeInsets.only(top: 12, bottom: 12),

                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: selectedJobRole,
                items: jobRoleOptions.map((String job_role) {
                  return DropdownMenuItem(
                    value: job_role,
                    child: Text(job_role),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedJobRole = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: AppLocalizations.of(context)!.jobrole,
                  labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                  prefixIcon: Icon(Icons.check_circle_outline),
                  contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: companyIdController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: AppLocalizations.of(context)!.companyid,
                  labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                  prefixIcon: Icon(Icons.numbers),
                  suffixIcon: Icon(Icons.mic),

                  contentPadding: EdgeInsets.only(top: 12, bottom: 12),

                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: tagIdController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: AppLocalizations.of(context)!.tagid,
                  labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                  prefixIcon: Icon(Icons.numbers),
                  suffixIcon: Icon(Icons.mic),

                  contentPadding: EdgeInsets.only(top: 12, bottom: 12),

                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: jobLocationController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: AppLocalizations.of(context)!.joblocation,
                  labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                  prefixIcon: Icon(
                    Icons.map
                  ),
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
              _selectedFile != null
                  ? Text(_selectedFile!.path)
                  : Text(AppLocalizations.of(context)!.selectionno),
              CustomButton(
                onPressed: _selectFile,
                text: AppLocalizations.of(context)!.selection,

              ),


              SizedBox(height: 10),
              CustomButton(
                text: AppLocalizations.of(context)!.submit,
                onPressed: () {
                  workerRegister(
                    context,
                    nameController.text,
                    companynameController.text,
                    selectedJobRole,
                    int.tryParse(companyIdController.text) ?? 0,
                    int.tryParse(tagIdController.text) ?? 0,
                    jobLocationController.text,
                    selectedStatus,
                    _selectedFile,
                  );
                },
              ),
              SizedBox(height: 10),
              CustomButton(text:AppLocalizations.of(context)!.delete, onPressed: deleteWorkerDetails),

              SizedBox(height: 10),
              CustomButton(text: AppLocalizations.of(context)!.update, onPressed: updateWorkerDetails
              )
            ],
          ),
        ),
      ),
    );
  }
}
