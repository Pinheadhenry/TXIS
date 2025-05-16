import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RequestReviewPage extends StatelessWidget {
  const RequestReviewPage({super.key});

  Future<void> _acceptRequest(Map<String, dynamic> data, String requestId, BuildContext context) async {
    final uid = data['uid'];
    final double hoursToAdd = (data['hours'] as num).toDouble();

    final userRef = FirebaseFirestore.instance.collection('actives').doc(uid);
    final requestRef = FirebaseFirestore.instance.collection('requests').doc(requestId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);
        if (!userSnapshot.exists) {
          throw Exception("User not found");
        }

        final currentHours = (userSnapshot.data()?['ServiceHours'] ?? 0) as num;
        final updatedHours = currentHours + hoursToAdd;

        transaction.update(userRef, {'ServiceHours': updatedHours});
        transaction.delete(requestRef);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request accepted and hours added.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accepting request: $e')),
      );
    }
  }

  Future<void> _rejectRequest(String requestId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('requests').doc(requestId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request rejected.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting request: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestsRef = FirebaseFirestore.instance.collection('requests');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: requestsRef.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading requests'));
          }

          final requests = snapshot.data?.docs ?? [];

          if (requests.isEmpty) {
            return const Center(child: Text('No pending requests'));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final doc = requests[index];
              final data = doc.data() as Map<String, dynamic>;
              final id = doc.id;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('${data['activeName']} • ${data['eventName']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('UTEID: ${data['uteid']}'),
                      Text('Hours: ${data['hours']}'),
                      Text('Date: ${data['date']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _acceptRequest(data, id, context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _rejectRequest(id, context),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
