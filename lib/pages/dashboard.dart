import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:madness_meter_dashboard/main.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';
import 'package:madness_meter_dashboard/provider.dart';
import '../db_functions.dart';
import '../models/spell.dart';
import 'dashboard/meter_screen.dart';
import 'dashboard/nav.dart';
import 'dashboard/spell_screen.dart';

final PageController pageController = PageController();

class Dashboard extends HookConsumerWidget {
  final PlayerSession playerSession;
  const Dashboard({super.key, required this.playerSession});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StreamSubscription? streamSubscription;

    final initFunction = useCallback((_) async {
      try {
        final stream = await supabase
            .from('player_session')
            .stream(primaryKey: ["id"]).eq('id', playerSession.id);
        streamSubscription = stream.listen((data) {
          PlayerSession session = PlayerSession.fromJson(data.first);
          ref.read(madnessMeterProvider.notifier).state = session.madnessValue;
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }, []);

    useEffect(() {
      initFunction(null);
      return () {
        streamSubscription?.cancel();
      };
    }, []);

    var isMad = ref.watch(madnessMeterProvider) > playerSession.maxMadnessValue;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NavRail(),
          Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
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
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                        Row(
                          children: [
                            Text(
                              'Current Madness: ${ref.watch(madnessMeterProvider)} / ${playerSession.maxMadnessValue}',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                            ),
                            const SizedBox(
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
                                  widthFactor: isMad
                                      ? 1
                                      : ref.watch(madnessMeterProvider) /
                                          playerSession.maxMadnessValue,
                                  child: AnimatedContainer(
                                    duration: 300.ms,
                                    decoration: BoxDecoration(
                                      color: isMad
                                          ? Colors.red
                                          : Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                    ),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  dashboardScreen(playerSession, ref),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

Widget dashboardScreen(PlayerSession playerSession, WidgetRef ref) {
  switch (ref.watch(navRailIndexProvider)) {
    case 0:
      return MeterScreen(playerSession: playerSession);
    case 1:
      return SpellsScreen(
        playerSession: playerSession,
      );
    default:
      return MeterScreen(playerSession: playerSession);
  }
}
