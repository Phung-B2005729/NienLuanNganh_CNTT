import 'package:cloud_firestore/cloud_firestore.dart';

class DatabasseMessage {
  CollectionReference messCollection =
      FirebaseFirestore.instance.collection('message');
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('hopchat');
}
