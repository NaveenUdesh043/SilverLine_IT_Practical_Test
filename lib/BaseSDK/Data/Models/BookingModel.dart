class BookingModel {
  const BookingModel({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.categoryId,
    required this.serviceName,
    required this.date,
    required this.timeSlot,
    required this.address,
    required this.phone,
    required this.notes,
    required this.hours,
    required this.hourlyRate,
    required this.status,
    required this.createdAt,
    required this.reviewed,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    id: json['id'] as String,
    providerId: json['providerId'] as String,
    providerName: json['providerName'] as String,
    categoryId: json['categoryId'] as String,
    serviceName: json['serviceName'] as String? ?? '',
    date: DateTime.parse(json['date'] as String),
    timeSlot: json['timeSlot'] as String,
    address: json['address'] as String,
    phone: json['phone'] as String,
    notes: json['notes'] as String? ?? '',
    hours: (json['hours'] as num).toInt(),
    hourlyRate: (json['hourlyRate'] as num).toDouble(),
    status: BookingStatus.values.firstWhere(
          (status) => status.name == json['status'],
      orElse: () => BookingStatus.pending,
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
    reviewed: json['reviewed'] as bool? ?? false,
  );

  factory BookingModel.fromEntity(Booking booking) => BookingModel(
    id: booking.id,
    providerId: booking.providerId,
    providerName: booking.providerName,
    categoryId: booking.categoryId,
    serviceName: booking.serviceName,
    date: booking.date,
    timeSlot: booking.timeSlot,
    address: booking.address,
    phone: booking.phone,
    notes: booking.notes,
    hours: booking.hours,
    hourlyRate: booking.hourlyRate,
    status: booking.status,
    createdAt: booking.createdAt,
    reviewed: booking.reviewed,
  );

  final String id;
  final String providerId;
  final String providerName;
  final String categoryId;
  final String serviceName;
  final DateTime date;
  final String timeSlot;
  final String address;
  final String phone;
  final String notes;
  final int hours;
  final double hourlyRate;
  final BookingStatus status;
  final DateTime createdAt;
  final bool reviewed;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'providerId': providerId,
    'providerName': providerName,
    'categoryId': categoryId,
    'serviceName': serviceName,
    'date': date.toIso8601String(),
    'timeSlot': timeSlot,
    'address': address,
    'phone': phone,
    'notes': notes,
    'hours': hours,
    'hourlyRate': hourlyRate,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'reviewed': reviewed,
  };

  Booking toEntity() => Booking(
    id: id,
    providerId: providerId,
    providerName: providerName,
    categoryId: categoryId,
    serviceName: serviceName,
    date: date,
    timeSlot: timeSlot,
    address: address,
    phone: phone,
    notes: notes,
    hours: hours,
    hourlyRate: hourlyRate,
    status: status,
    createdAt: createdAt,
    reviewed: reviewed,
  );
}
