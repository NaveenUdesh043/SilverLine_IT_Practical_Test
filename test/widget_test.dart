import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:silverline_it_practical_test/BaseSDK/Data/DataSources/counter_local_data_source.dart';
import 'package:silverline_it_practical_test/BaseSDK/Data/Repositories/counter_repository_impl.dart';
import 'package:silverline_it_practical_test/BaseSDK/Domain/UseCases/get_counter_use_case.dart';
import 'package:silverline_it_practical_test/BaseSDK/Domain/UseCases/increment_counter_use_case.dart';
import 'package:silverline_it_practical_test/UILibrary/View/Pages/HomeScreen.dart';
import 'package:silverline_it_practical_test/UILibrary/ViewModel/HomeViewModel.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final repository = CounterRepositoryImpl(CounterLocalDataSource());
    final viewModel = HomeViewModel(
      getCounter: GetCounterUseCase(repository),
      incrementCounter: IncrementCounterUseCase(repository),
    );

    await tester.pumpWidget(
      MaterialApp(home: HomePage(viewModel: viewModel)),
    );

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
