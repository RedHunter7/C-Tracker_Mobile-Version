import 'package:ctracker/components/card/attribute_card.dart';
import 'package:ctracker/components/line_chart/line_chart_container.dart';
import 'package:ctracker/components/line_chart/line_chart_data.dart';
import 'package:ctracker/components/pie_chart/pie_chart_container.dart';
import 'package:ctracker/components/pie_chart/pie_chart_data.dart';
import 'package:ctracker/data/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class CountryDetailContainer extends StatefulWidget {
  final double screenWidth;
  final Country countryData;

  const CountryDetailContainer({
    Key? key,
    required this.screenWidth,
    required this.countryData,
  }) : super(key: key);

  @override
  _CountryDetailContainerState createState() => _CountryDetailContainerState();
}

class _CountryDetailContainerState extends State<CountryDetailContainer> {
  late Country countryData;
  late int gridRowCount;
  late double maxWidth;
  late double gridSpace;

  @override
  void initState() {
    super.initState();
    countryData = widget.countryData;
  }

  @override
  Widget build(BuildContext context) {
    List<StaggeredTile> gridPattern = [];
    List<Widget> widgetList = [];
    List<Map> confirmedCase = [], recoveredCase = [], deathCase = [];
    int index = 0;
    int yesterdayConfirmed = 0, yesterdayRecovered = 0, yesterdayDeath = 0;
    countryData.lastWeekData.forEach((element) {
      if (index > 0) {
        confirmedCase.add({
          'date': element['date'].substring(2, 4),
          'amount': element['confirmed'] - yesterdayConfirmed,
        });
        recoveredCase.add({
          'date': element['date'].substring(2, 4),
          'amount': element['recovered'] - yesterdayRecovered,
        });
        deathCase.add({
          'date': element['date'].substring(2, 4),
          'amount': element['death'] - yesterdayDeath,
        });
      }
      yesterdayConfirmed = element['confirmed'];
      yesterdayRecovered = element['recovered'];
      yesterdayDeath = element['death'];
      index++;
    });

    final moneyFormat = NumberFormat('#,##0');
    widgetList.addAll([
      PieChartContainer(
        title: 'Covid Country Percentage',
        sectionData: createPieChartSection(
          countryData.totalConfirmed,
          countryData.totalConfirmed -
              countryData.totalRecovered -
              countryData.totalDeath,
          countryData.totalRecovered,
          countryData.totalDeath,
        ),
        indicatorData: {
          'totalCase': countryData.totalConfirmed,
          'recovered': countryData.totalRecovered,
          'death': countryData.totalDeath,
        },
      ),
      LineChartContainer(
        title: 'Daily Confirmed Case',
        data: mainData(confirmedCase, [
          const Color(0xFFFFD717),
          const Color(0xFFFDA33A),
        ]),
      ),
      LineChartContainer(
        title: 'Daily Recovered Case',
        data: mainData(recoveredCase, [
          const Color(0xff23b6e6),
          const Color(0xff02d39a),
        ]),
      ),
      LineChartContainer(
        title: 'Daily Death Case',
        data: mainData(deathCase, [
          const Color(0xFFFF96A6),
          const Color(0xFFD7A8AF),
        ]),
      ),
      AttributeCard(
        title: 'Total Case',
        imageIcon: 'icons/mdi_virus-outline.svg',
        iconColor: Color(0xFFD59EF5),
        data: moneyFormat.format(countryData.totalConfirmed),
      ),
      AttributeCard(
        title: 'Active Case',
        imageIcon: 'icons/mdi_emoticon-sick-outline.svg',
        iconColor: Color(0xFFFEFF89),
        data: moneyFormat.format(countryData.totalConfirmed -
            countryData.totalRecovered -
            countryData.totalDeath),
      ),
      AttributeCard(
        title: 'Recovered',
        imageIcon: 'icons/mdi_pill.svg',
        iconColor: Color(0xFF81F1DC),
        data: moneyFormat.format(countryData.totalRecovered),
      ),
      AttributeCard(
        title: 'Recovered Rate',
        imageIcon: 'icons/mdi_percent.svg',
        iconColor: Color(0xFF81F1DC),
        data: (countryData.totalRecovered / countryData.totalConfirmed * 100)
                .toStringAsFixed(2) +
            '%',
      ),
      AttributeCard(
        title: 'Death',
        imageIcon: 'icons/mdi_skull-scan-outline.svg',
        iconColor: Color(0xFFFF96A6),
        data: moneyFormat.format(countryData.totalDeath),
      ),
      AttributeCard(
        title: 'Death Rate',
        imageIcon: 'icons/mdi_percent.svg',
        iconColor: Color(0xFFFF96A6),
        data: (countryData.totalDeath / countryData.totalRecovered * 100)
                .toStringAsFixed(2) +
            '%',
      ),
    ]);
    print(widget.screenWidth);
    if (widget.screenWidth >= 1280) {
      gridSpace = 30;
      maxWidth = 1280;
      gridRowCount = 6;
      gridPattern.addAll([
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(1, 0.75),
        StaggeredTile.count(1, 0.75),
        StaggeredTile.count(1, 0.75),
        StaggeredTile.count(1, 0.75),
        StaggeredTile.count(1, 0.75),
        StaggeredTile.count(1, 0.75),
      ]);
    } else if (widget.screenWidth >= 768) {
      gridSpace = 20;
      maxWidth = 1024;
      gridRowCount = 4;
      gridPattern.addAll([
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
      ]);
    } else {
      gridSpace = 10;
      maxWidth = double.infinity;
      gridRowCount = 2;
      gridPattern.addAll([
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(2, 1.5),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
      ]);

      Widget temp = widgetList[2];
      widgetList[2] = widgetList[6];
      widgetList[6] = temp;

      temp = widgetList[4];
      widgetList[4] = widgetList[6];
      widgetList[6] = temp;

      temp = widgetList[3];
      widgetList[3] = widgetList[7];
      widgetList[7] = temp;

      temp = widgetList[2];
      widgetList[2] = widgetList[6];
      widgetList[6] = temp;

      temp = widgetList[3];
      widgetList[3] = widgetList[5];
      widgetList[5] = temp;

      temp = widgetList[5];
      widgetList[5] = widgetList[6];
      widgetList[6] = temp;
    }
    return Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.all(15),
          child: StaggeredGridView.count(
            physics: AlwaysScrollableScrollPhysics(),
            crossAxisCount: gridRowCount,
            crossAxisSpacing: gridSpace,
            mainAxisSpacing: gridSpace,
            staggeredTiles: gridPattern,
            children: widgetList,
          ));
  }
}
