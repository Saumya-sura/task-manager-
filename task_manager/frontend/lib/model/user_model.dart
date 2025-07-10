
import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String token;
  final DateTime createdAt;
  final DateTime updatedAt;
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      // Handle both camelCase (createdAt) and snake_case (created_at) field names
      final createdAtValue = map['createdAt'] ?? map['created_at'];
      final updatedAtValue = map['updatedAt'] ?? map['updated_at'];

      return UserModel(
        id: map['id']?.toString() ?? '',
        email: map['email']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        token: map['token']?.toString() ?? '',
        createdAt: createdAtValue != null ? DateTime.parse(createdAtValue.toString()) : DateTime.now(),
        updatedAt: updatedAtValue != null ? DateTime.parse(updatedAtValue.toString()) : DateTime.now(),
      );
    } catch (e) {
      print("Error creating UserModel from map: $e");
      print("Problematic map: $map");
      // Return a default user model as fallback
      return UserModel(
        id: '',
        email: '',
        name: '',
        token: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) {
    try {
      if (source.isEmpty) {
        throw Exception("Empty JSON string");
      }
      
      final Map<String, dynamic> data = json.decode(source) as Map<String, dynamic>;
      return UserModel.fromMap(data);
    } catch (e) {
      print("Error parsing JSON: $e");
      print("Source JSON: $source");
      
      // Return a default user model as fallback
      return UserModel(
        id: '',
        email: '',
        name: '',
        token: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, token: $token, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.name == name &&
        other.token == token &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        token.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}