import 'package:flutter/material.dart';
import 'package:flutter_chart/index.dart';
import 'package:flutter_chart/screens/custom_chart/index.dart';
import 'package:flutter_chart/screens/fl_chart/index.dart';

class Layout extends StatelessWidget {
  const Layout({
    super.key,
    required this.child,
  });

  final Widget child;

  int _getCurrentIndex(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;
    if (route == Index.routeName) {
      return 0;
    } else if (route == FlChartIndex.routeName) {
      return 1;
    } else if (route == CustomChartIndex.routeName) {
      return 2;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, Index.routeName);
    } else if (index == 1) {
      // 차트 선택 페이지로 이동하거나 기본 차트 페이지로 이동
      Navigator.pushReplacementNamed(context, FlChartIndex.routeName);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, CustomChartIndex.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Chart'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: 'Fl Charts'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: 'Custom Charts'),
          ],
          currentIndex: _getCurrentIndex(context),
          onTap: (index) => _onTap(context, index),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
