import 'package:ched_darek/models/service.dart';
import 'package:ched_darek/models/user.dart';
import 'package:ched_darek/models/volunteer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  // user data from Snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        fullname: snapshot.data['fullname'],
        adress: snapshot.data['adress'],
        phone: snapshot.data['phone']);
  }

  // Get user data stream
  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  List<Service> _serviceListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Service(
        sid: doc.data['sid'],
        overview: doc.data['overview'],
        date: doc.data['date'],
        done: doc.data['done'],
      );
    }).toList();
  }

  // Get services stream
  Stream<List<Service>> get services {
    return usersCollection
        .document(uid)
        .collection('services')
        .snapshots()
        .map(_serviceListFromSnapshot);
  }

  List<VolunteerData> _volunteerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return VolunteerData(
        uid: doc.data['uid'],
        fullname: doc.data['fullname'],
        adress: doc.data['adress'],
        phone: doc.data['phone'],
      );
    }).toList();
  }

  // Get services stream
  Stream<List<VolunteerData>> get volunteers {
    return Firestore.instance
        .collection('volunteers')
        .snapshots()
        .map(_volunteerListFromSnapshot);
  }
}
