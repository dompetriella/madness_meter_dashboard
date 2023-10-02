import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:madness_meter_dashboard/db_functions.dart';
import 'package:madness_meter_dashboard/main.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';
import 'package:madness_meter_dashboard/provider.dart';

final PageController pageController = PageController();

class Dashboard extends HookConsumerWidget {
  final PlayerSession playerSession;
  const Dashboard({super.key, required this.playerSession});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      try {
        final stream = supabase
            .from('player_session')
            .stream(primaryKey: ["id"]).eq('id', playerSession.id);
        stream.listen((data) {
          PlayerSession session = PlayerSession.fromJson(data.first);
          ref.read(visualMadnessProvider.notifier).state = session.madnessValue;
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ' + e.toString())));
      }
      return null;
    }, const []);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavRail(),
          Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Campaign: ${playerSession.campaignName.toUpperCase()}',
                            style: TextStyle(
                                fontSize: 24,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                          Row(
                            children: [
                              Text(
                                'Current Madness: ${ref.watch(visualMadnessProvider)} / ${playerSession.maxMadnessValue}',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                              ),
                              SizedBox(
                                width: 24,
                              ),
                              Container(
                                height: 40,
                                width: 300,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: AnimatedFractionallySizedBox(
                                    duration: 300.ms,
                                    alignment: Alignment.centerLeft,
                                    widthFactor:
                                        ref.watch(visualMadnessProvider) /
                                            playerSession.maxMadnessValue,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8))),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        ActionButtonArea(
                          playerSession: playerSession,
                          title: 'Damage',
                          areaColor: Theme.of(context).colorScheme.tertiary,
                          dbButtons: [
                            DatabaseActionButton(
                                text: 'Thought',
                                value: 2,
                                playerSession: playerSession),
                            DatabaseActionButton(
                                text: 'Scheme',
                                value: 4,
                                playerSession: playerSession),
                            DatabaseActionButton(
                                text: 'Machination',
                                value: 8,
                                playerSession: playerSession)
                          ],
                        ),
                        ActionButtonArea(
                          playerSession: playerSession,
                          title: 'Healing',
                          areaColor: Theme.of(context).colorScheme.primary,
                          dbButtons: [
                            DatabaseActionButton(
                                text: 'Thought',
                                value: -2,
                                playerSession: playerSession),
                            DatabaseActionButton(
                                text: 'Scheme',
                                value: -4,
                                playerSession: playerSession),
                            DatabaseActionButton(
                                text: 'Machination',
                                value: -8,
                                playerSession: playerSession)
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
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
            color: areaColor.withOpacity(.75),
            borderRadius: BorderRadius.circular(20)),
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

class NavRail extends ConsumerWidget {
  const NavRail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: double.maxFinite,
      width: 120,
      color: Theme.of(context).colorScheme.onBackground,
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          NavRailDestination(
            icon: Icons.dashboard,
            index: 0,
            text: 'Meter',
          ),
          NavRailDestination(
            icon: Icons.auto_fix_high,
            index: 1,
            text: 'Spells',
          ),
        ],
      ),
    );
  }
}

class NavRailDestination extends ConsumerWidget {
  final int index;
  final IconData icon;
  final String text;
  const NavRailDestination(
      {super.key, required this.icon, required this.index, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ref.read(navRailIndexProvider.notifier).state = index;
        },
        child: Container(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: ref.watch(navRailIndexProvider) == index
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.primary,
                ),
                ref.watch(navRailIndexProvider) == index
                    ? Text(
                        text,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: ref.watch(navRailIndexProvider) == index
                              ? Theme.of(context).colorScheme.onSecondary
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ).animate().slideY(begin: 0.2).fadeIn()
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DatabaseActionButton extends StatelessWidget {
  final String text;
  final int value;
  final PlayerSession playerSession;
  const DatabaseActionButton(
      {super.key,
      required this.text,
      required this.value,
      required this.playerSession});

  @override
  Widget build(BuildContext context) {
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
          updateSessionMadnessValue(playerSession.id, roll);
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
