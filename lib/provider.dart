import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';

import 'main.dart';
import 'models/spell.dart';

// change this to switch back to other screen for now
class AllPlayerSessionNotifier extends StateNotifier<List<PlayerSession>> {
  AllPlayerSessionNotifier() : super([]);

  updateSessionMadness(int id, int newValue) {
    List<PlayerSession> newState = List.from(state);
    int sessionIndex = newState.indexWhere((element) => element.id == id);
    PlayerSession updatedPlayerSession =
        newState[sessionIndex].copyWith(madnessValue: newValue);
    newState[sessionIndex] = updatedPlayerSession;
    state = newState;
  }
}

final allPlayerSessionsProvider =
    StateNotifierProvider<AllPlayerSessionNotifier, List<PlayerSession>>((ref) {
  return AllPlayerSessionNotifier();
});

final navRailIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final madnessMeterProvider = StateProvider<int>((ref) {
  return 0;
});

class AllSpellsNotifier extends StateNotifier<List<Spell>> {
  AllSpellsNotifier() : super([]);

  Spell addSpell(Spell newSpell, PlayerSession session) {
    List<int> campaignIds = List.from(newSpell.availableCampaigns);
    campaignIds.removeWhere((element) => element == session.id);
    Spell updatedSpell = newSpell.copyWith(availableCampaigns: campaignIds);
    if (!state.contains(updatedSpell)) state = [...state, updatedSpell];
    return updatedSpell;
  }

  void clearAll() {
    state = [];
  }

  void removeSpell(int spellId) {
    state.removeWhere((spell) => spell.id == spellId);
    state = state;
  }

  void addSpellToCampaign(
      Spell spell, WidgetRef ref, PlayerSession session) async {
    if (!spell.availableCampaigns.contains(session.id)) {
      Spell updatedSpell =
          ref.read(campaignSpellsProvider.notifier).addSpell(spell, session);
      removeSpell(spell.id);

      await supabase.from('madness_spells').update({
        'available_campaigns': updatedSpell.availableCampaigns,
      }).eq('id', spell.id);
    }
  }
}

final allSpellsProvider =
    StateNotifierProvider<AllSpellsNotifier, List<Spell>>((ref) {
  return AllSpellsNotifier();
});

class InCampaignSpellNotifier extends StateNotifier<List<Spell>> {
  InCampaignSpellNotifier() : super([]);

  Spell addSpell(Spell newSpell, PlayerSession session) {
    Spell updatedSpell = newSpell.copyWith(
        availableCampaigns: [...newSpell.availableCampaigns, session.id]);
    if (!state.contains(updatedSpell)) state = [...state, updatedSpell];
    return updatedSpell;
  }

  void removeSpell(int spellId) {
    state.removeWhere((spell) => spell.id == spellId);
    state = state;
  }

  void clearAll() {
    state = [];
  }

  void removeSpellFromCampaign(
      Spell spell, WidgetRef ref, PlayerSession session) async {
    if (spell.availableCampaigns.contains(session.id)) {
      Spell updatedSpell =
          ref.read(allSpellsProvider.notifier).addSpell(spell, session);
      removeSpell(spell.id);

      await supabase.from('madness_spells').update({
        'available_campaigns': updatedSpell.availableCampaigns,
      }).eq('id', spell.id);
    }
  }
}

final campaignSpellsProvider =
    StateNotifierProvider<InCampaignSpellNotifier, List<Spell>>((ref) {
  return InCampaignSpellNotifier();
});
