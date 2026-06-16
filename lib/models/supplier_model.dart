// lib/models/supplier_model.dart

/// Model untuk data supplier/pemasok
class Supplier {
  final int? id;
  final String name;
  final String contact;
  final String email;
  final String? address;

  Supplier({
    this.id,
    required this.name,
    required this.contact,
    required this.email,
    this.address,
  });

  /// Konversi ke Map untuk penyimpanan database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'email': email,
      'address': address,
    };
  }

  /// Factory untuk membuat Supplier dari Map database
  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      contact: map['contact'],
      email: map['email'],
      address: map['address'],
    );
  }

  /// Copy with method untuk update
  Supplier copyWith({
    int? id,
    String? name,
    String? contact,
    String? email,
    String? address,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  /// Cek apakah supplier memiliki alamat
  bool get hasAddress => address != null && address!.isNotEmpty;
}