
import '../../BaseSDK/Core/AppFailure.dart';
import '../../BaseSDK/Core/UseCase.dart';
import '../../BaseSDK/Domain/Entities/Booking.dart';
import '../../BaseSDK/Domain/UseCases/AddReviewUseCase.dart';
import '../../BaseSDK/Domain/UseCases/CancelBookingUseCase.dart';
import '../../BaseSDK/Domain/UseCases/GetBookingsUseCase.dart';
import 'BaseViewModel.dart';


class MyBookingsViewModel extends BaseViewModel {
  MyBookingsViewModel(
      this._getBookings,
      this._cancelBooking,
      this._addReview, {
        DateTime Function()? now,
      }) : _now = now ?? DateTime.now;

  final GetBookingsUseCase _getBookings;
  final CancelBookingUseCase _cancelBooking;
  final AddReviewUseCase _addReview;
  final DateTime Function() _now;

  List<Booking> _bookings = <Booking>[];
  bool _isMutating = false;

  List<Booking> get bookings => List<Booking>.unmodifiable(_bookings);
  List<Booking> get upcoming =>
      _bookings.where((b) => b.status.isUpcoming).toList(growable: false);
  List<Booking> get history =>
      _bookings.where((b) => b.status.isHistory).toList(growable: false);
  bool get isMutating => _isMutating;

  bool canCancel(Booking booking) => booking.canBeCancelled(_now());

  Future<void> load() async {
    setStatus(ViewStatus.loading);
    try {
      _bookings = await _getBookings(const NoParams());
      setStatus(ViewStatus.success);
    } catch (error) {
      setStatus(ViewStatus.error, error: messageFor(error));
    }
  }

  Future<String?> cancel(String bookingId) async {
    _isMutating = true;
    notifyListeners();
    try {
      await _cancelBooking(bookingId);
      await _reload();
      return null;
    } on AppFailure catch (failure) {
      return failure.message;
    } catch (_) {
      return 'Could not cancel the booking. Please try again.';
    } finally {
      _isMutating = false;
      notifyListeners();
    }
  }

  Future<String?> submitReview({
    required String bookingId,
    required String providerId,
    required double rating,
    required String comment,
  }) async {
    _isMutating = true;
    notifyListeners();
    try {
      await _addReview(
        AddReview(
          bookingId: bookingId,
          providerId: providerId,
          rating: rating,
          comment: comment,
        ),
      );
      await _reload();
      return null;
    } on AppFailure catch (failure) {
      return failure.message;
    } catch (_) {
      return 'Could not submit the review. Please try again.';
    } finally {
      _isMutating = false;
      notifyListeners();
    }
  }

  Future<void> _reload() async {
    _bookings = await _getBookings(const NoParams());
  }
}
