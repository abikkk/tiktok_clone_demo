import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class VideoModel {
  String? id, link, videoId;
  VideoPlayerController? videoController;

  VideoModel({
    required this.link,
    required this.id,
    required this.videoId,
    this.videoController,
  });

  factory VideoModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final docData = documentSnapshot.data()!;
    return VideoModel(
      id: documentSnapshot.id,
      videoId: documentSnapshot.id,
      link: docData['link'].toString(),
    );
  }
}
