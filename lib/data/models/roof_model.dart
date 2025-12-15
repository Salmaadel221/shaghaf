class RoofModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final bool isActive;
  final int numOfChairs;
  final double pricePerHour;
  final List<String> images;

  RoofModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.isActive,
    required this.numOfChairs,
    required this.pricePerHour,
    required this.images,
  });

  factory RoofModel.fromJson(Map<String, dynamic> json) {
    return RoofModel(
      id: json['id'] ?? json['_id'] ?? '',
      nameAr: json['name-ar'] ?? json['nameAr'] ?? '',
      nameEn: json['name-en'] ?? json['nameEn'] ?? '',
      descriptionAr: json['description-ar'] ?? json['descriptionAr'] ?? '',
      descriptionEn: json['description-en'] ?? json['descriptionEn'] ?? '',
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      numOfChairs: json['num_of_chair'] ?? json['numOfChairs'] ?? 0,
      pricePerHour: (json['price_per_hour'] ?? json['pricePerHour'] ?? 0)
          .toDouble(),
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name-ar': nameAr,
      'name-en': nameEn,
      'description-ar': descriptionAr,
      'description-en': descriptionEn,
      'is_active': isActive,
      'num_of_chair': numOfChairs,
      'price_per_hour': pricePerHour,
      'images': images,
    };
  }
}
