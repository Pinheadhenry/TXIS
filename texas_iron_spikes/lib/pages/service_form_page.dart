import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyServiceForm extends StatefulWidget {
  const MyServiceForm({super.key});

  @override
  MyServiceFormState createState() => MyServiceFormState();
}

class MyServiceFormState extends State<MyServiceForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _activeNameController = TextEditingController();
  final TextEditingController _uteidController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _activeNameController.dispose();
    _uteidController.dispose();
    _eventNameController.dispose();
    _hoursController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _submitToFirestore() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User not logged in')),
    );
    return;
  }

  try {
    await FirebaseFirestore.instance.collection('requests').add({
      'uid': user.uid,  // ✅ Save UID of the current user
      'activeName': _activeNameController.text.trim(),
      'uteid': _uteidController.text.trim(),
      'eventName': _eventNameController.text.trim(),
      'hours': num.tryParse(_hoursController.text.trim()) ?? 0,
      'date': _dateController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'service'
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request submitted!')),
    );

    _formKey.currentState?.reset();
    _dateController.clear();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error submitting request: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _activeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Active Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _uteidController,
                  decoration: const InputDecoration(
                    labelText: 'Active UTEID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Please enter a UTEID' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _eventNameController,
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Please enter an event name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _hoursController,
                  decoration: const InputDecoration(
                    labelText: 'Hours',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter hours';
                    }
                    if (num.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Select Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDate(context),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Please select a date' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitToFirestore();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                    const SizedBox(width: 128),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
