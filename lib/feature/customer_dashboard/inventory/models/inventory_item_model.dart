class InventoryItem {
  final String id;
  final String name;
  final double cost;
  final int stock;
  final List<String> images;
  final List<String> categories;
  final List<String> categoryIds;

  InventoryItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.stock,
    required this.images,
    required this.categories,
    required this.categoryIds,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    List<String> cats = [];
    if (json['categories'] != null) {
      cats = List<String>.from(json['categories'].map((e) => e.toString()));
    } else if (json['category'] != null) {
      if (json['category'] is List) {
        cats = List<String>.from(json['category'].map((e) => e.toString()));
      } else {
        cats = [json['category'].toString()];
      }
    }

    List<String> catIds = [];
    if (json['categoryIds'] != null) {
      catIds = List<String>.from(json['categoryIds'].map((e) => e.toString()));
    } else if (json['categoryId'] != null) {
      if (json['categoryId'] is List) {
        catIds = List<String>.from(json['categoryId'].map((e) => e.toString()));
      } else {
        catIds = [json['categoryId'].toString()];
      }
    }

    List<String> imgs = [];
    if (json['images'] != null) {
      imgs = List<String>.from(json['images'].map((e) => e.toString()));
    } else if (json['image'] != null) {
      if (json['image'] is List) {
        imgs = List<String>.from(json['image'].map((e) => e.toString()));
      } else {
        imgs = [json['image'].toString()];
      }
    }

    return InventoryItem(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      images: imgs,
      categories: cats,
      categoryIds: catIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'stock': stock,
      'images': images,
      'categories': categories,
      'categoryIds': categoryIds,
    };
  }

  String get cleanedImageUrl {
    if (images.isEmpty) return 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=400&auto=format&fit=crop';
    return cleanUrl(images.first);
  }

  List<String> get cleanedImageUrls {
    if (images.isEmpty) return [];
    return images.map((e) => cleanUrl(e)).toList();
  }

  static String cleanUrl(String url) {
    if (url.isEmpty) return '';
    
    // Replace localhost with the actual IP if present
    String cleaned = url;
    if (cleaned.contains('localhost')) {
      cleaned = cleaned.replaceFirst('localhost:5000', '206.162.244.189:5005');
    } else if (cleaned.contains('127.0.0.1')) {
      cleaned = cleaned.replaceFirst('127.0.0.1:5000', '206.162.244.189:5005');
    }
    
    // If it's a relative path, prepend the base URL
    if (!cleaned.startsWith('http')) {
      if (cleaned.startsWith('/')) {
        cleaned = 'http://206.162.244.189:5005$cleaned';
      } else {
        cleaned = 'http://206.162.244.189:5005/$cleaned';
      }
    }
    
    return cleaned;
  }
}
