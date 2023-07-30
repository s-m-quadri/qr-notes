import 'package:flutter/material.dart';
import '../scan/scan.dart';
import '../settings/settings.dart';
import '../about/about.dart';
import '../storage/storage.dart';
import '../history/history_page.dart';
import 'overview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _optionWidget = [
    QRNOverview(),
    QRNStorage(),
  ];

  static const List<BottomNavigationBarItem> _optionButtons = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: "Home",
      tooltip: "Home Page",
      backgroundColor: Colors.red
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.dataset_outlined),
      label: "Storage",
      tooltip: "Storage Page",
    ),
  ];

  Future<void> _getScannedNotes(BuildContext context) async {
    String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Settings()));

    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("Result: $result")));
  }

  void _menuOnSelect(int index) {
    switch (index) {
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QRNHistory()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Settings()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => About()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////////////////////////////////////////
    // Application Top-bar
    /////////////////////////////////////////////////////////////////////////
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // onPressed: _getScannedNotes,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => QRScan()));
        },
        child: Icon(
          Icons.camera_alt,
          color: Theme.of(context).primaryColorDark,
        ),
        backgroundColor: Theme.of(context).cardColor,
        splashColor: Theme.of(context).primaryColor,
        tooltip: "Capture QR Notes",
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
              onSelected: _menuOnSelect,
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(value: 1, child: Text("History")),
                  PopupMenuItem(value: 2, child: Text("Settings")),
                  PopupMenuItem(value: 3, child: Text("About")),
                ];
              })
        ],
      ),

      /////////////////////////////////////////////////////////////////////////
      // Body of Home Page
      /////////////////////////////////////////////////////////////////////////
      body: Center(child: _optionWidget.elementAt(_selectedIndex)),

      /////////////////////////////////////////////////////////////////////////
      // Bottom Navigation Bar
      /////////////////////////////////////////////////////////////////////////
      bottomNavigationBar: BottomNavigationBar(
        items: _optionButtons,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColorDark,
        unselectedItemColor: Theme.of(context).primaryColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColorLight,
        onTap: _onItemTapped,
      ),
    );
  }
}
