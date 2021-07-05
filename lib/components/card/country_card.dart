import 'package:ctracker/page/detail_country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ctracker/utility/color.dart';
import 'package:intl/intl.dart';

final moneyFormat = NumberFormat('#,##0');

class CountryCard extends StatelessWidget {
  final String name;
  final String flag;
  final String iso;
  final int totalConfirmed;
  final int newConfirmed;
  final int totalRecovered;
  final int newRecovered;
  final int totalDeath;
  final int newDeath;

  const CountryCard({
    Key? key,
    required this.name,
    required this.flag,
    required this.iso,
    required this.totalConfirmed,
    required this.newConfirmed,
    required this.totalRecovered,
    required this.newRecovered,
    required this.totalDeath,
    required this.newDeath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Card(
          elevation: 0,
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Container(
                height: 65,
                child: ListTile(
                  onTap: () {
                    if (iso == 'unk')
                      return;
                    else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailCountryPage(
                          name: name,
                          iso: iso,
                        );
                      }));
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  tileColor: tertiaryColor,
                  leading: Image.network(
                    flag,
                    errorBuilder: (context, object, stackTrace) {
                      return Icon(
                        Icons.flag_outlined,
                        color: neutralColor,
                      );
                    },
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                      color: neutralColor,
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: neutralColor,
                    size: 50,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    color: secondaryColor),
                padding: const EdgeInsets.only(top: 5, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Total Case',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            color: neutralColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 2,
                            bottom: 2,
                            left: 10,
                            right: 10,
                          ),
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: dataCaseColor[0],
                          ),
                          child: Text(
                            moneyFormat.format(this.totalConfirmed).toString(),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          '+' +
                              moneyFormat.format(this.newConfirmed).toString(),
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            color: dataCaseColor[0],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Total Recovered',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            color: neutralColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 2,
                            bottom: 2,
                            left: 10,
                            right: 10,
                          ),
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: dataCaseColor[2],
                          ),
                          child: Text(
                            moneyFormat.format(this.totalRecovered).toString(),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          '+' +
                              moneyFormat.format(this.newConfirmed).toString(),
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            color: dataCaseColor[2],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Total Death',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            color: neutralColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 2,
                            bottom: 2,
                            left: 10,
                            right: 10,
                          ),
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: dataCaseColor[3],
                          ),
                          child: Text(
                            moneyFormat.format(this.totalDeath).toString(),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          '+' + moneyFormat.format(this.newDeath).toString(),
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            color: dataCaseColor[3],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
