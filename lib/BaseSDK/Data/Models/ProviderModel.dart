
class ProviderModel {
  const ProviderModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.rating,
    required this.reviewCount,
    required this.completedJobs,
    required this.experienceYears,
    required this.hourlyRate,
    required this.location,
    required this.isAvailable,
    required this.description,
    required this.skills,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
    id: json['id'] as String,
    name: json['name'] as String,
    categoryId: json['categoryId'] as String,
    rating: (json['rating'] as num).toDouble(),
    reviewCount: (json['reviewCount'] as num).toInt(),
    completedJobs: (json['completedJobs'] as num).toInt(),
    experienceYears: (json['experienceYears'] as num).toInt(),
    hourlyRate: (json['hourlyRate'] as num).toDouble(),
    location: json['location'] as String,
    isAvailable: json['isAvailable'] as bool,
    description: json['description'] as String? ?? '',
    skills: (json['skills'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(growable: false) ??
        const <String>[],
  );

  final String id;
  final String name;
  final String categoryId;
  final double rating;
  final int reviewCount;
  final int completedJobs;
  final int experienceYears;
  final double hourlyRate;
  final String location;
  final bool isAvailable;
  final String description;
  final List<String> skills;

  ServiceProvider toEntity() => ServiceProvider(
    id: id,
    name: name,
    categoryId: categoryId,
    rating: rating,
    reviewCount: reviewCount,
    completedJobs: completedJobs,
    experienceYears: experienceYears,
    hourlyRate: hourlyRate,
    location: location,
    isAvailable: isAvailable,
    description: description,
    skills: skills,
  );
}
