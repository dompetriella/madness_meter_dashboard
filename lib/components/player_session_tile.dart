import 'package:flutter/material.dart';
import 'package:madness_meter_dashboard/models/player_session.dart';
import 'package:madness_meter_dashboard/pages/dashboard.dart';

class PlayerSessionTile extends StatelessWidget {
  final PlayerSession playerSession;
  const PlayerSessionTile({super.key, required this.playerSession});

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
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => Dashboard(
                  playerSession: playerSession,
                ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 200,
            width: 300,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 48.0),
                    child: Text(
                      playerSession.campaignName.toUpperCase(),
                      style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                  Text(
                    'ID: ${playerSession.id}',
                    style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Current Madness: ${playerSession.madnessValue} / ${playerSession.maxMadnessValue}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
              Container(
                height: 50,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onSecondary,
                        width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: playerSession.madnessValue /
                        playerSession.maxMadnessValue,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8))),
                    )),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
