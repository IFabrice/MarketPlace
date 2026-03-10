import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/vendor_model.dart';
import '../models/product_model.dart';
import '../models/market_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Collection references ──────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('Users');

  CollectionReference<Map<String, dynamic>> get _vendors =>
      _db.collection('Vendors');

  CollectionReference<Map<String, dynamic>> get _products =>
      _db.collection('Products');

  CollectionReference<Map<String, dynamic>> get _markets =>
      _db.collection('Markets');

  CollectionReference<Map<String, dynamic>> get _chats =>
      _db.collection('Chats');

  // ─── Users ──────────────────────────────────────────────────────────────────

  Future<void> createUser(UserModel user) =>
      _users.doc(user.uid).set(user.toMap());

  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<bool> userExists(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.exists;
  }

  // ─── Vendors ─────────────────────────────────────────────────────────────────

  Future<void> createVendor(VendorModel vendor) =>
      _vendors.doc(vendor.vendorId).set(vendor.toMap());

  Future<VendorModel?> getVendorByUserId(String userId) async {
    final query = await _vendors
        .where('userID', isEqualTo: userId)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return VendorModel.fromMap(query.docs.first.data());
  }

  Stream<List<VendorModel>> watchVendorsByMarket(String marketId) =>
      _vendors
          .where('marketID', isEqualTo: marketId)
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snap) =>
              snap.docs.map((d) => VendorModel.fromMap(d.data())).toList());

  // ─── Products ────────────────────────────────────────────────────────────────

  Future<void> createProduct(ProductModel product) =>
      _products.doc(product.productId).set(product.toMap());

  Future<void> updateProductStock(String productId, {required bool inStock}) =>
      _products.doc(productId).update({
        'inStock': inStock,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

  Stream<List<ProductModel>> watchVendorProducts(String vendorId) =>
      _products
          .where('vendorID', isEqualTo: vendorId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snap) =>
              snap.docs.map((d) => ProductModel.fromMap(d.data())).toList());

  Future<List<ProductModel>> searchProducts(String query) async {
    // Basic prefix search — swap for Algolia/Typesense in production
    final snap = await _products
        .where('inStock', isEqualTo: true)
        .orderBy('name')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .limit(20)
        .get();
    return snap.docs.map((d) => ProductModel.fromMap(d.data())).toList();
  }

  // ─── Markets ─────────────────────────────────────────────────────────────────

  Future<List<MarketModel>> getMarkets() async {
    final snap = await _markets.orderBy('name').get();
    return snap.docs.map((d) => MarketModel.fromMap(d.data())).toList();
  }

  Future<void> seedMarkets() async {
    final batch = _db.batch();
    for (final market in MarketModel.seedMarkets) {
      batch.set(_markets.doc(market.marketId), market.toMap());
    }
    await batch.commit();
  }
}
