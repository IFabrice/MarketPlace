enum VendorType { market, individual }

class VendorModel {
  final String vendorId;
  final String userId;
  final String businessName;
  final VendorType type;

  // Market vendor fields
  final String? marketId;
  final String? stallCode; // e.g., NYA-A2-04

  // Individual vendor fields
  final String? neighborhood;
  final double? latitude;
  final double? longitude;

  final String? profileImageUrl;
  final String mainCategory;
  final double rating;
  final int reviewCount;
  final bool isActive;
  final DateTime createdAt;

  const VendorModel({
    required this.vendorId,
    required this.userId,
    required this.businessName,
    required this.type,
    this.marketId,
    this.stallCode,
    this.neighborhood,
    this.latitude,
    this.longitude,
    this.profileImageUrl,
    required this.mainCategory,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isActive = true,
    required this.createdAt,
  });

  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      vendorId: map['vendorID'] as String,
      userId: map['userID'] as String,
      businessName: map['businessName'] as String,
      type: VendorType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => VendorType.individual,
      ),
      marketId: map['marketID'] as String?,
      stallCode: map['stallCode'] as String?,
      neighborhood: map['neighborhood'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      profileImageUrl: map['profileImageUrl'] as String?,
      mainCategory: map['mainCategory'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] as int? ?? 0,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] as int? ?? 0,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'vendorID': vendorId,
        'userID': userId,
        'businessName': businessName,
        'type': type.name,
        if (marketId != null) 'marketID': marketId,
        if (stallCode != null) 'stallCode': stallCode,
        if (neighborhood != null) 'neighborhood': neighborhood,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        'mainCategory': mainCategory,
        'rating': rating,
        'reviewCount': reviewCount,
        'isActive': isActive,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  /// Decodes the stall code into human-readable directions.
  /// Format: [MarketPrefix]-[Aisle]-[Stall#]  e.g., NYA-A2-04
  String? get gridDirections {
    if (stallCode == null) return null;
    final parts = stallCode!.split('-');
    if (parts.length != 3) return stallCode;

    final prefix = parts[0];
    final aisle = parts[1]; // e.g., A2
    final stall = parts[2]; // e.g., 04

    final aisleNum = int.tryParse(aisle.substring(1));
    final stallNum = int.tryParse(stall);

    if (aisleNum == null || stallNum == null) return stallCode;

    final gate = aisleNum <= 3 ? 1 : 2;
    final direction = stallNum <= 5 ? 'left' : 'right';

    return 'Enter via Gate $gate, Aisle ${aisle.toUpperCase()}, '
        'stall #$stallNum on the $direction.';
  }
}
