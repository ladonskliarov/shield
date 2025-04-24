import 'package:cloud_firestore/cloud_firestore.dart';

import '/data/models/mission.dart';

abstract class MissionsRepository {
  Stream<List<Mission>> getMissions();
  completeMission(String missionId);
}

class FirebaseMissionsRepository implements MissionsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<Mission>> getMissions() {
    return _firestore.collection('missions').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Mission.fromJson(doc.data())).toList(),
        );
  }

  @override
  Future<void> completeMission(String missionId) async {
  final query = await FirebaseFirestore.instance
      .collection('missions')
      .where('id', isEqualTo: missionId)
      .get();

    final docId = query.docs.first.id;

    await FirebaseFirestore.instance
        .collection('missions')
        .doc(docId)
        .update({'status': 'Completed'});

  }
}
