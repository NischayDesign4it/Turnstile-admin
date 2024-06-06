import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme/AppBar.dart';
import 'dashboardPage.dart';

class onSitePage extends StatefulWidget {
  const onSitePage({Key? key}) : super(key: key);

  @override
  State<onSitePage> createState() => _onSitePageState();
}

class _onSitePageState extends State<onSitePage> {
  late List<Map<String, dynamic>> _data = []; // List to hold fetched data
  late List<Map<String, dynamic>> _filteredData = []; // List to hold filtered data
  List<DataColumn> _columns = []; // List to hold dynamically generated columns

  bool _isLoading = false;
  DateTime? _selectedDate; // Selected date for filtering
  String _filterName = ''; // Entered name for filtering

  // Function to fetch data from API
  Future<void> fetchData({DateTime? date}) async {
    setState(() {
      _isLoading = true;
    });

    String url = 'http://44.214.230.69:8000/get_onsite_api/';
    if (date != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      url += '?date=$formattedDate';
    }

    final response = await http.get(Uri.parse(url));

    print(response.body); // Print response in terminal

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      setState(() {
        _data = List<Map<String, dynamic>>.from(json.decode(response.body));
        _filteredData = _data; // Initialize filtered data with all data
        if (_data.isNotEmpty) {
          // Generate columns dynamically based on the keys in the first row of data
          _columns = _data.first.keys.map((String key) {
            return DataColumn(label: Text(key));
          }).toList();
        }
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }

    setState(() {
      _isLoading = false;
    });

    _filterData(); // Apply filters after fetching data
  }

  Future<void> _refreshData() async {
    setState(() {
      _selectedDate = null;
      _filterName = '';
    });
    await fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget initializes
  }

  void _filterData() {
    setState(() {
      _filteredData = _data.where((entry) {
        bool matchesDate = true;
        bool matchesName = true;

        if (_selectedDate != null) {
          DateTime entryDate = DateTime.parse(entry['timestamp']);
          matchesDate = entryDate.year == _selectedDate!.year &&
              entryDate.month == _selectedDate!.month &&
              entryDate.day == _selectedDate!.day;
        }

        if (_filterName.isNotEmpty) {
          matchesName = entry['name']
              .toString()
              .toLowerCase()
              .contains(_filterName.toLowerCase());
        }

        return matchesDate && matchesName;
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      await fetchData(date: _selectedDate); // Fetch data with the selected date
    }
  }

  void _onNameChanged(String value) {
    setState(() {
      _filterName = value;
    });
    _filterData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.onsite,
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
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? AppLocalizations.of(context)!.date
                          : DateFormat.yMMMd().format(_selectedDate!),
                      style: TextStyle(fontSize: 16.0),
                    ),
                    IconButton(
                      onPressed: () => _selectDate(context),
                      icon: Icon(Icons.calendar_today_outlined),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.filterName,
                  ),
                  onChanged: _onNameChanged,
                ),
              ),
              SizedBox(height: 20.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text(AppLocalizations.of(context)!.name)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.tagid)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.status)),
                    DataColumn(label: Text(AppLocalizations.of(context)!.time)),
                  ],
                  rows: _filteredData.asMap().entries.map((entry) {
                    int serialNumber = entry.key + 1;
                    Map<String, dynamic> data = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(data['name'].toString())),
                      DataCell(Text(data['tag_id'].toString())),
                      DataCell(Text(data['status'].toString())),
                      DataCell(Text(data['timestamp'].toString())),
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
