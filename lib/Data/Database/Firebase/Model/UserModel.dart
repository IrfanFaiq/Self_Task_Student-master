import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String fullName;
  final String email;
  final String pNumber;
  final String matrixId;

  UserModel({
    required this.fullName,
    required this.email,
    required this.pNumber,
    required this.matrixId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        fullName: json['fullName'],
        email: json['email'],
        pNumber: json['pNumber'],
        matrixId: json['matrixId']);
  }

  Map<String, dynamic> toMap() => {
    "fullName": fullName,
    "email": email,
    "pNumber": pNumber,
    "matrixId": matrixId
  };

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> firestore) =>
      UserModel(
          fullName: firestore.data()!['fullName'],
          email: firestore.data()!['email'],
          pNumber: firestore.data()!['pNumber'],
          matrixId: firestore.data()!['matrixId']
      );
}
