import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/core/utils/snackbar.dart';
import 'package:tiktok_clone_demo/feature/home/model/video_model.dart';

class HomeController extends GetxController {
  final firebase = FirebaseFirestore.instance;
  RxBool loadingVideos = true.obs, loadingComments = true.obs;
  RxList<VideoModel> videos = <VideoModel>[].obs;

  getVideos() async {
    loadingVideos(true);
    try {
      debugPrint('## GETTING VIDEO LIST');
      final snapShot = await firebase.collection('videos').get();
      if (snapShot.docs.isEmpty) {
        throw 'Could not get videos collection';
      }

      videos(snapShot.docs.map((e) => VideoModel.fromSnapShot(e)).toList());
    } catch (e) {
      debugPrint('## ERROR GETTING VIDEOS: $e');
      snackbar().show(
          title: 'Error', message: 'Error getting videos!', isError: true);
      videos.clear();
    } finally {
      debugPrint('## VIDEO COUNT: ${videos.length}');
      loadingVideos(false);
    }
  }

  getComments() async {
    loadingComments(true);
    try {
      debugPrint('## GETTING COMMENTS');

    } catch (e) {
      debugPrint('## ERROR GETTING VIDEOS: $e');
      snackbar().show(
          title: 'Error', message: 'Error getting videos!', isError: true);

    } finally {
      // debugPrint('## VIDEO COUNT: ${videos.length}');
      loadingComments(false);
    }
  }
}
