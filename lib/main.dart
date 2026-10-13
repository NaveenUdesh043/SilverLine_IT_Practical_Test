import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:silverline_it_practical_test/BaseSDK/Core/AppConstants.dart';

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
