import 'package:cloud_firestore/cloud_firestore.dart';

class VideoStatModel {
  String? id, videoId;

  VideoStatModel({
    required this.id,
    required this.videoId,
  });

  factory VideoStatModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final docData = documentSnapshot.data()!;
    return VideoStatModel(
      id: documentSnapshot.id,
      videoId: (docData['video_id']).toString(),
    );
  }
}
