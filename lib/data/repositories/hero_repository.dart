import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/data/repositories/missions_repository.dart';
import '/data/models/hero.dart';

abstract class HeroRepository {
  Stream<Hero?> getHero(String uid);
  Future<void> reserveMission(String threatLevel, String missionId);
}

class FirebaseHeroRepository implements HeroRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> reserveMission(String threatLevel, String missionId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final docRef = FirebaseFirestore.instance.collection('heroes').doc(uid);
    final doc = await docRef.get();
    final currentEnergy = doc.data()?['energy'] ?? 1.0;

    final Map<String, double> energyCosts = {
      'Low': 20,
      'Medium': 30,
      'High': 40,
      'World-Ending': 50,
    };

    final cost = energyCosts[threatLevel];

    await docRef.update({'energy': currentEnergy - cost});
    final MissionsRepository missionsRepository = FirebaseMissionsRepository();
    await missionsRepository.completeMission(missionId);
  }

  @override
  Stream<Hero?> getHero(String uid) {
    return _firestore.collection('heroes').doc(uid).snapshots().map(
          (snapshot) => Hero.fromJson(snapshot.data()!),
        );
  }
}
