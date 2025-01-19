import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiktok_clone_demo/core/constants/constant_variables.dart';
import 'package:tiktok_clone_demo/core/utils/snackbar.dart';
import 'package:tiktok_clone_demo/feature/home/models/video_model.dart';
import 'package:tiktok_clone_demo/feature/home/models/video_stat_model.dart';
import 'package:video_player/video_player.dart';

class HomeController extends GetxController {
  final firebase = FirebaseFirestore.instance;
  Rx<User?> userId = FirebaseAuth.instance.currentUser.obs;
  RxBool loadingVideos = true.obs,
      cachingVideo = true.obs,
      loadingVideoStat = true.obs,
      loadingFavoriteVideos = true.obs;
  RxList<VideoModel> videos = <VideoModel>[].obs; // video list
  RxList<VideoStatModel> videosStats =
      <VideoStatModel>[].obs; // video stats for the user
  RxInt tempIndex = (-1).obs;

  // download and cache videos
  Future<void> downloadAndCacheVideos({required Uri url}) async {
    cachingVideo(true);
    try {
      debugPrint('## DOWNLOADING VIDEO TO VIDEO CONTROLLER');
      videos[tempIndex.value].videoController =
          VideoPlayerController.networkUrl(url);
      await videos[tempIndex.value].videoController!.initialize();
      await videos[tempIndex.value].videoController!.setLooping(true);
      videos[tempIndex.value].videoController!.play();
    } catch (e) {
      debugPrint('## ERROR DOWNLOADING/CACHING VIDEOS : $e');
    } finally {
      cachingVideo(false);
    }
  }

  // get videos
  getVideos() async {
    loadingVideos(true);
    try {
      videos.clear();
      debugPrint('## GETTING VIDEO LIST');
      final snapShot = await firebase.collection(fireStoreVideos).get();
      if (snapShot.docs.isEmpty) {
        throw 'Could not get videos collection';
      }

      videos(snapShot.docs.map((e) => VideoModel.fromSnapShot(e)).toList());
      tempIndex(0);

      downloadAndCacheVideos(url: Uri.parse(videos.first.link!));
    } catch (e) {
      debugPrint('## ERROR GETTING VIDEOS: $e');
      snackBar().show(
          title: 'Error', message: 'Error getting videos!', isError: true);
      videos.clear();
      tempIndex(-1);
    } finally {
      debugPrint('## VIDEO COUNT: ${videos.length}');
      loadingVideos(false);
    }
  }

  // get video stats for the user
  getVideoStat() async {
    loadingVideoStat(true);
    try {
      videosStats.clear();
      debugPrint('## GETTING VIDEO STAT');
      final snapShot = await firebase
          .collection(fireStoreLikes)
          .doc(fireStoreUser)
          .collection(userId.value!.email.toString())
          .get();
      if (snapShot.docs.isEmpty) {
        throw 'Videos stats empty!';
      }

      videosStats(
          snapShot.docs.map((e) => VideoStatModel.fromSnapShot(e)).toList());
    } catch (e) {
      debugPrint('## ERROR GETTING VIDEO STATS: $e');
      videosStats.clear();
    } finally {
      debugPrint('## VIDEO STAT COUNT: ${videosStats.length}');
      loadingVideoStat(false);
    }
  }

  // share video
  void onShareVideo({required String link}) async {
    try {
      await Share.shareXFiles(
        [
          XFile.fromData(
            utf8.encode(link),
            name: 'Video',
            mimeType: 'text/plain',
          ),
        ],
      );
    } catch (e) {
      debugPrint('## ERROR SHARING VIDEO');
      snackBar().show(
          title: 'Error sharing video',
          message: 'Could not share video!',
          isError: true);
    }
  }

  // update like status
  updateVideoLike({required String videoId}) async {
    bool liked = videosStats.indexWhere((e) => e.videoId == videoId) > -1;

    try {
      if (!liked) {
        // liking video
        debugPrint('## LIKING VIDEO : $videoId');
        await firebase
            .collection(fireStoreLikes)
            .doc(fireStoreUser)
            .collection(userId.value!.email.toString())
            .add({
          'id': videoId,
          'video_id': videoId,
        });
        snackBar().show(title: '', message: 'Video liked.', isSuccess: true);
      } else {
        // disliking video
        debugPrint('## REMOVING LIKE FOR THE VIDEO : $videoId');
        await firebase
            .collection(fireStoreLikes)
            .doc(fireStoreUser)
            .collection(userId.value!.email.toString())
            .doc(videosStats.firstWhere((e) => e.videoId == videoId).id)
            .delete();
        snackBar().show(
            title: '',
            message: 'Video removed from liked videos.',
            isSuccess: true);
      }
    } catch (e) {
      debugPrint('## ERROR LIKING/DISLIKING VIDEO: $e');
      snackBar().show(
          title: 'Error',
          message: 'Could not like/dislike the video',
          isError: true);
    } finally {
      getVideoStat();
    }
  }
}
