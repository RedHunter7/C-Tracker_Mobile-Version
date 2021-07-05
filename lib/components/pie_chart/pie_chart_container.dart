import 'package:ctracker/components/pie_chart/pie_chart_indicator.dart';
import 'package:ctracker/utility/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

class PieChartContainer extends StatelessWidget {
  final String title;
  final List<PieChartSectionData> sectionData;
  final Map indicatorData;

  const PieChartContainer({
    Key? key,
    this.title = '',
    required this.sectionData,
    required this.indicatorData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double activeCasePercent = 
    ( (indicatorData['totalCase'] - indicatorData['recovered'] - indicatorData['death']) 
    / indicatorData['totalCase']) * 100;
    double recoveredPercent = (indicatorData['recovered'] / indicatorData['totalCase']) * 100;
    double deathPercent = (indicatorData['death'] / indicatorData['totalCase']) * 100;
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
        left: 30,
        right: 30,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: secondaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              'Covid World Percentage',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      sections: sectionData,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Indicator(
                        color: Color(0xFFFFD717),
                        text: 'Active Case ${activeCasePercent.toStringAsFixed(2)}%',
                        textColor: Color(0xFFFFFFFF),
                        isSquare: true,
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Indicator(
                        color: Color(0xFF22B2DA),
                        text: 'Recovered ${recoveredPercent.toStringAsFixed(2)}%',
                        textColor: Color(0xFFFFFFFF),
                        isSquare: true,
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Indicator(
                        color: Color(0xFFE14C62),
                        text: 'Death ${deathPercent.toStringAsFixed(2)}%',
                        textColor: Color(0xFFFFFFFF),
                        isSquare: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
