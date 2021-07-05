import 'package:ctracker/components/card/attribute_card.dart';
import 'package:ctracker/components/line_chart/line_chart_container.dart';
import 'package:ctracker/components/line_chart/line_chart_data.dart';
import 'package:ctracker/components/pie_chart/pie_chart_container.dart';
import 'package:ctracker/components/pie_chart/pie_chart_data.dart';
import 'package:ctracker/data/world.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class WorldContainer extends StatefulWidget {
  final double screenWidth;
  final World worldData;

  const WorldContainer({
    Key? key,
    required this.screenWidth,
    required this.worldData,
  }) : super(key: key);

  @override
  _WorldContainerState createState() => _WorldContainerState();
}

class _WorldContainerState extends State<WorldContainer> with AutomaticKeepAliveClientMixin{
  late World worldData;
  late int gridRowCount;
  late double maxWidth;
  late double gridSpace;

  @override
  void initState() {
    super.initState();
    worldData = widget.worldData;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    List<StaggeredTile> gridPattern = [];
    List<Widget> widgetList = [];
    List<Map> confirmedCase = [], recoveredCase = [], deathCase = [];
    int index = 0;
    int yesterdayConfirmed = 0, yesterdayRecovered = 0, yesterdayDeath = 0;
    worldData.lastWeekData.forEach((element) {
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
        title: 'Covid World Percentage',
        sectionData: createPieChartSection(
          worldData.totalConfirmed,
          worldData.totalConfirmed -
              worldData.totalRecovered -
              worldData.totalDeath,
          worldData.totalRecovered,
          worldData.totalDeath,
        ),
        indicatorData: {
          'totalCase': worldData.totalConfirmed,
          'recovered': worldData.totalRecovered,
          'death': worldData.totalDeath,
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
        data: moneyFormat.format(worldData.totalConfirmed),
      ),
      AttributeCard(
        title: 'Active Case',
        imageIcon: 'icons/mdi_emoticon-sick-outline.svg',
        iconColor: Color(0xFFFEFF89),
        data: moneyFormat.format(worldData.totalConfirmed -
            worldData.totalRecovered -
            worldData.totalDeath),
      ),
      AttributeCard(
        title: 'Recovered',
        imageIcon: 'icons/mdi_pill.svg',
        iconColor: Color(0xFF81F1DC),
        data: moneyFormat.format(worldData.totalRecovered),
      ),
      AttributeCard(
        title: 'Recovered Rate',
        imageIcon: 'icons/mdi_percent.svg',
        iconColor: Color(0xFF81F1DC),
        data: (worldData.totalRecovered / worldData.totalConfirmed * 100)
                .toStringAsFixed(2) +
            '%',
      ),
      AttributeCard(
        title: 'Death',
        imageIcon: 'icons/mdi_skull-scan-outline.svg',
        iconColor: Color(0xFFFF96A6),
        data: moneyFormat.format(worldData.totalDeath),
      ),
      AttributeCard(
        title: 'Death Rate',
        imageIcon: 'icons/mdi_percent.svg',
        iconColor: Color(0xFFFF96A6),
        data: (worldData.totalDeath / worldData.totalRecovered * 100)
                .toStringAsFixed(2) +
            '%',
      ),
    ]);
  
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

    super.build(context);
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
