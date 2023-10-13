import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../db_functions.dart';
import '../../models/player_session.dart';
import '../../models/spell.dart';
import '../../provider.dart';

class MeterScreen extends HookConsumerWidget {
  const MeterScreen({
    super.key,
    required this.playerSession,
  });

  final PlayerSession playerSession;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initFunction = useCallback((_) async {
      List<Spell> allSpells = await getAllSpells();
      ref.read(allSpellsProvider.notifier).clearAll();
      ref.read(campaignSpellsProvider.notifier).clearAll();
      for (var spell in allSpells) {
        if (spell.availableCampaigns.contains(playerSession.id)) {
          ref
              .read(campaignSpellsProvider.notifier)
              .addSpell(spell, playerSession);
        } else {
          ref.read(allSpellsProvider.notifier).addSpell(spell, playerSession);
        }
      }
    }, []);

    useEffect(() {
      initFunction(null);
      return null;
    }, []);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionButtonArea(
          playerSession: playerSession,
          title: 'Damage',
          areaColor: Theme.of(context).colorScheme.tertiary,
          dbButtons: [
            DatabaseActionButton(
                text: 'Thought', value: 2, playerSession: playerSession),
            DatabaseActionButton(
                text: 'Scheme', value: 4, playerSession: playerSession),
            DatabaseActionButton(
                text: 'Machination', value: 8, playerSession: playerSession)
          ],
        ),
        ActionButtonArea(
          playerSession: playerSession,
          title: 'Healing',
          areaColor: Theme.of(context).colorScheme.primary,
          dbButtons: [
            DatabaseActionButton(
                text: 'Thought', value: -2, playerSession: playerSession),
            DatabaseActionButton(
                text: 'Scheme', value: -4, playerSession: playerSession),
            DatabaseActionButton(
                text: 'Machination', value: -8, playerSession: playerSession)
          ],
        ),
      ],
    );
  }
}

class ActionButtonArea extends StatelessWidget {
  final Color areaColor;
  final String title;
  final PlayerSession playerSession;
  final List<Widget> dbButtons;
  const ActionButtonArea(
      {super.key,
      required this.areaColor,
      required this.title,
      required this.dbButtons,
      required this.playerSession});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
            color: areaColor, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
              Wrap(children: dbButtons),
            ],
          ),
        ),
      ),
    );
  }
}

class DatabaseActionButton extends ConsumerWidget {
  final String text;
  final int value;
  final PlayerSession playerSession;
  const DatabaseActionButton(
      {super.key,
      required this.text,
      required this.value,
      required this.playerSession});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
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
          Random random = Random();
          int roll = random.nextInt(value.abs()) + 1;
          if (value < 0) {
            roll = roll * -1;
          }
          updateSessionMadnessValue(playerSession.id, roll, ref);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            width: 120,
            child: Center(
              child: Text(
                '$text\n(d${value.abs()})',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
