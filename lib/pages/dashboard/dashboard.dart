import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:madness_meter_dashboard/main.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';
import 'package:madness_meter_dashboard/provider.dart';

import 'meter_screen.dart';
import 'nav.dart';
import 'spell_screen.dart';

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
                  SingleChildScrollView(
                      child: dashboardScreen(playerSession, ref)),
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
