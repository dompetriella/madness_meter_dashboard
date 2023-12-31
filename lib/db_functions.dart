import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madness_meter_dashboard/main.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';
import 'package:madness_meter_dashboard/provider.dart';

import 'models/spell.dart';

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

void updateSessionMadnessValue(int id, int changeAmount, WidgetRef ref) async {
  int currentValue = ref.watch(madnessMeterProvider);
  int newValue =
      currentValue + changeAmount < 0 ? 0 : currentValue + changeAmount;
  await supabase.from('player_session').update({
    'madness_value': newValue,
  }).eq('id', id);
  ref
      .read(allPlayerSessionsProvider.notifier)
      .updateSessionMadness(id, newValue);
}

void updateSessionMadnessToZero(int id, WidgetRef ref) async {
  await supabase.from('player_session').update({
    'madness_value': 0,
  }).eq('id', id);
  ref.read(allPlayerSessionsProvider.notifier).updateSessionMadness(id, 0);
}

void updateSessionMadnessToMaxValue(
    PlayerSession playerSession, WidgetRef ref) async {
  await supabase.from('player_session').update({
    'madness_value': playerSession.maxMadnessValue,
  }).eq('id', playerSession.id);
  ref
      .read(allPlayerSessionsProvider.notifier)
      .updateSessionMadness(playerSession.id, playerSession.maxMadnessValue);
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

Future<List<Spell>> getAllSpells() async {
  final List<dynamic> allSpells =
      await supabase.from('madness_spells').select();
  return allSpells.map((e) => Spell.fromJson(e)).toList();
}
