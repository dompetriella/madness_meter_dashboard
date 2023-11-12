import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:madness_meter_dashboard/models/spellEnum.dart';
import 'package:madness_meter_dashboard/provider.dart';

import '../../models/player_session.dart';
import '../../models/spell.dart';

class SpellsScreen extends HookConsumerWidget {
  final PlayerSession playerSession;
  const SpellsScreen({super.key, required this.playerSession});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'In Database',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white),
              ),
              Text(
                'In Campaign',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DragTarget<Spell>(
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (Spell data) {
                  ref
                      .read(campaignSpellsProvider.notifier)
                      .removeSpellFromCampaign(data, ref, playerSession);
                },
                builder: (context, candidateData, rejectedData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .4,
                      constraints: const BoxConstraints(minHeight: 300),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: ref
                            .watch(allSpellsProvider)
                            .map((e) => ContainsSpellButton(
                                spell: e, playerSession: playerSession))
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: 10,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              DragTarget<Spell>(
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (Spell data) {
                  ref
                      .read(allSpellsProvider.notifier)
                      .addSpellToCampaign(data, ref, playerSession);
                },
                builder: (context, candidateData, rejectedData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .4,
                      constraints: const BoxConstraints(minHeight: 300),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: ref
                            .watch(campaignSpellsProvider)
                            .map((e) => ContainsSpellButton(
                                spell: e, playerSession: playerSession))
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContainsSpellButton extends StatelessWidget {
  final Spell spell;
  final PlayerSession playerSession;
  const ContainsSpellButton(
      {super.key, required this.spell, required this.playerSession});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Draggable<Spell>(
        feedback: DraggableSpell(spell: spell),
        data: spell,
        childWhenDragging: Container(
          width: 165,
          height: 115,
          decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10)),
        ),
        child: DraggableSpell(spell: spell),
      ),
    );
  }
}

class DraggableSpell extends StatelessWidget {
  const DraggableSpell({
    super.key,
    required this.spell,
  });

  final Spell spell;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.tertiary.withOpacity(.25),
          elevation: 10,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(.5),
                  width: 3),
              borderRadius: BorderRadius.circular(20))),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.grey.shade900,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spell.spellName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Type: ${SpellEnum.values[spell.spellType].name}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                content: Builder(builder: (context) {
                  return SingleChildScrollView(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(.5),
                              borderRadius: BorderRadius.circular(5)),
                          height: 350,
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              spell.description,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )));
                }),
              ).animate().scale(duration: 200.ms).slideY(begin: 0.3);
            });
      },
      onLongPress: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100, minHeight: 100),
          child: Center(
            child: Text(
              spell.spellName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
