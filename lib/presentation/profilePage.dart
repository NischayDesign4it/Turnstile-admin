import 'package:flutter/material.dart';
import 'package:turnstile_admin/presentation/dashboardPage.dart';
import '../theme/AppBar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.profile,
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard, onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => dashboardPage()));

      },
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: 400,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 4.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(

                    'NAME: ANDREW\n'
                'TAG-ID: 104\n' 'COMPANY-NAME: DESIGN4it\n' 'JOB-ROLE: ROLE1\n'  'COMPANY-ID: 214\n' 'JOB-LOCATION: USA\n' ,

                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
        ),
      ),
    );
  }
}
