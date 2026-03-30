class EventModel {
  final String id;
  final String imageUrl;
  final String status;
  final String title;
  final String date;
  final String note;
  final String items;
  final String price;
  final String footerText;
  final bool hasIssue;

  EventModel({
    required this.id,
    required this.imageUrl,
    required this.status,
    required this.title,
    required this.date,
    required this.note,
    required this.items,
    required this.price,
    required this.footerText,
    required this.hasIssue,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = json['image'] ?? '';
    if (imageUrl.isNotEmpty) {
      if (imageUrl.contains('localhost')) {
        imageUrl = imageUrl.replaceFirst(
          'localhost:5000',
          '206.162.244.189:5005',
        );
      } else if (imageUrl.contains('127.0.0.1')) {
        imageUrl = imageUrl.replaceFirst(
          '127.0.0.1:5000',
          '206.162.244.189:5005',
        );
      }
      if (!imageUrl.startsWith('http')) {
        imageUrl = imageUrl.startsWith('/')
            ? 'http://206.162.244.189:5005$imageUrl'
            : 'http://206.162.244.189:5005/$imageUrl';
      }
    }

    // Normalize status: API returns 'ACTIVE'/'COMPLETED', UI compares 'Active'/'Completed'
    final rawStatus = (json['status'] as String? ?? 'ACTIVE').toUpperCase();
    final normalizedStatus = rawStatus == 'COMPLETED' ? 'Completed' : 'Active';

    // The API returns 'items' as a count number in the list endpoint
    final itemsCount = json['itemsCount'] ?? json['items'];
    final itemCountStr = itemsCount is List
        ? '${itemsCount.length} items'
        : '${itemsCount ?? 0} items';

    // The API returns 'cost' as the total event cost in the list endpoint.
    // In the detail endpoint, we may need to sum up the items.
    double costValue =
        (json['cost'] as num?)?.toDouble() ??
        (json['totalPrice'] as num?)?.toDouble() ??
        0.0;

    if (costValue == 0 && json['items'] is List) {
      final list = json['items'] as List;
      for (var it in list) {
        if (it is Map) {
          costValue += (it['total'] as num?)?.toDouble() ?? 0.0;
        }
      }
    }

    return EventModel(
      id: json['_id'] ?? json['id'] ?? '',
      imageUrl: imageUrl,
      status: normalizedStatus,
      title: json['name'] ?? '',
      date: json['date'] ?? '',
      note: json['note'] ?? '',
      items: itemCountStr,
      price: '\$$costValue',
      footerText: json['footerText'] ?? 'Baseline captured',
      hasIssue: json['hasIssue'] ?? false,
    );
  }
}

class AuditModel {
  final String id;
  final String title;
  final String? beforeImage;
  final String? afterImage;
  final bool checked;

  AuditModel({
    required this.id,
    required this.title,
    this.beforeImage,
    this.afterImage,
    required this.checked,
  });

  static String? cleanUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.contains('localhost')) {
      url = url.replaceFirst('localhost:5000', '206.162.244.189:5005');
    } else if (url.contains('127.0.0.1')) {
      url = url.replaceFirst('127.0.0.1:5000', '206.162.244.189:5005');
    }
    if (!url.startsWith('http')) {
      url = url.startsWith('/')
          ? 'http://206.162.244.189:5005$url'
          : 'http://206.162.244.189:5005/$url';
    }
    return url;
  }

  factory AuditModel.fromJson(Map<String, dynamic> json) {
    return AuditModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? 'Title',
      beforeImage: cleanUrl(json['before']),
      afterImage: cleanUrl(json['after']),
      checked: json['checked'] ?? false,
    );
  }
}

class MissingItemModel {
  final String id;
  final String name;
  final String? image;
  final double cost;

  MissingItemModel({
    required this.id,
    required this.name,
    this.image,
    required this.cost,
  });

  factory MissingItemModel.fromJson(Map<String, dynamic> json) {
    return MissingItemModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      image: AuditModel.cleanUrl(json['image']),
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class AuditReport {
  final int found;
  final int missing;
  final List<MissingItemModel> missings;
  final double totalLoss;

  AuditReport({
    required this.found,
    required this.missing,
    required this.missings,
    required this.totalLoss,
  });

  factory AuditReport.fromJson(Map<String, dynamic> json) {
    final count = json['count'] as Map<String, dynamic>? ?? {};
    final missingsList = (json['missings'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => MissingItemModel.fromJson(e))
        .toList();
    return AuditReport(
      found: (count['found'] as num?)?.toInt() ?? 0,
      missing: (count['missing'] as num?)?.toInt() ?? 0,
      missings: missingsList,
      totalLoss: (json['totalLoss'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
