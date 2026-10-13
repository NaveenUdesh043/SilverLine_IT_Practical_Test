class ServiceProvider {
  const ServiceProvider({
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

  ServiceProvider copyWith({
    double? rating,
    int? reviewCount,
    bool? isAvailable,
  }) {
    return ServiceProvider(
      id: id,
      name: name,
      categoryId: categoryId,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      completedJobs: completedJobs,
      experienceYears: experienceYears,
      hourlyRate: hourlyRate,
      location: location,
      isAvailable: isAvailable ?? this.isAvailable,
      description: description,
      skills: skills,
    );
  }
}
