import 'package:equatable/equatable.dart';

/// Representation of a single rapper person entity.
class Rapper extends Equatable {
  Rapper(
      {required this.id,
      required this.name,
      required this.description,
      required this.image});

  final String id;
  final String name;
  final String description;
  final String image;

  @override
  List<Object?> get props => [id, name, description, image];
}
