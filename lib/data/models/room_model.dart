class RoomModel {
  final String id;
  final List<String> images;
  final String nameEn;
  final String nameAr;
  final double pricePerHour;
  final List<String> availableHours;

  RoomModel({
    required this.id,
    required this.images,
    required this.nameEn,
    required this.nameAr,
    required this.pricePerHour,
    required this.availableHours,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    // helpers
    String pickString(List<String> keys) {
      for (final k in keys) {
        if (json.containsKey(k) && json[k] != null) {
          final v = json[k];
          if (v is String) return v;
          if (v is num) return v.toString();
        }
      }
      return '';
    }

    double pickDouble(List<String> keys) {
      for (final k in keys) {
        if (json.containsKey(k) && json[k] != null) {
          final v = json[k];
          if (v is num) return v.toDouble();
          if (v is String) {
            final parsed = double.tryParse(v);
            if (parsed != null) return parsed;
          }
        }
      }
      return 0.0;
    }

    List<String> pickImages(dynamic val) {
      if (val == null) return [];
      if (val is String) return [val];
      if (val is List) return val.map((e) => e.toString()).toList();
      return [];
    }

    final imagesVal = json['images'] ?? json['image'] ?? json['imageUrl'];
    final imagesList = pickImages(imagesVal);

    final hoursVal =
        json['availableHours'] ?? json['available_hours'] ?? json['hours'];
    List<String> hours = [];
    if (hoursVal is List) hours = hoursVal.map((e) => e.toString()).toList();

    return RoomModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      images: imagesList,
      nameEn: pickString(['name-en', 'nameEn', 'name', 'title']),
      nameAr: pickString(['name-ar', 'nameAr', 'name_ar']),
      pricePerHour: pickDouble([
        'price_per_hour',
        'pricePerHour',
        'price',
        'price_perHour',
      ]),
      availableHours: hours,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images,
      'name-en': nameEn,
      'name-ar': nameAr,
      'price_per_hour': pricePerHour,
      'availableHours': availableHours,
    };
  }
}
