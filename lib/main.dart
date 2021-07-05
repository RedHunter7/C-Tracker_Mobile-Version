import 'package:ctracker/components/container/country_list_container.dart';
import 'package:ctracker/components/container/world_container.dart';
import 'package:ctracker/data/country.dart';
import 'package:ctracker/data/world.dart';
import 'package:flutter/material.dart';
import 'package:ctracker/utility/color.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

final moneyFormat = NumberFormat('#,##0');

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C-Tracker',
      theme: ThemeData(
        primarySwatch: primaryColor,
        indicatorColor: Colors.white,
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: neutralColor,
            width: 2,
          ),
        )),
      ),
      home: MyHomePage(title: 'World Covid-19'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<World> worldData;
  late Future<List<Country>> countryCardData;

  _refreshWorldTab() {
    setState(() {
      worldData = fetchWorldData();
    });
  }

  @override
  void initState() {
    super.initState();
    worldData = fetchWorldData();
    countryCardData = fetchCountryCardData('');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarDividerColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.light),
          backgroundColor: primaryColor,
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            'World Covid-19',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'World'),
              Tab(text: 'Country'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            FutureBuilder<World>(
              future: worldData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                } else if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return RefreshIndicator(
                      child: WorldContainer(
                          screenWidth: MediaQuery.of(context).size.width,
                          worldData: snapshot.data!),
                      onRefresh: () {
                        return _refreshWorldTab();
                      });
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Can't load data",
                          style: TextStyle(
                            fontSize: 16,
                            color: neutralColor,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            _refreshWorldTab();
                          },
                          child: Text(
                            'Refresh',
                            style: TextStyle(color: neutralColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              },
            ),
            CountryListContainer(
              screenWidth: MediaQuery.of(context).size.width,
              countryCardData: countryCardData,
            ),
          ],
        ),
      ),
    );
  }
}
