import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? id, comment;

  CommentModel({required this.id, required this.comment});

  factory CommentModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final docData = documentSnapshot.data()!;
    return CommentModel(
      id: documentSnapshot.id,
      comment: (docData['comment']).toString(),
    );
  }
}
