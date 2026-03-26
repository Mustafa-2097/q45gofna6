class InventoryItem {
  final String id;
  final String name;
  final double cost;
  final int stock;
  final String image;
  final String category;

  InventoryItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.stock,
    required this.image,
    required this.category,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      image: json['image'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'stock': stock,
      'image': image,
      'category': category,
    };
  }

  String get cleanedImageUrl {
    if (image.isEmpty) return 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=400&auto=format&fit=crop';
    
    // Replace localhost with the actual IP if present
    String url = image;
    if (url.contains('localhost')) {
      url = url.replaceFirst('localhost:5000', '206.162.244.189:5005');
    } else if (url.contains('127.0.0.1')) {
      url = url.replaceFirst('127.0.0.1:5000', '206.162.244.189:5005');
    }
    
    // If it's a relative path, prepend the base URL
    if (!url.startsWith('http')) {
      if (url.startsWith('/')) {
        url = 'http://206.162.244.189:5005$url';
      } else {
        url = 'http://206.162.244.189:5005/$url';
      }
    }
    
    return url;
  }
}
