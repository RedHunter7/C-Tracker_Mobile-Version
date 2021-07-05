import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class World {
  final int totalConfirmed;
  final int totalRecovered;
  final int totalDeath;
  final List lastWeekData;

  World({
    required this.totalConfirmed,
    required this.totalRecovered,
    required this.totalDeath,
    this.lastWeekData = const [],
  });

  factory World.getWorldData(Map json) {
    List<Map> data = [];
    int i = 0, j = 0;
    json['cases'].forEach((key, value) {
      data.add({
        'date': key,
        'confirmed': value,
        'recovered': 0,
        'death': 0,
      });
    });

    json['recovered'].forEach((key, value) {
      data[i]['recovered'] = value;
      i++;
    });

    json['deaths'].forEach((key, value) {
      data[j]['death'] = value;
      j++;
    });

    data = data.reversed.toList();
    data = data.sublist(0,8);
    data = data.reversed.toList();

    return World(
      totalConfirmed: data[data.length-1]['confirmed'], 
      totalRecovered: data[data.length-1]['recovered'], 
      totalDeath: data[data.length-1]['death'],
      lastWeekData: data,
    );
  }
}

Future<World> fetchWorldData() async {
  final response =
      await http.get(Uri.parse('https://corona.lmao.ninja/v2/historical/all'));

  if (response.statusCode == 200) {
    return World.getWorldData(jsonDecode(response.body));
  } else {
    throw 'Failed Load Data';
  }
}
