import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ShortsOverviewPage extends StatelessWidget {
  const ShortsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Shorts'),
        ),
      ),
    );
  }
}
