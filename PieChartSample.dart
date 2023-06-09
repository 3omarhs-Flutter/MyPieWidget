// todo install fl_chart package or add this line to pubspec.yaml:  fl_chart: ^0.62.0 

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample extends StatefulWidget {
  const PieChartSample({
    Key? key,
    required this.size,
    this.weight=30,
    this.spaceBetweenSections,
    this.width,
    this.height,
    this.backgroundColor,
    this.UseCard=false,
    this.showGraphMap=false,
    this.middleWidgets,
    this.obj
  }) : super(key: key);

  final double size;
  final double weight;
  final double? spaceBetweenSections;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final bool UseCard;
  final bool showGraphMap;
  final List<ChartObject>? obj;
  final List<Widget>? middleWidgets;

  @override
  _PieChartSampleState createState() => _PieChartSampleState();
}

class _PieChartSampleState extends State<PieChartSample> {
  int touchedIndex = -1;
  bool pressedIndex = false;

  Widget MyWidget({Color? color, required Widget child}){
    if(widget.UseCard){
      return Card(color: color, child: Container(width: widget.width?? ((widget.size + widget.weight) * 2), height: widget.height?? ((widget.size + widget.weight) * 2) ,child: child),);
    }
    else{
      return Container(width: widget.width?? ((widget.size + widget.weight) * 2), height: widget.height?? ((widget.size + widget.weight) * 2), decoration: BoxDecoration(color: color, shape: BoxShape.circle), child: child,);
    }
  }

  Widget MyChart(){
    return Stack(
      children: [
        Positioned(
          width: (widget.size + widget.weight) * 2,
          height: (widget.size + widget.weight) * 2,
          child: Center(child: Container(width: widget.size*2, height: widget.size*2, decoration: BoxDecoration(shape: BoxShape.circle/*, color: Colors.green*/), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: widget.middleWidgets?? [Container()]),)),
        ),
        PieChart(
          PieChartData(
              pieTouchData: PieTouchData(touchCallback:
                  (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    // pressedIndex = event.isDefinedAndNotNull;
                    return;
                  }
                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  // touchedIndex = pieTouchResponse.;
                });
              }),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: widget.spaceBetweenSections?? 0,
              centerSpaceRadius: widget.size,
              sections: showingSections()),
        ),
      ],
    );
  }

  Widget ShowShape(){
    if(widget.showGraphMap){
      return Column(
        children: [
          MyChart(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.obj!=null? widget.obj!.length : 0,
              itemBuilder: (context, index) {
                return Indicator(
                  color: widget.obj![index].titleColor,
                  text: widget.obj![index].title,
                  isSquare: true,
                );
              },
            ),
          )
        ],
      );
    }
    else{
      return MyChart();
    }
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.obj!=null? widget.obj!.length : 0, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? widget.weight * 1.2: widget.weight;
      ChartObject item = (widget.obj as List)[index];
      // isTouched&&widget.obj!=null&&widget.obj!.isNotEmpty? (widget.obj![index] as ChartObject).onPressed : 1;
      if(pressedIndex){
        setState((){ pressedIndex = false;});
        // widget.obj!=null&&widget.obj!.isNotEmpty? (widget.obj![touchedIndex] as ChartObject).onPressed : 1;
      }
      return PieChartSectionData(
        color: item.titleColor,
        value: item.value,
        showTitle: item.widget==null,
        badgeWidget: IconButton(onPressed: (widget.obj?[index] as ChartObject).onPressed, icon: item.widget),
        title: item.value.toString() + '%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyWidget(
      color: widget.backgroundColor,
      child: ShowShape(),
    );
  }
}
class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    this.color=Colors.red,
    this.text='',
    this.isSquare=false,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}



class ChartObject {
  final String  title;
  final Color  titleColor;
  final double value;
  final Icon widget;
  final onPressed;

  const ChartObject({
    this.title='',
    this.titleColor=Colors.black,
    this.value=0,
    required this.widget,
    this.onPressed,
  });
  factory ChartObject.fromData(ChartObject obj) {
    return ChartObject(
        title: obj.title,
        titleColor: obj.titleColor,
        value: obj.value,
        widget: obj.widget,
        onPressed: obj.onPressed,
    );
  }
}
