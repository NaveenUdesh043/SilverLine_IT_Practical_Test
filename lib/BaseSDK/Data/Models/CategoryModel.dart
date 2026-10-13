import '../../Domain/Entities/service_category.dart';

class CategoryModel {
  const CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] as String,
    name: json['name'] as String,
  );

  final String id;
  final String name;

  ServiceCategory toEntity() => ServiceCategory(id: id, name: name);
}
