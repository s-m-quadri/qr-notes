import 'package:flutter/material.dart';
import '../scan/scan.dart';
import '../settings/settings.dart';
import '../about/about.dart';
import '../storage/storage.dart';

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
    Text("This is home"),
    Storage(),
    Text("This is Secretes"),
  ];

  Future<void> _getScannedNotes(BuildContext context) async {
    String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Settings()));

    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("Result: $result")));
  }

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////////////////////////////////////////
    // Application Top-bar
    /////////////////////////////////////////////////////////////////////////
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => QRScan()));
        },
        child: Icon(Icons.camera_alt),
        tooltip: "Capture QR Notes",
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(onSelected: (int index) {
            switch (index) {
              case 1:
                _getScannedNotes(context);
                break;
              case 2:
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => About()));
                break;
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem(value: 1, child: Text("Settings")),
              PopupMenuItem(value: 2, child: Text("About")),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            tooltip: "Home Page",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: "Storage",
            tooltip: "Storage Page",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: "Secretes",
            tooltip: "Secretes Page",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
