import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsDebug {
  static Future<void> printRequests() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('requests').get();

    for (var doc in snapshot.docs) {
      print('REQUEST ID: ${doc.id}');
      print(doc.data());
      print('----------------');
    }
  }
}
