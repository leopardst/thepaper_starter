import 'dart:ui';

import 'package:meta/meta.dart';

class Job {
  Job({required this.id, required this.name, required this.ratePerHour});
  final String id;
  final String? name;
  final int? ratePerHour;

}
