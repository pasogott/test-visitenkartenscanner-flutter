class BusinessCard {
  final int? id;
  final String frontImagePath;
  final String? backImagePath;
  final String? selfieImagePath;
  final DateTime createdAt;
  final String? notes;

  BusinessCard({
    this.id,
    required this.frontImagePath,
    this.backImagePath,
    this.selfieImagePath,
    required this.createdAt,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'front_image_path': frontImagePath,
      'back_image_path': backImagePath,
      'selfie_image_path': selfieImagePath,
      'created_at': createdAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory BusinessCard.fromMap(Map<String, dynamic> map) {
    return BusinessCard(
      id: map['id'] as int?,
      frontImagePath: map['front_image_path'] as String,
      backImagePath: map['back_image_path'] as String?,
      selfieImagePath: map['selfie_image_path'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      notes: map['notes'] as String?,
    );
  }

  BusinessCard copyWith({
    int? id,
    String? frontImagePath,
    String? backImagePath,
    String? selfieImagePath,
    DateTime? createdAt,
    String? notes,
  }) {
    return BusinessCard(
      id: id ?? this.id,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      selfieImagePath: selfieImagePath ?? this.selfieImagePath,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}
