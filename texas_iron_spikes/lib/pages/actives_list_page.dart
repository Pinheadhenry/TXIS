import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivesListPage extends StatelessWidget {
  const ActivesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference activesRef =
        FirebaseFirestore.instance.collection('actives');

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Active Members'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: activesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No active members found'));
          }

          final docs = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Active')),
                DataColumn(label: Text('Dues Paid')),
                DataColumn(label: Text('Service Hours')),
                DataColumn(label: Text('Spirit Points')),
                DataColumn(label: Text('Actions')),
              ],
              rows: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final fullName =
                    "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}";
                return DataRow(cells: [
                  DataCell(Text(fullName)),
                  DataCell(Text(data['email'] ?? 'No email')),
                  DataCell(Text(data['role'] ?? 'No role')),
                  DataCell(Text(data['Active'].toString())),
                  DataCell(Text(data['DuesPaid'].toString())),
                  DataCell(Text(data['ServiceHours'].toString())),
                  DataCell(Text(data['SpiritPoints'].toString())),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => EditDialog(
                            docId: doc.id,
                            data: data,
                          ),
                        );
                      },
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class EditDialog extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditDialog({super.key, required this.docId, required this.data});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController roleController;
  late TextEditingController activeController;
  late TextEditingController duesController;
  late TextEditingController serviceController;
  late TextEditingController spiritController;

  @override
  void initState() {
    super.initState();
    final d = widget.data;
    firstNameController = TextEditingController(text: d['firstName'] ?? '');
    lastNameController = TextEditingController(text: d['lastName'] ?? '');
    emailController = TextEditingController(text: d['email'] ?? '');
    roleController = TextEditingController(text: d['role'] ?? '');
    activeController = TextEditingController(text: d['Active'].toString());
    duesController = TextEditingController(text: d['DuesPaid'].toString());
    serviceController = TextEditingController(text: d['ServiceHours'].toString());
    spiritController = TextEditingController(text: d['SpiritPoints'].toString());
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    roleController.dispose();
    activeController.dispose();
    duesController.dispose();
    serviceController.dispose();
    spiritController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final docRef =
        FirebaseFirestore.instance.collection('actives').doc(widget.docId);

    try {
      await docRef.update({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'role': roleController.text.trim(),
        'Active': activeController.text.toLowerCase() == 'true',
        'DuesPaid': int.tryParse(duesController.text) ?? 0,
        'ServiceHours': int.tryParse(serviceController.text) ?? 0,
        'SpiritPoints': int.tryParse(spiritController.text) ?? 0,
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Member'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: activeController,
              decoration: const InputDecoration(labelText: 'Active (true/false)'),
            ),
            TextField(
              controller: duesController,
              decoration: const InputDecoration(labelText: 'Dues Paid'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: serviceController,
              decoration: const InputDecoration(labelText: 'Service Hours'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: spiritController,
              decoration: const InputDecoration(labelText: 'Spirit Points'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
