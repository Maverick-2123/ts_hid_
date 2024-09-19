// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ts_hid/Models/get_all_issues.dart';
import 'package:ts_hid/Models/graph_model.dart';
import 'package:ts_hid/components/appDrawer.dart';
import 'package:ts_hid/components/glassCards/glassCard.dart';
import 'package:ts_hid/components/glassCards/notesCard.dart';
import 'package:ts_hid/components/pieChart.dart';
import 'package:ts_hid/controllers/controllers.dart';
import 'package:ts_hid/globals/global_variables.dart';
import 'package:ts_hid/pages/issueDetail.dart';
import 'package:http/http.dart' as http;
import '../components/glassCards/dashboardCards.dart';
import 'addIssue.dart';

class AllIssuesPage extends StatefulWidget {
  const AllIssuesPage({super.key});

  @override
  State<AllIssuesPage> createState() => AllIssuesPageState();
}

class AllIssuesPageState extends State<AllIssuesPage> {
  void resetTextField() {
    requesterNameController.clear();
    productNameController.clear();
    regionController.clear();
    productFamilyController.clear();
    countryController.clear();
    softwareVersionController.clear();
    issueTitleController.clear();
    issueDescriptionController.clear();
    customerNameController.clear();
    productTicketNumberController.clear();
    ticketNumberController.clear();
    ticketNumberController.clear();
    productTicketNumberController.clear();
  }

  late Future<List<GetAllIssues>> futureIssues;
  late Future<GraphModel> futureGraph;

  final String issueBaseURL = 'http://15.207.244.117/api/issues/';
  final String graphBaseURL = 'http://15.207.244.117/api/issue-stats/';

  List<GetAllIssues> allIssues = [];
  List<GetAllIssues> filteredIssues = [];
  String? userRole;

  @override
  void initState() {
    super.initState();
    futureIssues = fetchAllIssues();
    futureGraph = fetchGraph();
    getUserRole();
  }

