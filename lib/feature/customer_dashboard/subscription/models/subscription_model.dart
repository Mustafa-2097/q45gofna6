class SubscriptionPlan {
  final String id;
  final String type;
  final String title;
  final num priceMonthly;
  final num priceYearly;
  final num yearlyOff;
  final String monthlyPriceId;
  final String yearlyPriceId;
  final String productId;
  final int minItems;
  final int? maxItems;
  final List<String> features;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionPlan({
    required this.id,
    required this.type,
    required this.title,
    required this.priceMonthly,
    required this.priceYearly,
    required this.yearlyOff,
    required this.monthlyPriceId,
    required this.yearlyPriceId,
    required this.productId,
    required this.minItems,
    this.maxItems,
    required this.features,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? json['_id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      priceMonthly: json['priceMonthly'] ?? 0,
      priceYearly: json['priceYearly'] ?? 0,
      yearlyOff: json['yearlyOff'] ?? 0,
      monthlyPriceId: json['monthlyPriceId'] ?? '',
      yearlyPriceId: json['yearlyPriceId'] ?? '',
      productId: json['productId'] ?? '',
      minItems: json['minItems'] ?? 0,
      maxItems: json['maxItems'],
      features: List<String>.from(json['features'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class UserSubscription {
  final String id;
  final String subscriptionPlanId;
  final String? paymentId;
  final String userId;
  final String type;
  final bool isActive;
  final String status;
  final String stripeSubscriptionId;
  final String stripeCustomerId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SubscriptionPlan? plan;

  UserSubscription({
    required this.id,
    required this.subscriptionPlanId,
    this.paymentId,
    required this.userId,
    required this.type,
    required this.isActive,
    required this.status,
    required this.stripeSubscriptionId,
    required this.stripeCustomerId,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    this.plan,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] ?? json['_id'] ?? '',
      subscriptionPlanId: json['subscriptionPlanId'] ?? '',
      paymentId: json['paymentId'],
      userId: json['userId'] ?? '',
      type: json['type'] ?? '',
      isActive: json['isActive'] ?? false,
      status: json['status'] ?? '',
      stripeSubscriptionId: json['stripeSubscriptionId'] ?? '',
      stripeCustomerId: json['stripeCustomerId'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      plan: json['plan'] != null ? SubscriptionPlan.fromJson(json['plan']) : null,
    );
  }
}
