import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class FavoriteVideoModel {
  String? id, link, videoId;
  VideoPlayerController? videoController;

  FavoriteVideoModel({
    required this.link,
    required this.id,
    required this.videoId,
     this.videoController,
  });

  factory FavoriteVideoModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final docData = documentSnapshot.data()!;
    return FavoriteVideoModel(
      id: documentSnapshot.id,
      videoId: docData['video_id'].toString(),
      link: docData['link'].toString(),
    );
  }
}
