import 'package:flutter/material.dart';
import 'package:flutter_chart/screens/custom_chart/index.dart';
import 'package:flutter_chart/screens/fl_chart/index.dart';

class Index extends StatelessWidget {
  const Index({
    super.key,
  });
  static const String routeName = '/index';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, FlChartIndex.routeName);
          },
          child: const Text('Fl Chart'),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, CustomChartIndex.routeName);
          },
          child: const Text('Custom Chart'),
        ),
      ],
    );
  }
}
