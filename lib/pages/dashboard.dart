import 'package:flutter/material.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';

class Dashboard extends StatelessWidget {
  final PlayerSession playerSession;
  const Dashboard({super.key, required this.playerSession});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text('Campaign: ' + playerSession.campaignName.toUpperCase()),
          Text('Current Meter: ')
        ]),
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(.25),
      ),
      backgroundColor: Colors.grey.shade900,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationRail(
              useIndicator: false,
              backgroundColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(.25),
              minWidth: 100,
              destinations: <NavigationRailDestination>[
                NavigationRailDestination(
                    padding: EdgeInsets.all(12),
                    icon: Icon(
                      Icons.dashboard,
                      size: 48,
                    ),
                    label: Text('DB Actions')),
                NavigationRailDestination(
                    icon: Icon(
                      Icons.auto_awesome,
                      size: 48,
                    ),
                    label: Text('DB Actions'))
              ],
              selectedIndex: 1),
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
