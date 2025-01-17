import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String? id, link;

  VideoModel({required this.link, required this.id});

  // VideoModel.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   link = json['link'];
  // }

  factory VideoModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final docData = documentSnapshot.data()!;
    return VideoModel(
      id: documentSnapshot.id,
      link: (docData['link']).toString(),
    );
  }
}
