import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texas_iron_spikes/firebase_options.dart';
import 'generator_page.dart';
import 'events_page.dart';
import 'hours_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  Future<String> getUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return 'user'; // default if not signed in
    final doc = await FirebaseFirestore.instance.collection('actives').doc(uid).get();
    return doc.data()?['role'] ?? 'user';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Error loading role')),
          );
        }

        final role = snapshot.data!;
        final isAdmin = role == 'admin';

        // Page switcher
        Widget page;
        switch (selectedIndex) {
          case 0:
            page = GeneratorPage();
            break;
          case 1:
            page = EventsPage();
            break;
          case 3:
            page = HoursForms();
            break;
          default:
            page = const Placeholder();
        }

        return Scaffold(
          bottomNavigationBar: NavigationBar(
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.calendar_month),
                label: 'Events',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Members',
              ),
              const NavigationDestination(
                icon: Icon(Icons.hourglass_bottom),
                label: 'Hours',
              ),
              const NavigationDestination(
                icon: Icon(Icons.insert_link),
                label: 'Links',
              ),
          
              const NavigationDestination(
                icon: Icon(Icons.safety_check),
                label: 'NOMC',
              ),
              if (isAdmin)
                const NavigationDestination(
                  icon: Icon(Icons.safety_check),
                  label: 'Data',
                ),
              if (isAdmin)
                const NavigationDestination(
                  icon: Icon(Icons.safety_check),
                  label: 'Requests',
                ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
          body: Row(
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
