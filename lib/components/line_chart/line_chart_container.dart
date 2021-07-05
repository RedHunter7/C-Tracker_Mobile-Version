import 'package:ctracker/utility/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

class LineChartContainer extends StatelessWidget {
  final String title;
  final LineChartData data;

  const LineChartContainer({
    Key? key,
    this.title = '',
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
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
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
          Flexible(
              flex: 3,
              child: LineChart(
                data,
              )),
        ],
      ),
    );
  }
}
