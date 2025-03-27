class UserModel {
  String uid;
  String name;
  String phone;
  String email;
  String address;
  String imageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.imageUrl,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'imageUrl': imageUrl,
    };
  }

  // Convert from Firebase Document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // ✅ Add copyWith method
  UserModel copyWith({
    String? uid,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? imageUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
