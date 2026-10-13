
import '../../BaseSDK/Core/AppFailure.dart';
import '../../BaseSDK/Core/UseCase.dart';
import '../../BaseSDK/Domain/Entities/Booking.dart';
import '../../BaseSDK/Domain/Entities/BookingStatus.dart';
import '../../BaseSDK/Domain/UseCases/GetBookingsUseCase.dart';
import '../../BaseSDK/Domain/UseCases/UpdateBookingStatusUseCase.dart';
import 'BaseViewModel.dart';

class ProviderJobsViewModel extends BaseViewModel {
  ProviderJobsViewModel(this._getBookings, this._updateStatus);

  final GetBookingsUseCase _getBookings;
  final UpdateBookingStatusUseCase _updateStatus;

  List<Booking> _jobs = <Booking>[];
  bool _isMutating = false;

  List<Booking> get jobs => List<Booking>.unmodifiable(_jobs);
  List<Booking> get newRequests => _jobs
      .where((b) => b.status == BookingStatus.pending)
      .toList(growable: false);
  List<Booking> get active => _jobs
      .where((b) =>
  b.status == BookingStatus.confirmed ||
      b.status == BookingStatus.inProgress)
      .toList(growable: false);
  List<Booking> get finished => _jobs
      .where((b) =>
  b.status == BookingStatus.completed ||
      b.status == BookingStatus.rejected ||
      b.status == BookingStatus.cancelled)
      .toList(growable: false);
  bool get isMutating => _isMutating;

  Future<void> load() async {
    setStatus(ViewStatus.loading);
    try {
      _jobs = await _getBookings(const NoParams());
      setStatus(ViewStatus.success);
    } catch (error) {
      setStatus(ViewStatus.error, error: messageFor(error));
    }
  }

  Future<String?> updateStatus(String bookingId, BookingStatus status) async {
    _isMutating = true;
    notifyListeners();
    try {
      await _updateStatus(
        UpdateBookingStatusParams(bookingId: bookingId, status: status),
      );
      _jobs = await _getBookings(const NoParams());
      return null;
    } on AppFailure catch (failure) {
      return failure.message;
    } catch (_) {
      return 'Could not update the job. Please try again.';
    } finally {
      _isMutating = false;
      notifyListeners();
    }
  }
}
