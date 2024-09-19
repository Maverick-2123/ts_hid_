import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../globals/global_variables.dart';

class CustomPieChart extends StatefulWidget {


  const CustomPieChart({super.key});

  @override
  State<CustomPieChart> createState() => CustomPieChartState();
}

TextStyle pieChartTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontSize: 12,
);

class CustomPieChartState extends State<CustomPieChart> {
  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(totalCount.toStringAsFixed(0), style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),),
        PieChart(
          swapAnimationCurve: Curves.easeInOut,
          swapAnimationDuration: Duration(milliseconds: 350),

          PieChartData(
              sectionsSpace: 1,
              startDegreeOffset: 20,
              centerSpaceRadius: 30,
              sections: [
                PieChartSectionData(
                    color: Colors.red,
                    title: burningCount.toStringAsFixed(0),
                    titleStyle: pieChartTextStyle,
                    value: burningCount,
                    radius: 30),
                PieChartSectionData(
                    color: Colors.orange,
                    title: hotCount.toStringAsFixed(0),
                    titleStyle: pieChartTextStyle,
                    value: hotCount,
                    radius: 30),
                PieChartSectionData(
                    color: Colors.green,
                    title: trackingCount.toStringAsFixed(0),
                    titleStyle: pieChartTextStyle,
                    value: trackingCount,
                    radius: 30),
              ]),
        ),
      ],
    );
  }
}
