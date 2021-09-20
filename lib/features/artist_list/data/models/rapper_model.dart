import '../../domain/entities/rapper.dart';

/// A data model representing raw unprocessed rapper person data.
class RapperModel extends Rapper {
  RapperModel(
      {required id, required name, required description, required image})
      : super(id: id, name: name, description: description, image: image);

  factory RapperModel.fromJson(Map<String, dynamic> json) {
    return RapperModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image']);
  }

  /// Used to convert rapper person data for storage in the cache.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }
}
