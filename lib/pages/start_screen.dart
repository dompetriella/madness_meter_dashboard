import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:madness_meter_dashboard/components/player_session_button.dart';
import 'package:madness_meter_dashboard/db_functions.dart';
import 'package:madness_meter_dashboard/provider.dart';

class StartScreen extends HookConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initFunction = useCallback((_) async {}, []);
    addPlayerSessionsToState(ref);
    useEffect(() {
      initFunction(null);
      return null;
    }, []);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey.shade900,
          body: SingleChildScrollView(
            child: Wrap(
                children: ref
                    .watch(allPlayerSessionsProvider)
                    .map((session) => PlayerSessionTile(playerSession: session))
                    .toList()),
          )),
    );
  }
}
