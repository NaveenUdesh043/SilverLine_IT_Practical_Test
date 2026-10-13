import 'package:flutter/material.dart';

import 'BaseSDK/Core/Constants/app_constants.dart';
import 'BaseSDK/Core/Theme/app_theme.dart';
import 'BaseSDK/Data/DataSources/counter_local_data_source.dart';
import 'BaseSDK/Data/Repositories/counter_repository_impl.dart';
import 'BaseSDK/Domain/UseCases/get_counter_use_case.dart';
import 'BaseSDK/Domain/UseCases/increment_counter_use_case.dart';
import 'UILibrary/View/Pages/HomeScreen.dart';
import 'UILibrary/ViewModel/HomeViewModel.dart';

void main() {
  final localDataSource = CounterLocalDataSource();
  final repository = CounterRepositoryImpl(localDataSource);

  final homeViewModel = HomeViewModel(
    getCounter: GetCounterUseCase(repository),
    incrementCounter: IncrementCounterUseCase(repository),
  );

  runApp(SilverlineApp(homeViewModel: homeViewModel));
}

class SilverlineApp extends StatelessWidget {
  const SilverlineApp({super.key, required this.homeViewModel});

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomePage(viewModel: homeViewModel),
    );
  }
}
