import 'package:flutter/material.dart';
import 'package:turnstile_admin/theme/AppBar.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dashboardPage.dart';

class AnalyticPage extends StatefulWidget {
  const AnalyticPage({super.key});

  @override
  State<AnalyticPage> createState() => _AnalyticPageState();
}

class _AnalyticPageState extends State<AnalyticPage> {
  late Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    // Initialize dataMap here in the build method
    dataMap = {
      AppLocalizations.of(context)!.active : 5,
      AppLocalizations.of(context)!.activenot : 3,
      AppLocalizations.of(context)!.pending : 2,
    };

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.analytics,
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => dashboardPage(),
            ),
          );
        },
      ),
      body: Container(
        height: 400,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 3,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 32,
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
            decimalPlaces: 1,
          ),
        ),
      ),
    );
  }
}
