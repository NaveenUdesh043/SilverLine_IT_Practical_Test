import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

import '../../Core/AppConstants.dart';
import '../../Core/AppFailure.dart';

abstract class ProviderLocalDataSource {
  Future<List<CategoryModel>> fetchCategories();

  Future<List<ProviderModel>> fetchProviders();
}

class ProviderLocalDataSourceImpl implements ProviderLocalDataSource {
  ProviderLocalDataSourceImpl({
    AssetBundle? bundle,
    Random? random,
    this.minDelay = AppConstants.minNetworkDelay,
    this.maxDelay = AppConstants.maxNetworkDelay,
    this.failureRate = AppConstants.failureRate,
  })  : _bundle = bundle ?? rootBundle,
        _random = random ?? Random();

  final AssetBundle _bundle;
  final Random _random;
  final Duration minDelay;
  final Duration maxDelay;
  final double failureRate;

  Map<String, dynamic>? _cache;

  Future<Map<String, dynamic>> _loadAsset() async {
    if (_cache != null) return _cache!;
    try {
      final String raw =
      await _bundle.loadString(AppConstants.providersAssetPath);
      _cache = jsonDecode(raw) as Map<String, dynamic>;
      return _cache!;
    } catch (_) {
      throw const StorageFailure('Could not load provider data.');
    }
  }

  /// Simulates an unreliable network: random 800-1500ms delay and ~20% failure.
  Future<void> _simulateNetwork() async {
    final int span = maxDelay.inMilliseconds - minDelay.inMilliseconds;
    final int delay =
        minDelay.inMilliseconds + (span > 0 ? _random.nextInt(span + 1) : 0);
    await Future<void>.delayed(Duration(milliseconds: delay));
    if (_random.nextDouble() < failureRate) {
      throw const NetworkFailure();
    }
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    await _simulateNetwork();
    final Map<String, dynamic> data = await _loadAsset();
    final List<dynamic> categories = data['categories'] as List<dynamic>? ?? [];
    return categories
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<List<ProviderModel>> fetchProviders() async {
    await _simulateNetwork();
    final Map<String, dynamic> data = await _loadAsset();
    final List<dynamic> providers = data['providers'] as List<dynamic>? ?? [];
    return providers
        .map((e) => ProviderModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }
}
