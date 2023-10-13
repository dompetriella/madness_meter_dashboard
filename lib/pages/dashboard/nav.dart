import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madness_meter_dashboard/db_functions.dart';

import '../../provider.dart';

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
                ref.read(navRailIndexProvider.notifier).state = 0;
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
          const NavRailDestination(
            icon: Icons.dashboard,
            index: 0,
            text: 'Meter',
          ),
          const NavRailDestination(
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
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
