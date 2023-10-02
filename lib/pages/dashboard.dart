import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';
import 'package:madness_meter_dashboard/provider.dart';

class Dashboard extends StatelessWidget {
  final PlayerSession playerSession;
  const Dashboard({super.key, required this.playerSession});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavRail(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Wrap(
                children: [DatabaseActionButton()],
              ),
            ),
          ),
        ],
      ),
    ));
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
      color: Theme.of(context).colorScheme.onBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
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
  const DatabaseActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.secondary.withOpacity(.25),
            elevation: 10,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color:
                        Theme.of(context).colorScheme.onPrimary.withOpacity(.5),
                    width: 3),
                borderRadius: BorderRadius.circular(20))),
        onPressed: () {},
        child: SizedBox(
          height: 100,
          width: 170,
        ),
      ),
    );
  }
}
