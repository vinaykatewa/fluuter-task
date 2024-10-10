class Scheme {
  final String plotName;
  final String schemeName;
  final String plotNo;
  final String attributesData;
  final String propertyStatus;

  Scheme({
    required this.plotName,
    required this.schemeName,
    required this.plotNo,
    required this.attributesData,
    required this.propertyStatus,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      plotName: json['plot_name'],
      schemeName: json['scheme_name'],
      plotNo: json['plot_no'],
      attributesData: json['attributes_data'],
      propertyStatus: json['property_status'],
    );
  }
}
