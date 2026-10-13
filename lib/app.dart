import 'package:flutter/material.dart';

import 'UILibrary/View/Pages/RootShell.dart';
import 'UILibrary/View/Theme/AppTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BaseSDK/Data/DataSources/BookingLocalDataSource.dart';
import 'BaseSDK/Data/DataSources/ProviderLocalDataSource.dart';
import 'BaseSDK/Data/DataSources/RatingLocalDataSource.dart';
import 'BaseSDK/Data/Repositories/BookingRepositoryImpl.dart';
import 'BaseSDK/Data/Repositories/ProviderRepositoryImpl.dart';
import 'BaseSDK/Domain/Repositories/BookingRepository.dart';
import 'BaseSDK/Domain/Repositories/ProviderRepository.dart';
import 'BaseSDK/Domain/UseCases/AddReviewUseCase.dart';
import 'BaseSDK/Domain/UseCases/CancelBookingUseCase.dart';
import 'BaseSDK/Domain/UseCases/CreateBookingUseCase.dart';
import 'BaseSDK/Domain/UseCases/GetBookingsUseCase.dart';
import 'BaseSDK/Domain/UseCases/GetCategoriesUseCase.dart';
import 'BaseSDK/Domain/UseCases/GetProviderByIdUseCase.dart';
import 'BaseSDK/Domain/UseCases/GetProviderReviewsUseCase.dart';
import 'BaseSDK/Domain/UseCases/GetProvidersUseCase.dart';
import 'BaseSDK/Domain/UseCases/UpdateBookingStatusUseCase.dart';
import 'UILibrary/ViewModel/CategoriesViewModel.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final ProviderLocalDataSource providerLocal =
  ProviderLocalDataSourceImpl();
  final RatingLocalDataSource ratingStore = RatingLocalDataSourceImpl(prefs);
  final BookingLocalDataSource bookingLocal =
  BookingLocalDataSourceImpl(prefs);

  final ProviderRepository providerRepository =
  ProviderRepositoryImpl(providerLocal, ratingStore);
  final BookingRepository bookingRepository =
  BookingRepositoryImpl(bookingLocal);

  final GetCategoriesUseCase getCategories =
  GetCategoriesUseCase(providerRepository);
  final GetProvidersUseCase getProviders =
  GetProvidersUseCase(providerRepository);
  final GetProviderByIdUseCase getProviderById =
  GetProviderByIdUseCase(providerRepository);
  final GetProviderReviewsUseCase getProviderReviews =
  GetProviderReviewsUseCase(bookingRepository);
  final GetBookingsUseCase getBookings = GetBookingsUseCase(bookingRepository);
  final CreateBookingUseCase createBooking =
  CreateBookingUseCase(bookingRepository);
  final CancelBookingUseCase cancelBooking =
  CancelBookingUseCase(bookingRepository);
  final AddReviewUseCase addReview =
  AddReviewUseCase(bookingRepository, providerRepository);
  final UpdateBookingStatusUseCase updateBookingStatus =
  UpdateBookingStatusUseCase(bookingRepository);

  runApp(
    MultiProvider(
      providers: [
        Provider<ProviderRepository>.value(value: providerRepository),
        Provider<BookingRepository>.value(value: bookingRepository),
        Provider<GetCategoriesUseCase>.value(value: getCategories),
        Provider<GetProvidersUseCase>.value(value: getProviders),
        Provider<GetProviderByIdUseCase>.value(value: getProviderById),
        Provider<GetProviderReviewsUseCase>.value(value: getProviderReviews),
        Provider<GetBookingsUseCase>.value(value: getBookings),
        Provider<CreateBookingUseCase>.value(value: createBooking),
        Provider<CancelBookingUseCase>.value(value: cancelBooking),
        Provider<AddReviewUseCase>.value(value: addReview),
        Provider<UpdateBookingStatusUseCase>.value(value: updateBookingStatus),
        ChangeNotifierProvider<CategoriesViewModel>(
          create: (_) => CategoriesViewModel(getCategories),
        ),
      ],
      child: const FixItApp(),
    ),
  );
}
class FixItApp extends StatelessWidget {
  const FixItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixIt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const RootShell(),
    );
  }
}



