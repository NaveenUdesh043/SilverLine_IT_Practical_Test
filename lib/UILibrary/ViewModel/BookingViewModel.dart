
import '../../BaseSDK/Core/AppConstants.dart';
import '../../BaseSDK/Core/Validations.dart';
import '../../BaseSDK/Domain/Entities/Booking.dart';
import '../../BaseSDK/Domain/Entities/ServiceProvider.dart';
import '../../BaseSDK/Domain/UseCases/CreateBookingUseCase.dart';
import 'BaseViewModel.dart';

class BookingViewModel extends BaseViewModel {
  BookingViewModel(this._createBooking);

  final CreateBookingUseCase _createBooking;

  String address = '';
  String phone = '';
  DateTime? date;
  String? timeSlot;
  int hours = 2;
  String notes = '';

  final Map<String, String> _errors = <String, String>{};

  String? errorFor(String field) => _errors[field];

  void setAddress(String value) => _set(() => address = value, 'address');
  void setPhone(String value) => _set(() => phone = value, 'phone');
  void setTimeSlot(String value) => _set(() => timeSlot = value, 'timeSlot');
  void setNotes(String value) => _set(() => notes = value, 'notes');
  void setDate(DateTime value) => _set(() => date = value, 'date');
  void setHours(int value) => _set(() => hours = value, 'hours');

  void _set(void Function() apply, String field) {
    apply();
    _errors.remove(field);
    notifyListeners();
  }

  double totalCost(ServiceProvider provider) => provider.hourlyRate * hours;

  bool validate(DateTime now) {
    _errors.clear();
    void check(String field, String? message) {
      if (message != null) _errors[field] = message;
    }

    check('address', Validations.address(address));
    check('phone', Validations.phone(phone));
    check('date', Validations.bookingDate(date, now));
    check('timeSlot', Validations.timeSlot(timeSlot));
    check('hours', Validations.bookingHours(hours));
    notifyListeners();
    return _errors.isEmpty;
  }

  Future<Booking?> submit({
    required ServiceProvider provider,
    required String serviceName,
    required DateTime now,
  }) async {
    if (!validate(now)) return null;
    setStatus(ViewStatus.loading);
    try {
      final Booking booking = await _createBooking(
        CreateBooking(
          providerId: provider.id,
          providerName: provider.name,
          categoryId: provider.categoryId,
          serviceName: serviceName,
          date: date!,
          timeSlot: timeSlot!,
          address: address.trim(),
          phone: phone.trim(),
          notes: notes.trim(),
          hours: hours,
          hourlyRate: provider.hourlyRate,
        ),
      );
      setStatus(ViewStatus.success);
      return booking;
    } catch (error) {
      setStatus(ViewStatus.error, error: messageFor(error));
      return null;
    }
  }

  int get minHours => AppConstants.minBookingHours;
  int get maxHours => AppConstants.maxBookingHours;
}
