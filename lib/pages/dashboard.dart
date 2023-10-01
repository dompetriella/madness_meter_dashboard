import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(.25),
      ),
      backgroundColor: Colors.grey.shade900,
    ));
  }
}
