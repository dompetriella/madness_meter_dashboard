import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';

// change this to switch back to other screen for now
final allPlayerSessionsProvider = StateProvider<List<PlayerSession>>((ref) {
  return [];
});

final playerSessionrovider = StateProvider<PlayerSession?>((ref) {
  return null;
});

final navRailIndexProvider = StateProvider<int>((ref) {
  return 0;
});
