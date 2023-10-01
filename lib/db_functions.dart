import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madness_meter_dashboard/main.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';
import 'package:madness_meter_dashboard/provider.dart';

Future<int> retrieveSessionIdByName(String campaignName) async {
  final List<dynamic> sessionId = await supabase
      .from('player_session')
      .select('id')
      .eq('campaign_name', campaignName.toLowerCase());
  return sessionId.first['id'];
}

void retrievePlayerSessions(WidgetRef ref) async {
  final List<dynamic> data = await supabase.from('player_session').select('*');
  final List<PlayerSession> playerSessions =
      data.map((e) => PlayerSession.fromJson(e)).toList();
  ref.read(allPlayerSessionsProvider.notifier).state = playerSessions;
}
