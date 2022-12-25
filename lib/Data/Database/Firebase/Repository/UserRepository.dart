import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:self_task_student/Data/Database/Firebase/Model/UserModel.dart';

class UserRepository {
  CollectionReference db = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel userModel, String email) async{
    await db.doc(email).set({
      'fullName': userModel.fullName,
      'email': userModel.email,
      'pNumber': userModel.pNumber,
      'matrixId': userModel.matrixId,
    });
    return;
  }

  Future<void> updateUser(UserModel userModel, String email) async{
    await db.doc(email).update({
      'fullName': userModel.fullName,
      'email': userModel.email,
      'pNumber': userModel.pNumber,
      'matrixId': userModel.matrixId,
    });
    return;
  }

  Future<DocumentSnapshot<Object?>> getSpecificUser(String email) async {
    return await db.doc(email).get();
  }
}
