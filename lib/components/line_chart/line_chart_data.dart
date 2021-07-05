import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

LineChartData mainData(List<Map> data, List<Color> gradientColors) {
  List<FlSpot> spotData = [];
  int maxValue = 0, index = 0;

  data.forEach((element) {
    if (element['amount'] > maxValue) {
      maxValue = element['amount'];
    }
  });

  if (maxValue > 10) {
    String x = maxValue.toString().substring(0, 1);
    String y = maxValue.toString().substring(1, 2);
    if (int.parse(y) > 5) {
      y = '0';
      x = (int.parse(x) + 1).toString();
    } else
      y = '5';
    num w = pow(10, (maxValue.toString().length - 2));
    maxValue = int.parse(x + y) * w.toInt();
  } else if(maxValue < 10) {
    maxValue = 9;
  }

  data.forEach((element) {
    spotData.add(FlSpot(
      index.toDouble(),
      (element['amount'].toDouble() / maxValue) * 6,
    ));
    index += 2;
  });

  return LineChartData(
    lineTouchData: LineTouchData(enabled: false),
    gridData: FlGridData(
      show: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white24,
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 18,
        getTextStyles: (value) => const TextStyle(
            color: Color(0xFFFFFFFF), fontFamily: 'OpenSans', fontSize: 12),
        getTitles: (value) {
          switch (value.toInt()) {
            case 0:
              return data[0]['date'];
            case 2:
              return data[1]['date'];
            case 4:
              return data[2]['date'];
            case 6:
              return data[3]['date'];
            case 8:
              return data[4]['date'];
            case 10:
              return data[5]['date'];
            case 12:
              return data[6]['date'];
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xFFFFFFFF),
          fontFamily: 'OpenSans',
          fontSize: 12,
        ),
        getTitles: (value) {
          List sideTitles = [
            (maxValue / 6).round().toString(),
            (maxValue / 2).round().toString(),
            (maxValue * 5 / 6).round().toString(),
          ];

          switch (value.toInt()) {
            case 1:
              return NumberFormat.compact().format(int.parse(sideTitles[0]));
            case 3:
              return NumberFormat.compact().format(int.parse(sideTitles[1]));
            case 5:
              return NumberFormat.compact().format(int.parse(sideTitles[2]));
          }
          return '';
        },
        reservedSize: 28,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: const Border(
        bottom: BorderSide(
          color: Colors.white54,
          width: 2,
        ),
        left: BorderSide(
          color: Colors.white54,
          width: 2,
        ),
        right: BorderSide(
          color: Colors.transparent,
        ),
        top: BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
    minX: 0,
    maxX: (data.length * 2).toDouble() - 2,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: spotData,
        isCurved: true,
        colors: gradientColors,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  );
}
