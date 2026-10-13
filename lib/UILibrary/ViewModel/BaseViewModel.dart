import 'package:flutter/foundation.dart';

import '../../BaseSDK/Core/AppFailure.dart';


enum ViewStatus { idle, loading, success, error }
abstract class BaseViewModel extends ChangeNotifier {
  ViewStatus _status = ViewStatus.idle;
  String? _errorMessage;

  ViewStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ViewStatus.loading;
  bool get isIdle => _status == ViewStatus.idle;
  bool get isSuccess => _status == ViewStatus.success;
  bool get hasError => _status == ViewStatus.error;

  @protected
  void setStatus(ViewStatus status, {String? error}) {
    _status = status;
    _errorMessage = error;
    notifyListeners();
  }

  @protected
  String messageFor(Object error) {
    if (error is AppFailure) return error.message;
    return 'Something went wrong. Please try again.';
  }
}
