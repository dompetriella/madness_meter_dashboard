import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';

import 'models/spell.dart';

// change this to switch back to other screen for now
final allPlayerSessionsProvider = StateProvider<List<PlayerSession>>((ref) {
  return [];
});

final playerSessionProvider = StateProvider<PlayerSession?>((ref) {
  return null;
});

final navRailIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final visualMadnessProvider = StateProvider<int>((ref) {
  return 0;
});

class AllSpellsNotifier extends StateNotifier<List<Spell>> {
  AllSpellsNotifier()
      : super([
          Spell(
              id: 1,
              createdAt: DateTime.now(),
              spellName: 'Spell 1',
              description: 'This is a description of Spell 1',
              spellType: 0,
              availableCampaigns: [0]),
          Spell(
              id: 2,
              createdAt: DateTime.now(),
              spellName: 'Spell 2',
              description: 'This is a description of Spell 1',
              spellType: 0,
              availableCampaigns: [0]),
        ]);

  void addSpell(Spell newSpell) {
    if (!state.contains(newSpell)) state = [...state, newSpell];
  }

  void removeSpell(int spellId) {
    state.removeWhere((spell) => spell.id == spellId);
    state = state;
  }

  void addSpellToCampaign(Spell spell, WidgetRef ref) {
    ref.read(campaignSpellsProvider.notifier).addSpell(spell);
    removeSpell(spell.id);
  }
}

final allSpellsProvider =
    StateNotifierProvider<AllSpellsNotifier, List<Spell>>((ref) {
  return AllSpellsNotifier();
});

class InCampaignSpellNotifier extends StateNotifier<List<Spell>> {
  InCampaignSpellNotifier()
      : super([
          Spell(
              id: 3,
              createdAt: DateTime.now(),
              spellName: 'Spell 3',
              description: 'This is a description of Spell 1',
              spellType: 0,
              availableCampaigns: [0]),
          Spell(
              id: 4,
              createdAt: DateTime.now(),
              spellName: 'Spell 4',
              description: 'This is a description of Spell 1',
              spellType: 0,
              availableCampaigns: [0]),
        ]);

  void addSpell(Spell newSpell) {
    if (!state.contains(newSpell)) state = [...state, newSpell];
  }

  void removeSpell(int spellId) {
    state.removeWhere((spell) => spell.id == spellId);
    state = state;
  }

  void removeSpellFromCampaign(Spell spell, WidgetRef ref) {
    ref.read(allSpellsProvider.notifier).addSpell(spell);
    removeSpell(spell.id);
  }
}

final campaignSpellsProvider =
    StateNotifierProvider<InCampaignSpellNotifier, List<Spell>>((ref) {
  return InCampaignSpellNotifier();
});