  Future <void> getUserRole() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('userRole');
    });
  }

  Future<List<GetAllIssues>> fetchAllIssues() async {
    final response = await http.get(Uri.parse(issueBaseURL));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<GetAllIssues> issues =
          jsonData.map((json) => GetAllIssues.fromJson(json)).toList();
      issues.sort((a, b) => b.createdAt!.compareTo(a.lastUpdated!));

      allIssues = issues;
      filteredIssues = allIssues
          .where((issue) =>
              issue.status?.trim() != "Closed" &&
              issue.status?.trim() != "Resolved")
          .toList();
      return filteredIssues;
    } else {
      throw Exception('Failed to load issues');
    }
  }

  // Function to filter issues based on search query
  void filterIssues(String query) {
    List<GetAllIssues> tempIssues = allIssues.where((issue) {
      return (issue.title!.toLowerCase().contains(query.toLowerCase()) ||
              issue.name!.toLowerCase().contains(query.toLowerCase()) ||
              issue.severity!.toLowerCase().contains(query.toLowerCase()) ||
              issue.status!.toLowerCase().contains(query.toLowerCase()) ||
              issue.country!.toLowerCase().contains(query.toLowerCase()) ||
              issue.product!.toLowerCase().contains(query.toLowerCase()) ||
              issue.productFamily!.toLowerCase().contains(query.toLowerCase()) ||
              issue.ticket!.toLowerCase().contains(query.toLowerCase()) ||
              issue.customer!.toLowerCase().contains(query.toLowerCase()) ||
              issue.createdAt!.toLowerCase().contains(query.toLowerCase()) ||
              issue.region!.toLowerCase().contains(query.toLowerCase()) ||
              issue.problemTicket!.toLowerCase().contains(query.toLowerCase()) ||
              issue.description!.toLowerCase().contains(query.toLowerCase())) &&
          (issue.status?.trim() != "Closed" &&
              issue.status?.trim() != "Resolved");
    }).toList();

    setState(() {
      filteredIssues = tempIssues;
    });
  }

  Future<GraphModel> fetchGraph() async {
    try {
      final responseGraph = await http.get(Uri.parse(graphBaseURL));

      if (responseGraph.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(responseGraph.body);
        GraphModel graphModel = GraphModel.fromJson(jsonData);
        print('Parsed Graph Data: $graphModel');
        return graphModel;
      } else {
        throw Exception('Failed to load graph');
      }
    } catch (e) {
      print('Error fetching graph data: $e');
      throw e;
    }
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    DateTime utcTime = DateTime.parse(dateString);
    DateTime istTime = utcTime.add(Duration(hours: 5, minutes: 30));
    return DateFormat('dd MMM yyyy, hh:mm a').format(istTime);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Image.asset('assets/logo.png', height: screenHeight * 0.015),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.transparent,
                  duration: Duration(seconds: 4),
                  elevation: 0,
                  content: AwesomeSnackbarContent(
                    title: 'Success!',
                    message: 'Page Successfully Refreshed',
                    contentType: ContentType.success,
                    messageTextStyle:
                        GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  )));
              setState(() {
                futureIssues = fetchAllIssues();
                futureGraph = fetchGraph();
              });
            },
            icon: Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      drawer: CustomAppDrawer(),
      floatingActionButton: (userRole == 'admin' || userRole == 'managers') ? FloatingActionButton(
        tooltip: 'Add Issue',
        enableFeedback: true,
        elevation: 10,
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Color(0xff021526),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddIssue()),
          );
          resetTextField();
        },
        child: Icon(
          Icons.add,
          size: screenHeight * 0.045,
          color: Colors.white,
        ),
      ) : null,
      body: RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.black12,
        onRefresh: () async {
          await futureIssues;
          await futureGraph;
          setState(() {});
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff000000), Color(0xff11307A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 15),
                  //   child: Text('Hot Issues Dashboard',
                  //   style: GoogleFonts.poppins(
                  //     color: Color(0xffF0F8FF),
                  //     fontSize: 25,
                  //     fontWeight: FontWeight.w500,
                  //   )
                  //     ,),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: GlassCard(
                      height: screenHeight * 0.76,
                      width: double.infinity,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FutureBuilder<GraphModel>(
                                future: futureGraph,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: SizedBox(
                                      height: screenHeight * 0.33,
                                      width: screenWidth * 0.5,
                                      child: Lottie.asset(
                                          'assets/loadingAnimation.json'),
                                    ));
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(30),
                                      child: Text(
                                        'Error Loading Graph. Check your Internet Connection!',
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                  } else if (!snapshot.hasData) {
                                    return Center(
                                        child:
                                            Text('No graph data available.'));
                                  } else {
                                    final graphData = snapshot.data!;

                                    final int criticalCount =
                                        graphData.criticalCount ?? 0;
                                    final int amberCount =
                                        graphData.amberCount ?? 0;
                                    final int trackingCount =
                                        graphData.trackingCount ?? 0;
                                    final int totalCount =
                                        graphData.totalCount ?? 0;

                                    final List<ChartData> chartData = [
                                      ChartData('Critical', criticalCount,
                                          Colors.red),
                                      ChartData(
                                          'Amber', amberCount, Colors.orange),
                                      ChartData('Tracking', trackingCount,
                                          Colors.green),
                                    ];

                                    return Center(
                                      child: Container(
                                        height: screenHeight * 0.33,
                                        width: screenWidth * 0.9,
                                        child: SfCircularChart(
                                          title: ChartTitle(
                                              text: 'Ongoing Issues',
                                              textStyle: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14)),
                                          annotations: <CircularChartAnnotation>[
                                            CircularChartAnnotation(
                                                widget: Text(
                                                    '${graphData.totalCount}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w700)))
                                          ],
                                          borderWidth: 10,
                                          legend: Legend(
                                            iconHeight: screenHeight * 0.025,
                                            isVisible: true,
                                            isResponsive: true,
                                            textStyle: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          ),
                                          series: <CircularSeries>[
                                            DoughnutSeries<ChartData, String>(
                                              explode: true,
                                              // explodeAll: true,
                                              explodeGesture: ActivationMode.singleTap,
                                              enableTooltip: true,
                                              explodeOffset: '15%',
                                              radius: '80%',
                                              dataSource: chartData,
                                              xValueMapper:
                                                  (ChartData data, _) =>
                                                      data.category,
                                              yValueMapper:
                                                  (ChartData data, _) =>
                                                      data.count,
                                              pointColorMapper:
                                                  (ChartData data, _) =>
                                                      data.color,
                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                      isVisible: true,
                                                      showZeroValue: true,
                                                      textStyle:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14)),
                                              animationDuration: 1200,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                }),
                            FutureBuilder<GraphModel>(
                                future: futureGraph,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: SizedBox(
                                      height: screenHeight * 0.33,
                                      width: screenWidth * 0.5,
                                      child: Lottie.asset(
                                          'assets/loadingAnimation.json'),
                                    ));
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(30),
                                      child: Text(
                                        'Error Loading. Check your Internet Connection!',
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                  } else if (!snapshot.hasData) {
                                    return Center(
                                        child: Text('No data available.'));
                                  } else {
                                    final graphData = snapshot.data!;

                                    return Container(
                                        width: double.infinity,
                                        height: screenHeight * 0.4,
                                        padding: EdgeInsets.all(5),
                                        child: Center(
                                          child: Wrap(
                                            spacing: screenWidth * 0.02,
                                            runSpacing: screenHeight * 0.01,
                                            children: [
                                              DashBoardCard(
                                                  width: screenWidth * 0.47,
                                                  height: screenHeight * 0.2,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Hottest Country',
                                                                style: GoogleFonts.poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 5,
                                                                        bottom:
                                                                            10),
                                                                child: SizedBox(
                                                                  height:
                                                                      screenHeight *
                                                                          0.03,
                                                                  width:
                                                                      screenWidth *
                                                                          0.035,
                                                                  child: Lottie.asset(
                                                                      'assets/burningAnimation.json',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      backgroundLoading:
                                                                          true,
                                                                      repeat:
                                                                          true),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            '${graphData.hottestCountry}',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          Text(
                                                            '${graphData.hottestIssueCount} Issues',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white54,
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              DashBoardCard(
                                                  width: screenWidth * 0.47,
                                                  height: screenHeight * 0.2,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text(
                                                            'Closed Cases YTD',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                          Text(
                                                            '${graphData.closedIssuesCount} Issues',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .white70,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                          SizedBox(height: screenHeight*0.01,),
                                                          // Padding(
                                                          //   padding:
                                                          //       const EdgeInsets
                                                          //           .only(
                                                          //           left: 8,
                                                          //           bottom: 1,
                                                          //           right: 10),
                                                          //   child: SizedBox(
                                                          //     height:
                                                          //         screenHeight *
                                                          //             0.03,
                                                          //     width: screenWidth *
                                                          //         0.02,
                                                          //     child: Lottie.asset(
                                                          //         'assets/productAnimation.json',
                                                          //         fit: BoxFit
                                                          //             .cover,
                                                          //         backgroundLoading:
                                                          //             true,
                                                          //         repeat: true),
                                                          //   ),
                                                          // ),
                                                          Text(
                                                            'Total Cases YTD',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                          Text(
                                                            '${graphData.totalIssuesCount} Issues',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                color: Colors
                                                                    .white70,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              DashBoardCard(
                                                  width: screenWidth * 0.47,
                                                  height: screenHeight * 0.2,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Major Contributor',
                                                                style: GoogleFonts.poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 3,
                                                                        bottom:
                                                                            2),
                                                                child: SizedBox(
                                                                  height:
                                                                      screenHeight *
                                                                          0.033,
                                                                  width:
                                                                      screenWidth *
                                                                          0.035,
                                                                  child: Lottie.asset(
                                                                      'assets/vulnerableAnimation.json',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      backgroundLoading:
                                                                          true,
                                                                      repeat:
                                                                          true),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            '${graphData.commonProduct}',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          Text(
                                                            '${graphData.productIssueCount} Issues',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white54,
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              DashBoardCard(
                                                  width: screenWidth * 0.47,
                                                  height: screenHeight * 0.2,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Majority Status',
                                                                style: GoogleFonts.poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 5,
                                                                        right: 20,
                                                                        bottom:
                                                                            10),
                                                                child: SizedBox(
                                                                  height:
                                                                      screenHeight *
                                                                          0.03,
                                                                  width:
                                                                      screenWidth *
                                                                          0.03,
                                                                  child: Lottie.asset(
                                                                      'assets/graphAnimation.json',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      backgroundLoading:
                                                                          true,
                                                                      repeat:
                                                                          true),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            '${graphData.maxStatus}',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          Text(
                                                            '${graphData.statusIssueCount} Issues',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white54,
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ));
                                  }
                                })
                          ]),
                    ),
                  ),

                  //Previous Pie Chart Code

                  // Padding(
                  //   padding: EdgeInsets.only(left: 15, right: 15),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       GlassCard(
                  //         height: screenHeight * 0.2,
                  //         width: screenWidth * 0.45,
                  //         child: CustomPieChart(),
                  //       ),
                  //       GlassCard(
                  //         height: screenHeight * 0.2,
                  //         width: screenWidth * 0.45,
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             ListTile(
                  //               leading: Icon(
                  //                 Icons.circle,
                  //                 color: Colors.red,
                  //                 size: 15,
                  //               ),
                  //               horizontalTitleGap: 2,
                  //               minTileHeight: 1,
                  //               title: Text('Critical', style: labelStyle),
                  //               minVerticalPadding: 1,
                  //             ),
                  //             ListTile(
                  //               leading: Icon(
                  //                 Icons.circle,
                  //                 color: Colors.orange,
                  //                 size: 15,
                  //               ),
                  //               horizontalTitleGap: 2,
                  //               title: Text('Amber', style: labelStyle),
                  //               minVerticalPadding: 2,
                  //             ),
                  //             ListTile(
                  //               leading: Icon(
                  //                 Icons.circle,
                  //                 color: Colors.green,
                  //                 size: 15,
                  //               ),
                  //               horizontalTitleGap: 2,
                  //               minTileHeight: 1,
                  //               title: Text('Tracking', style: labelStyle),
                  //               minVerticalPadding: 2,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Padding(
                  //   padding: EdgeInsets.only(top: 10),
                  //   child: ListTile(
                  //     onTap: (){
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackBar(
                  //           content: Text(
                  //             'This feature will be available soon!',
                  //             style: GoogleFonts.poppins(color: Colors.white),
                  //           ),
                  //           backgroundColor: Colors.green,
                  //           duration: Duration(seconds: 3),
                  //         ),
                  //       );
                  //     },
                  //     leading: Icon(Icons.filter_list_rounded, color: Colors.white,),
                  //     horizontalTitleGap: 5,
                  //     title: Text('Filter', style: GoogleFonts.poppins(
                  //         color: Colors.white,
                  //         fontSize: 14
                  //     ),),
                  //   ),
                  // ),

                  Text(
                    'Open Issues',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 30),
                    child: Divider(
                      color: Colors.white,
                      endIndent: screenWidth * 0.42,
                      indent: screenWidth * 0.42,
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                    child: TextField(
                        onChanged: (value) {
                          filterIssues(value);
                        },
                        cursorColor: Colors.white30,
                        controller: searchController,
                        maxLines: null,
                        autofocus: false,
                        keyboardType: TextInputType.name,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.white54,
                          ),
                          filled: true,
                          fillColor: Color(0xff021526),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          hintText: '   Search Issues',
                          hintStyle: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic),
                        )),
                  ),

                  FutureBuilder<List<GetAllIssues>>(
                    future: futureIssues,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error Loading Issues. Check your Internet Connection!',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (snapshot.hasData &&
                          filteredIssues.isNotEmpty) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredIssues.length,
                          itemBuilder: (context, index) {
                            final issue = filteredIssues[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => IssueDetail(
                                        issue: filteredIssues[index]),
                                  ),
                                );
                              },
                              child: NotesCard(
                                severity: issue.severity,
                                textColor: getColor(issue.severity.toString()),
                                postedTime: formatDate(issue.createdAt!),
                                prodFamily: issue.productFamily,
                                customer: issue.customer,
                                country: issue.country,
                                region: '🌐 ${teams[selectedItemsIndex]}',
                                titleText: issue.title,
                                ticketNumber: issue.ticket,
                                status: issue.status,
                                softwareVersion: issue.technology,
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                          'Error Loading Issues. Check your Internet Connection!',
                          style: TextStyle(color: Colors.white),
                        ));
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                            child: Text('No issues found',
                            style: GoogleFonts.poppins(
                              color: Colors.white30,
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                            )
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Divider(
                      endIndent: screenWidth*0.1,
                      indent: screenWidth*0.1,
                      color: Colors.white30,
                      height: screenHeight*0.1,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                      child: Text('You Have Reached the End of Ongoing Issues.',
                      style: GoogleFonts.poppins(
                        color: Colors.white30,
                        fontSize: 26,
                        fontWeight: FontWeight.w700
                      ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,left: 20, right: 20, bottom: 40),
                    child: Text('Developed by the Innovation & Performance Team, Nokia Plot 25, Gurgaon, IN.',
                      style: GoogleFonts.poppins(
                          color: Colors.white30,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.category, this.count, this.color);
  final String category;
  final int count;
  final Color color;
}
