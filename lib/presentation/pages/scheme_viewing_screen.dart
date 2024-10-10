import 'dart:convert';
import 'package:fltask/presentation/widgets/scheme_app_bar.dart';
import 'package:fltask/presentation/widgets/scheme_listview.dart';
import 'package:fltask/models/scheme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class SchemeViewingScreen extends StatefulWidget {
  final String token;
  SchemeViewingScreen({required this.token});

  @override
  _SchemeViewingScreenState createState() => _SchemeViewingScreenState();
}

class _SchemeViewingScreenState extends State<SchemeViewingScreen> {
  List<Scheme> schemes = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    fetchSchemes();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (currentPage < totalPages && !isLoading) {
        fetchSchemes();
      }
    }
  }

  Future<void> fetchSchemes() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var headers = {
      'Authorization': 'Bearer ${widget.token}',
    };
    var request = http.Request(
      'GET',
      Uri.parse(
          'https://test.bookinggksm.com/api/scheme/view-scheme/55?page=$currentPage'),
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      List<dynamic> data = jsonResponse['result']['properties']['data'];

      setState(() {
        schemes.addAll(data.map((item) => Scheme.fromJson(item)).toList());
        currentPage++;
        totalPages = jsonResponse['result']['properties']['last_page'];
        isLoading = false;
      });
    } else {
      print(response.reasonPhrase);
      setState(() {
        isLoading = false;
      });
    }
  }

  String getPropertyStatus(String status) {
    switch (status) {
      case '1':
        return 'Available';
      case '2':
        return 'Booked';
      case '3':
        return 'Hold';
      case '4':
        return 'Cancel';
      case '5':
        return 'Complete';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: schemes.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SchemeAppBar(),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: schemes.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == schemes.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }

                      final scheme = schemes[index];
                      return SchemeListView(
                        plotName: scheme.plotName,
                        schemeName: scheme.schemeName,
                        plotNo: scheme.plotNo,
                        attributesData: scheme.attributesData,
                        propertyStatus:
                            getPropertyStatus(scheme.propertyStatus),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}
