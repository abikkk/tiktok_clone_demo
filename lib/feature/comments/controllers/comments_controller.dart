import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/core/constants/constant_variables.dart';
import 'package:tiktok_clone_demo/core/utils/random_comment_generator.dart';
import 'package:tiktok_clone_demo/core/utils/snackbar.dart';
import 'package:tiktok_clone_demo/feature/home/controllers/home_controller.dart';
import 'package:tiktok_clone_demo/feature/home/models/video_comment_model.dart';

class CommentsController extends GetxController {
  HomeController homeController = Get.find<HomeController>();
  RxBool loadingComments = true.obs;
  RxList<VideoCommentModel> videoComments =
      <VideoCommentModel>[].obs; // comments for the video
  Rx<TextEditingController> commentController = TextEditingController().obs;

  // get comments for the video
  getVideoComments({required String videoId}) async {
    loadingComments(true);
    try {
      debugPrint('## GETTING COMMENTS : $videoId');

      final snapShot = await homeController.firebase
          .collection(fireStoreComments)
          .doc(fireStoreVideos)
          .collection(videoId)
          .get();
      if (snapShot.docs.isEmpty) {
        throw 'No comments found';
      }

      videoComments(
          snapShot.docs.map((e) => VideoCommentModel.fromSnapShot(e)).toList());
    } catch (e) {
      debugPrint('## ERROR GETTING VIDEO COMMENTS: $e');
      videoComments.clear();
    } finally {
      loadingComments(false);
    }
  }

// add comment
  Future addVideoComment(
      {required String videoId,
      required String comment,
      bool isUser = true}) async {
    try {
      debugPrint('## COMMENTING ON VIDEO : $videoId');

      await homeController.firebase
          .collection(fireStoreComments)
          .doc(fireStoreVideos)
          .collection(videoId)
          .add({
        'id': (isUser) ? homeController.userId.value!.email : 'bot 1',
        'comment': comment,
      });

      commentController.value.clear();

      // trigger bot countdown
      if (isUser) {
        snackBar()
            .show(title: '', message: 'Commented posted.', isSuccess: true);
        botCommentTrigger(videoId: videoId);
      }
    } catch (e) {
      debugPrint('## ERROR POSTING COMMENT ON VIDEO: $e');
      snackBar().show(
          title: 'Error',
          message: 'Could not post comment on the video',
          isError: true);
    } finally {
      getVideoComments(videoId: videoId);
    }
  }

// delete user comment
  deleteComment({required String commentId}) async {
    try {
      debugPrint('## DELETING COMMENT : $commentId');
      await homeController.firebase
          .collection(fireStoreComments)
          .doc(fireStoreVideos)
          .collection(homeController.videos[homeController.tempIndex.value].id!)
          .doc(commentId)
          .delete();
      snackBar().show(title: '', message: 'Comment deleted.', isSuccess: true);
    } catch (e) {
      debugPrint('## ERROR DELETING COMMENT ON VIDEO: $e');
      snackBar().show(
          title: 'Error',
          message: 'Could not delete comment on the video',
          isError: true);
    } finally {
      getVideoComments(
          videoId: homeController.videos[homeController.tempIndex.value].id!);
    }
  }

  // bot comment section

  late Timer timer;
  RxInt start = 5.obs;

  botCommentTrigger({required String videoId}) {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
          postBotComment(videoId: videoId);
        } else {
          debugPrint('## POSTING BOT COMMENT IN $start');
          start--;
        }
      },
    );
  }

  // post random comment
  postBotComment({required String videoId}) async {
    addVideoComment(
        videoId: videoId,
        comment: RandomCommentGenerator().getRandomString(10),
        isUser: false);
  }
}
