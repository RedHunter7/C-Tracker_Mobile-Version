import 'package:ctracker/components/container/country_container.dart';
import 'package:ctracker/data/country.dart';
import 'package:ctracker/utility/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final moneyFormat = NumberFormat('#,##0');

class DetailCountryPage extends StatelessWidget {
  final String name;
  final String iso;

  DetailCountryPage({Key? key, required this.name, required this.iso});

  @override
  Widget build(BuildContext context) {
    String flagLink;
    if (iso == 'unk')
      flagLink = 'https://disease.sh/assets/img/flags/unknown.png';
    else
      flagLink = 'https://www.countryflags.io/$iso/flat/32.png';
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarDividerColor: primaryColor,
            systemNavigationBarColor: primaryColor,
            systemNavigationBarIconBrightness: Brightness.light),
        centerTitle: true,
        elevation: 0.0,
        title: Row(
          children: [
            Image.network(
              flagLink,
              errorBuilder: (context, object, stackTrace) {
                return Icon(
                  Icons.flag_outlined,
                  color: neutralColor,
                );
              },
            ),
            SizedBox(width: 20),
            Text(name),
          ],
        ),
      ),
      body: DetailCountryBody(iso: iso),
    );
  }
}

class DetailCountryBody extends StatefulWidget {
  final String iso;
  DetailCountryBody({Key? key, required this.iso});
  @override
  _DetailCountryBodyState createState() => _DetailCountryBodyState();
}

class _DetailCountryBodyState extends State<DetailCountryBody> {
  late Future<Country> _countryDetailData;

  _refreshPage() {
    setState(() {
      _countryDetailData = fetchCountryDetailData(widget.iso);
    });
  }

  @override
  void initState() {
    super.initState();
    _countryDetailData = fetchCountryDetailData(widget.iso);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Country>(
      future: _countryDetailData,
      builder: (context, snapshot) {
        //developer.log(snapshot.data!.allData.toString());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return RefreshIndicator(
              child: CountryDetailContainer(
                screenWidth: MediaQuery.of(context).size.width,
                countryData: snapshot.data!,
              ),
              onRefresh: () {
                return _refreshPage();
              }
          );
        } else if (snapshot.hasError) {
          if (snapshot.error == '404') {
            return Center(
              child: Text(
                "Country doesn't have any historical data",
                style: TextStyle(
                  fontSize: 16,
                  color: neutralColor,
                ),
              ),
            );
          } else {
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
                      _refreshPage();
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
        }
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }
}
