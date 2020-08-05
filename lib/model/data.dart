import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futsal_field_jepara/model/field_type.dart';
import 'package:futsal_field_jepara/model/futsal_field.dart';
import 'package:futsal_field_jepara/model/user.dart';

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
      .then((DocumentSnapshot doc) => FieldType.fromSnapshot(doc))
      .catchError((e) => print(e));
}

Stream<QuerySnapshot> loadUserById(String uid) {
  return _fireStore
      .collection("users")
      .where("uid", isEqualTo: uid)
      .snapshots();
}

Future<User> getUserById(String uid) {
  return _fireStore
      .collection('users')
      .document(uid)
      .get()
      .then((DocumentSnapshot doc) => User.fromSnapshot(doc));
}

Future<void> createUserOrder(
  String userUID,
  String futsalFieldUID,
  String futsalFieldName,
  String orderDate,
  String fieldType,
  String orderTime,
  int price,
  int orderStatus,
) {
  var uid = _fireStore.collection("userOrders").document().documentID;
  return _fireStore.collection("userOrders").document(uid).setData({
    'uid': uid,
    'userUID': userUID,
    'futsalFieldUID': futsalFieldUID,
    'futsalFieldName': futsalFieldName,
    'orderDate': orderDate,
    'fieldType': fieldType,
    'orderTime': orderTime,
    'price': price,
    'orderStatus': orderStatus,
  });
}
