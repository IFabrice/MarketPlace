enum UserRole { client, vendor }

class UserModel {
  final String uid;
  final String phone;
  final UserRole role;
  final String name;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.phone,
    required this.role,
    required this.name,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      phone: map['phone'] as String,
      role: UserRole.values.firstWhere(
        (r) => r.name == map['role'],
        orElse: () => UserRole.client,
      ),
      name: map['name'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] as int? ?? 0,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'phone': phone,
        'role': role.name,
        'name': name,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  UserModel copyWith({
    String? uid,
    String? phone,
    UserRole? role,
    String? name,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
