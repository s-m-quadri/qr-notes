import 'package:flutter/material.dart';
import '../scan/scan.dart';
import '../settings/settings.dart';
import '../storage/storage.dart';
import '../history/history_page.dart';
import 'overview.dart';
import 'package:url_launcher/url_launcher.dart';

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
        backgroundColor: Colors.red),
    BottomNavigationBarItem(
      icon: Icon(Icons.dataset_outlined),
      label: "Storage",
      tooltip: "Storage Page",
    ),
  ];


  void _menuOnSelect(int index) {
    switch (index) {
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const QRNHistory()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Settings()));
        break;
      case 3:
        launchUrl(Uri.parse(
            "https://github.com/s-m-quadri/qr-notes/blob/stable/README.md"));
        break;
      case 4:
        launchUrl(Uri.parse("https://github.com/s-m-quadri/qr-notes"));
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
              context, MaterialPageRoute(builder: (context) => const QRScan()));
        },
        backgroundColor: Colors.blue.shade50,
        splashColor: Colors.blue.shade900,
        tooltip: "Capture QR Notes",
        child: Icon(
          Icons.camera_alt,
          color: Colors.blue.shade900,
        ),
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
                  PopupMenuItem(value: 4, child: Text("Repository")),
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
