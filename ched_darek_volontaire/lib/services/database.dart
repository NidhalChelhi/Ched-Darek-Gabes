import 'package:ched_darek_volunteer/models/service.dart';
import 'package:ched_darek_volunteer/models/volunteer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference volunteersCollection =
      Firestore.instance.collection('volunteers');

  // volunteer data from Snapshot
  VolunteerData _volunteerDataFromSnapshot(DocumentSnapshot snapshot) {
    return VolunteerData(
        uid: uid,
        fullname: snapshot.data['fullname'],
        adress: snapshot.data['adress'],
        phone: snapshot.data['phone']);
  }

  // Get volunteer data stream
  Stream<VolunteerData> get volunteerData {
    return volunteersCollection
        .document(uid)
        .snapshots()
        .map(_volunteerDataFromSnapshot);
  }

  List<Service> _serviceListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Service(
        sid: doc.data['sid'],
        overview: doc.data['overview'],
        date: doc.data['date'],
        fullname: doc.data['fullname'],
        phone: doc.data['phone'],
        adress: doc.data['adress'],
        done: doc.data['done'],
      );
    }).toList();
  }

  // Get service stream
  Stream<List<Service>> get services {
    return Firestore.instance
        .collection('services')
        .orderBy('done')
        .snapshots()
        .map(_serviceListFromSnapshot);
  }
}
