import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SchemeListView extends StatefulWidget {
  final String plotName;
  final String schemeName;
  final String plotNo;
  final String attributesData;
  final String propertyStatus;

  const SchemeListView({
    super.key,
    required this.plotName,
    required this.schemeName,
    required this.plotNo,
    required this.attributesData,
    required this.propertyStatus,
  });

  @override
  State<SchemeListView> createState() => _SchemeListViewState();
}

class _SchemeListViewState extends State<SchemeListView> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        padding:
            EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w, bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.07),
          borderRadius: BorderRadius.circular(8.r),
          border: Border(
            top: isExpanded ? BorderSide(width: 1.w) : BorderSide.none,
            bottom: isExpanded ? BorderSide(width: 1.w) : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.plotName,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 26, 55, 105)),
                    ),
                    Text(
                      widget.schemeName,
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Color.fromARGB(255, 26, 55, 105)),
                    ),
                  ],
                ),
                Text(
                  widget.propertyStatus,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                )
              ],
            ),
            if (isExpanded) ...[
              SizedBox(height: 10.h),
              Divider(),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Text(
                  json
                      .decode(widget.attributesData)
                      .entries
                      .map((entry) => '${entry.key}: ${entry.value}')
                      .join(', '),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Handle button press
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 11, 72, 122),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: Colors.blue, width: 1.w),
                    ),
                    child: Text(
                      'Book/hold',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
