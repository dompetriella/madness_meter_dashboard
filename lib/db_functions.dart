import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madness_meter_dashboard/main.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';
import 'package:madness_meter_dashboard/provider.dart';

Future<PlayerSession> getSessionById(int id) async {
  final List<dynamic> session =
      await supabase.from('player_session').select('*').eq('id', id);
  PlayerSession idSession = PlayerSession.fromJson(session.firstOrNull);
  return idSession;
}

Future<PlayerSession> getSessionIdByName(String campaignName) async {
  final List<dynamic> session = await supabase
      .from('player_session')
      .select('*')
      .eq('campaign_Name', campaignName);
  PlayerSession idSession = PlayerSession.fromJson(session.firstOrNull);
  return idSession;
}

Future<int> getSessionMadness(int id) async {
  final List<dynamic> session =
      await supabase.from('player_session').select('*').eq('id', id);
  PlayerSession idSession = PlayerSession.fromJson(session.firstOrNull);
  return idSession.madnessValue;
}

void updateSessionMadnessValue(int id, int changeAmount) async {
  int currentValue = await getSessionMadness(id);
  int newValue =
      currentValue + changeAmount < 0 ? 0 : currentValue + changeAmount;
  await supabase.from('player_session').update({
    'madness_value': newValue,
  }).eq('id', id);
}

void addPlayerSessionsToState(WidgetRef ref) async {
  final List<dynamic> data = await supabase.from('player_session').select('*');
  final List<PlayerSession> playerSessions =
      data.map((e) => PlayerSession.fromJson(e)).toList();
  playerSessions.sort((a, b) => a.id.compareTo(b.id));
  ref.read(allPlayerSessionsProvider.notifier).state = playerSessions;
}

Future<List<PlayerSession>> getPlayerSessions() async {
  final List<dynamic> data = await supabase.from('player_session').select('*');
  final List<PlayerSession> playerSessions =
      data.map((e) => PlayerSession.fromJson(e)).toList();
  playerSessions.sort((a, b) => a.id.compareTo(b.id));
  return playerSessions;
}
