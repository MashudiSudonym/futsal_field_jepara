import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futsal_field_jepara/model/field_type.dart';
import 'package:futsal_field_jepara/model/futsal_field.dart';

final Firestore _fireStore = Firestore.instance;

Stream<QuerySnapshot> loadAllFutsalFields() {
  return _fireStore.collection('futsalFields').snapshots();
}

List<FutsalFields> getAllFutsalFields(QuerySnapshot snapshot) {
  return snapshot.documents.map((DocumentSnapshot doc) {
    return FutsalFields.fromSnapshot(doc);
  }).toList();
}

Future<FutsalFields> getFutsalFieldById(String uid) {
  return _fireStore
      .collection('futsalFields')
      .document(uid)
      .get()
      .then((DocumentSnapshot doc) => FutsalFields.fromSnapshot(doc));
}

Future<FieldType> getFieldTypeData(String fieldType) {
  return _fireStore
      .document(fieldType)
      .get()
      .then((DocumentSnapshot doc) => FieldType.fromSnapshot(doc));
}
