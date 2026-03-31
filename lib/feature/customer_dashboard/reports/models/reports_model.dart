class ReportsModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final ReportsData? data;

  ReportsModel({this.success, this.statusCode, this.message, this.data});

  factory ReportsModel.fromJson(Map<String, dynamic> json) {
    return ReportsModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? ReportsData.fromJson(json['data']) : null,
    );
  }
}

class ReportsData {
  final ReportsStatistics? statistics;
  final List<RecentReport>? recentReports;
  final String? pdf;

  ReportsData({this.statistics, this.recentReports, this.pdf});

  factory ReportsData.fromJson(Map<String, dynamic> json) {
    return ReportsData(
      statistics: json['statistics'] != null
          ? ReportsStatistics.fromJson(json['statistics'])
          : null,
      recentReports: json['reports'] != null
          ? (json['reports'] as List)
                .map((v) => RecentReport.fromJson(v))
                .toList()
          : null,
      pdf: json['pdf'],
    );
  }
}

class ReportsStatistics {
  final num? totalAudits;
  final num? totalLoss;
  final num? totalAverage;
  final num? successRate;

  ReportsStatistics({
    this.totalAudits,
    this.totalLoss,
    this.totalAverage,
    this.successRate,
  });

  factory ReportsStatistics.fromJson(Map<String, dynamic> json) {
    return ReportsStatistics(
      totalAudits: json['totalAudits'],
      totalLoss: json['totalLoss'],
      totalAverage: json['totalAverage'],
      successRate: json['successRate'],
    );
  }
}

class RecentReport {
  final String? id;
  final String? eventName;
  final String? date;
  final String? image;
  final num? itemsCount;
  final num? itemsValue;
  final num? missingCount;
  final num? missingValue;
  final List<dynamic>? missingItems;
  final String? eventId;

  RecentReport({
    this.id,
    this.eventName,
    this.date,
    this.image,
    this.itemsCount,
    this.itemsValue,
    this.missingCount,
    this.missingValue,
    this.missingItems,
    this.eventId,
  });

  factory RecentReport.fromJson(Map<String, dynamic> json) {
    return RecentReport(
      id: json['id'],
      eventName: json['eventName'],
      date: json['date'],
      image: json['image'],
      itemsCount: json['itemsCount'],
      itemsValue: json['itemsValue'],
      missingCount: json['missingCount'],
      missingValue: json['missingValue'],
      missingItems: json['missingItems'] != null
          ? List<dynamic>.from(json['missingItems'])
          : null,
      eventId: json['eventId'],
    );
  }
}
