class UserModel {
  int? id;
  String username;
  String password;
  String namaBisnis;
  String? gambarProfil;
  String? createdAt;
  String? updatedAt;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    required this.namaBisnis,
    this.gambarProfil,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'nama_bisnis': namaBisnis,
      'gambar_profil': gambarProfil,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      namaBisnis: map['nama_bisnis'],
      gambarProfil: map['gambar_profil'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? password,
    String? namaBisnis,
    String? gambarProfil,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      namaBisnis: namaBisnis ?? this.namaBisnis,
      gambarProfil: gambarProfil ?? this.gambarProfil,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, namaBisnis: $namaBisnis)';
  }
}