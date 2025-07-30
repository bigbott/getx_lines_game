import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'stats_controller.dart';

class StatsView extends GetView<StatsController> {
  const StatsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StatsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StatsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
