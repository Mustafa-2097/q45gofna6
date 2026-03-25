class StatisticsModel {
  final int activeEvents;
  final int totalItems;
  final num totalAmount;
  final num totalLoss;

  StatisticsModel({
    required this.activeEvents,
    required this.totalItems,
    required this.totalAmount,
    required this.totalLoss,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      activeEvents: json['activeEvents'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
      totalAmount: json['totalAmount'] ?? 0,
      totalLoss: json['totalLoss'] ?? 0,
    );
  }
}
