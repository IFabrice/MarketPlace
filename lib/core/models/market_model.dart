class MarketModel {
  final String marketId;
  final String name;
  final String city;
  final String prefix; // e.g., "NYA" for Nyabugogo
  final int totalStalls;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;

  const MarketModel({
    required this.marketId,
    required this.name,
    required this.city,
    required this.prefix,
    required this.totalStalls,
    this.latitude,
    this.longitude,
    this.imageUrl,
  });

  factory MarketModel.fromMap(Map<String, dynamic> map) {
    return MarketModel(
      marketId: map['marketID'] as String,
      name: map['name'] as String,
      city: map['city'] as String,
      prefix: map['prefix'] as String? ?? '',
      totalStalls: map['totalStalls'] as int? ?? 0,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'marketID': marketId,
        'name': name,
        'city': city,
        'prefix': prefix,
        'totalStalls': totalStalls,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

  // Seed data: major Rwandan markets
  static List<MarketModel> get seedMarkets => [
        const MarketModel(
          marketId: 'NYA',
          name: 'Nyabugogo Market',
          city: 'Kigali',
          prefix: 'NYA',
          totalStalls: 500,
          latitude: -1.9397,
          longitude: 30.0542,
        ),
        const MarketModel(
          marketId: 'KIM',
          name: 'Kimironko Market',
          city: 'Kigali',
          prefix: 'KIM',
          totalStalls: 400,
          latitude: -1.9320,
          longitude: 30.1018,
        ),
        const MarketModel(
          marketId: 'KAC',
          name: 'Kacyiru Market',
          city: 'Kigali',
          prefix: 'KAC',
          totalStalls: 200,
          latitude: -1.9500,
          longitude: 30.0614,
        ),
        const MarketModel(
          marketId: 'GIS',
          name: 'Gisozi Market',
          city: 'Kigali',
          prefix: 'GIS',
          totalStalls: 180,
          latitude: -1.9080,
          longitude: 30.0693,
        ),
        const MarketModel(
          marketId: 'REM',
          name: 'Remera Market',
          city: 'Kigali',
          prefix: 'REM',
          totalStalls: 250,
          latitude: -1.9490,
          longitude: 30.1134,
        ),
        const MarketModel(
          marketId: 'MUS',
          name: 'Musanze Market',
          city: 'Musanze',
          prefix: 'MUS',
          totalStalls: 300,
          latitude: -1.4986,
          longitude: 29.6337,
        ),
      ];
}
