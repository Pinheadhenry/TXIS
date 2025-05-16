import 'package:flutter/material.dart';
import 'form_page.dart';
import 'package:texas_iron_spikes/pages/service_form_page.dart';



class HoursForms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forms Navigation')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyServiceForm()),
                );
              },
              child: const Text('Submit Service Hours'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCustomForm()),
                );
              },
              child: const Text('Submit Spirit Points'),
            ),
          ],
        ),
      ),
    );
  }
}