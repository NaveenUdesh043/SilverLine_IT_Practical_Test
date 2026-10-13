import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonVisuals {
  CommonVisuals._();

  static const Map<String, IconData> _icons = <String, IconData>{
    'plumbing': Icons.plumbing_rounded,
    'electrical': Icons.electrical_services_rounded,
    'carpentry': Icons.carpenter_rounded,
    'painting': Icons.format_paint_rounded,
    'ac_repair': Icons.ac_unit_rounded,
    'cleaning': Icons.cleaning_services_rounded,
  };

  static const Map<String, Color> _colors = <String, Color>{
    'plumbing': Color(0xFF2F6FED),
    'electrical': Color(0xFFF5A524),
    'carpentry': Color(0xFF9A5B33),
    'painting': Color(0xFFB34CD9),
    'ac_repair': Color(0xFF0EA5A5),
    'cleaning': Color(0xFF22A06B),
  };

  static IconData iconFor(String categoryId) =>
      _icons[categoryId] ?? Icons.handyman_rounded;

  static Color colorFor(String categoryId) =>
      _colors[categoryId] ?? const Color(0xFF546E7A);

  static const Map<String, String> _names = <String, String>{
    'plumbing': 'Plumbing',
    'electrical': 'Electrical',
    'carpentry': 'Carpentry',
    'painting': 'Painting',
    'ac_repair': 'AC Repair',
    'cleaning': 'Cleaning',
  };

  static String nameFor(String categoryId) =>
      _names[categoryId] ?? 'Service';
}
