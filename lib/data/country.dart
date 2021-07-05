import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ctracker/data/world.dart';

class Country extends World {
  final String name;
  final String flag;
  final String iso;
  final int totalConfirmed;
  final int newConfirmed;
  final int totalRecovered;
  final int newRecovered;
  final int totalDeath;
  final int newDeath;
  final int activeCase;
  final List lastWeekData;

  Country({
    required this.name,
    this.flag = '',
    this.iso = '',
    required this.totalConfirmed,
    this.newConfirmed = 0,
    required this.totalRecovered,
    this.newRecovered = 0,
    required this.totalDeath,
    this.newDeath = 0,
    this.activeCase = 0,
    this.lastWeekData = const [],
  }) : super(
          totalConfirmed: totalConfirmed,
          totalRecovered: totalRecovered,
          totalDeath: totalDeath,
          lastWeekData: lastWeekData,
        );

  factory Country.getCountryCardData(Map<String, dynamic> json) {
    String flagLink;
    String iso2;
    if (json['countryInfo']['iso2'] == null) {
      flagLink = json['countryInfo']['flag'];
      iso2 = 'unk';
    } else {
      flagLink =
          'https://www.countryflags.io/${json['countryInfo']['iso2']}/flat/64.png';
      iso2 = json['countryInfo']['iso2'];
    }
    return Country(
      name: json['country'],
      flag: flagLink,
      iso: iso2.toString(),
      totalConfirmed: json['cases'],
      totalRecovered: json['recovered'],
      totalDeath: json['deaths'],
      newConfirmed: json['todayCases'],
      newRecovered: json['todayRecovered'],
      newDeath: json['todayDeaths'],
    );
  }

  factory Country.getCountryDetailData(Map json) {
    List<Map> data = [];
    int i = 0, j = 0;
    json['timeline']['cases'].forEach((key, value) {
      data.add({
        'date': key,
        'confirmed': value,
        'recovered': 0,
        'death': 0,
      });
    });

    json['timeline']['recovered'].forEach((key, value) {
      data[i]['recovered'] = value;
      i++;
    });

    json['timeline']['deaths'].forEach((key, value) {
      data[j]['death'] = value;
      j++;
    });

    return Country(
      name: json['country'],
      totalConfirmed: data[data.length - 1]['confirmed'],
      totalRecovered: data[data.length - 1]['recovered'],
      totalDeath: data[data.length - 1]['death'],
      activeCase: data[data.length - 1]['confirmed'] -
          data[data.length - 1]['recovered'] -
          data[data.length - 1]['death'],
      lastWeekData: data,
    );
  }
}

Future<List<Country>> fetchCountryCardData(String value) async {
  final response =
      await http.get(Uri.parse('https://corona.lmao.ninja/v2/countries'));

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    List<Country> countriesData = [];
    data.forEach((country) {
      countriesData.add(Country.getCountryCardData(country));
    });

    if (value == '')
      return countriesData;
    else {
      final filteredcountries = countriesData.where((country) {
        final countryName = country.name.toLowerCase();
        final searchValue = value.toLowerCase();

        return countryName.contains(searchValue);
      }).toList();
      return filteredcountries;
    }
  } else {
    throw 'Failed Load Data';
  }
}

Future<Country> fetchCountryDetailData(String iso) async {
  final response = await http.get(
      Uri.parse('https://corona.lmao.ninja/v2/historical/$iso?lastdays=8'));

  if (response.statusCode == 200) {
    return Country.getCountryDetailData(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    throw "404";
  } else {
    throw 'Failed Load Data';
  }
}
