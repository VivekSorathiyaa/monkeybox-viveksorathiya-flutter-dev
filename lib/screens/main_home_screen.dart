import 'package:flutter/material.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/screens/activities_screen.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/utils/color.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> widgetList = [];

  @override
  void initState() {
    super.initState();
    widgetList = [
      Scaffold(
          appBar: AppBar(
            title: const Text('Home',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          body: const Center(child: Text('Home'))),
      Scaffold(
          appBar: AppBar(
            title: const Text('Journal',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          body: const Center(child: Text('Journal'))),
      ActivitiesScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<NavigationProvider>(
          builder: (context, navigationProvider, child) {
        return widgetList[navigationProvider.currentIndex];
      }),
      bottomNavigationBar: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          return BottomNavigationBar(
            backgroundColor: primaryWhite,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.directions_run), label: 'Activities'),
            ],
            currentIndex: navigationProvider.currentIndex,
            onTap: (index) {
              navigationProvider.setCurrentIndex(index);
            },
          );
        },
      ),
    );
  }
}
