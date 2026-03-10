class ProductModel {
  final String productId;
  final String vendorId;
  final String name;
  final int price; // in RWF
  final String description;
  final String? imageUrl;
  final String category;
  final bool inStock;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.productId,
    required this.vendorId,
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
    required this.category,
    this.inStock = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productID'] as String,
      vendorId: map['vendorID'] as String,
      name: map['name'] as String,
      price: map['price'] as int? ?? 0,
      description: map['description'] as String? ?? '',
      imageUrl: map['imageURL'] as String?,
      category: map['category'] as String? ?? '',
      inStock: map['inStock'] as bool? ?? true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] as int? ?? 0,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt'] as int? ?? 0,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'productID': productId,
        'vendorID': vendorId,
        'name': name,
        'price': price,
        'description': description,
        if (imageUrl != null) 'imageURL': imageUrl,
        'category': category,
        'inStock': inStock,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };

  ProductModel copyWith({bool? inStock}) => ProductModel(
        productId: productId,
        vendorId: vendorId,
        name: name,
        price: price,
        description: description,
        imageUrl: imageUrl,
        category: category,
        inStock: inStock ?? this.inStock,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );

  String get formattedPrice => '${price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (m) => '${m[1]},',
      )} RWF';

  // Product categories available in Rwandan markets
  static List<String> get categories => [
        'Food & Groceries',
        'Vegetables & Fruits',
        'Clothing & Textiles',
        'Electronics',
        'Household Items',
        'Beauty & Health',
        'Construction Materials',
        'Agriculture & Farming',
        'Crafts & Handmade',
        'Mobile & Accessories',
        'Other',
      ];
}
