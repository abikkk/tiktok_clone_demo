import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/core/constants/constant_variables.dart';
import 'package:tiktok_clone_demo/core/utils/snackbar.dart';
import 'package:tiktok_clone_demo/feature/favorites/models/favorite_video_model.dart';
import 'package:tiktok_clone_demo/feature/home/controllers/home_controller.dart';
import 'package:video_player/video_player.dart';
import '../../home/models/video_model.dart';

class FavoritesController extends GetxController {
  RxBool loadingFavoriteVideos = true.obs, cachingVideo = true.obs;
  HomeController homeController = Get.find<HomeController>();
  RxInt tempIndex = (-1).obs;

  RxList<FavoriteVideoModel> favoriteVideos =
      <FavoriteVideoModel>[].obs; // favorite video list

  // download and cache favorites videos
  Future<void> downloadAndCacheVideos({required Uri url}) async {
    cachingVideo(true);
    try {
      debugPrint('## DOWNLOADING FAVORITE VIDEO TO VIDEO CONTROLLER');
      favoriteVideos[tempIndex.value].videoController =
          VideoPlayerController.networkUrl(url);
      await favoriteVideos[tempIndex.value].videoController!.initialize();
      await favoriteVideos[tempIndex.value].videoController!.setLooping(true);
      favoriteVideos[tempIndex.value].videoController!.play();
    } catch (e) {
      debugPrint('## ERROR DOWNLOADING/CACHING FAVORITE VIDEOS : $e');
    } finally {
      cachingVideo(false);
    }
  }

  // get favorite videos
  getFavoriteVideos() async {
    loadingFavoriteVideos(true);
    try {
      debugPrint('## GETTING FAVORITES');

      final snapShot = await homeController.firebase
          .collection(fireStoreFavorites)
          .doc(fireStoreUser)
          .collection(homeController.userId.value!.email!)
          .get();
      if (snapShot.docs.isEmpty) {
        throw 'No favorites found';
      }

      favoriteVideos(snapShot.docs
          .map((e) => FavoriteVideoModel.fromSnapShot(e))
          .toList());

      tempIndex(0);
    } catch (e) {
      debugPrint('## ERROR GETTING FAVORITE VIDEOS: $e');
      favoriteVideos.clear();
      tempIndex(-1);
    } finally {
      debugPrint('## FAVORITE VIDEO COUNT: ${favoriteVideos.length}');
      loadingFavoriteVideos(false);
    }
  }

  // favorite video
  updateFavoriteVideo({required VideoModel video}) async {
    bool favorite =
        favoriteVideos.indexWhere((e) => e.videoId == video.id) > -1;

    try {
      if (!favorite) {
        // adding video as favorite
        debugPrint('## ADDING VIDEO AS FAVORITE : ${video.id}');
        await homeController.firebase
            .collection(fireStoreFavorites)
            .doc(fireStoreUser)
            .collection(homeController.userId.value!.email.toString())
            .add({
          'id': video.id,
          'video_id': video.id,
          'link': video.link,
        });
        snackBar().show(
            title: '', message: 'Video added to favorites', isSuccess: true);
      } else {
        // removing favorite for video
        debugPrint('## REMOVING VIDEO FROM FAVORITES : ${video.id}');
        await homeController.firebase
            .collection(fireStoreFavorites)
            .doc(fireStoreUser)
            .collection(homeController.userId.value!.email.toString())
            .doc(favoriteVideos.firstWhere((e) => e.videoId == video.id).id)
            .delete();
        snackBar().show(
            title: '',
            message: 'Video removed from favorites',
            isSuccess: true);
      }
    } catch (e) {
      debugPrint('## ERROR FAVORITE/UNFAVORITE FOR THE VIDEO: $e');
      snackBar().show(
          title: 'Error',
          message: 'Could not update favorite status for the video',
          isError: true);
    } finally {
      getFavoriteVideos();
    }
  }
}
