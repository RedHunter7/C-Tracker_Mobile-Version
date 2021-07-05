import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';

List<PieChartSectionData> createPieChartSection(int totalCase,int activeCase, int recovered, int death) {
  double activeCasePercent = (activeCase / totalCase) * 100;
  double recoveredPercent = (recovered / totalCase) * 100;
  double deathPercent = (death / totalCase) * 100;

  return [
    PieChartSectionData(
      showTitle: false,
      color: const Color(0xFFFFD717),
      value: activeCase.toDouble(),
      title: '${activeCasePercent.toStringAsFixed(2)}%',
      radius: 50,
      titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff)),
    ),
    PieChartSectionData(
      showTitle: false,
      color: const Color(0xFF22B2DA),
      value: recovered.toDouble(),
      title: '${recoveredPercent.toStringAsFixed(2)}%',
      radius: 50,
      titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff)),
    ),
    PieChartSectionData(
      showTitle: false,
      color: const Color(0xFFE14C62),
      value: death.toDouble(),
      title: '${deathPercent.toStringAsFixed(2)}%',
      radius: 50,
      titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff)),
    )
  ];
}
