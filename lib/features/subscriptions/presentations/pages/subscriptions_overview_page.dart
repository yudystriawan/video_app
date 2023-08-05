import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SubscriptionsOverviewPage extends StatelessWidget {
  const SubscriptionsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Subscriptions'),
        ),
      ),
    );
  }
}
