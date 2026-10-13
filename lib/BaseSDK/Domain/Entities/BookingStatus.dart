enum BookingStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  inProgress('In Progress'),
  completed('Completed'),
  cancelled('Cancelled'),
  rejected('Rejected');

  const BookingStatus(this.label);

  final String label;

  bool get isUpcoming =>
      this == BookingStatus.pending ||
          this == BookingStatus.confirmed ||
          this == BookingStatus.inProgress;

  bool get isHistory => !isUpcoming;
  bool get canBeCancelledByCustomer =>
      this == BookingStatus.pending || this == BookingStatus.confirmed;
}
