import 'package:cloud_firestore/cloud_firestore.dart';

class VideoCommentModel {
  String? id, userId, comment;

  VideoCommentModel(
      {required this.id, required this.userId, required this.comment});

  factory VideoCommentModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final docData = documentSnapshot.data()!;
    return VideoCommentModel(
      id: documentSnapshot.id,
      userId: (docData['id']).toString(),
      comment: (docData['comment']).toString(),
    );
  }
}
