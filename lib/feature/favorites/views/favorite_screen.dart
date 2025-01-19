import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:tiktok_clone_demo/feature/comments/controllers/comments_controller.dart';
import 'package:tiktok_clone_demo/feature/comments/views/comment_pop_up.dart';
import 'package:tiktok_clone_demo/feature/favorites/controllers/favorites_controller.dart';
import 'package:tiktok_clone_demo/feature/home/models/video_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoritesController favoritesController = Get.find<FavoritesController>();
  CommentsController commentsController = Get.find<CommentsController>();

  @override
  void initState() {
    super.initState();
    if (favoritesController.favoriteVideos.isNotEmpty) {
      favoritesController.downloadAndCacheVideos(
          url: Uri.parse(favoritesController.favoriteVideos.first.link!));
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (var fav in favoritesController.favoriteVideos) {
      if (fav.videoController != null) {
        fav.videoController!.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Favorite videos',
            style: TextStyle(color: Colors.white),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Obx(
              () => Expanded(
                child: (favoritesController.favoriteVideos.isEmpty)
                    ? Center(
                        child: Text(
                          'No favorites yet!',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : (favoritesController.cachingVideo.value)
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : PageView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount:
                                favoritesController.favoriteVideos.length,
                            onPageChanged: (v) {
                              if (favoritesController
                                  .favoriteVideos[
                                      favoritesController.tempIndex.value]
                                  .videoController!
                                  .value
                                  .isPlaying) {
                                favoritesController
                                    .favoriteVideos[
                                        favoritesController.tempIndex.value]
                                    .videoController!
                                    .pause();
                              }

                              favoritesController.tempIndex(v);

                              if (favoritesController
                                      .favoriteVideos[v].videoController ==
                                  null) {
                                favoritesController.downloadAndCacheVideos(
                                    url: Uri.parse(favoritesController
                                        .favoriteVideos[v].link!));
                              } else if (favoritesController.favoriteVideos[v]
                                  .videoController!.value.isInitialized) {
                                favoritesController
                                    .favoriteVideos[v].videoController!
                                    .play();
                              }

                              commentsController.getVideoComments(
                                  videoId: favoritesController
                                      .favoriteVideos[v].id!);

                              // disposing video controller at index + 2 position of the current video
                              if (v <
                                      (favoritesController
                                              .favoriteVideos.length -
                                          1) &&
                                  favoritesController.favoriteVideos[v + 2]
                                          .videoController !=
                                      null) {
                                debugPrint('## CLEARING 2 STEPS BACK');
                                favoritesController.favoriteVideos[v + 2]
                                    .videoController = null;
                              }

                              // disposing video controller at index - 2 position of the current video
                              if (v > 1 &&
                                  favoritesController.favoriteVideos[v - 2]
                                          .videoController !=
                                      null) {
                                debugPrint('## CLEARING 2 STEPS AHEAD');
                                favoritesController.favoriteVideos[v - 2]
                                    .videoController = null;
                              }
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  if (favoritesController
                                      .favoriteVideos[
                                          favoritesController.tempIndex.value]
                                      .videoController!
                                      .value
                                      .isPlaying) {
                                    favoritesController
                                        .favoriteVideos[
                                            favoritesController.tempIndex.value]
                                        .videoController!
                                        .pause();
                                  } else {
                                    favoritesController
                                        .favoriteVideos[
                                            favoritesController.tempIndex.value]
                                        .videoController!
                                        .play();
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Obx(
                                      () => (favoritesController.homeController
                                              .cachingVideo.value)
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : (favoritesController
                                                      .favoriteVideos[
                                                          favoritesController
                                                              .tempIndex.value]
                                                      .videoController ==
                                                  null)
                                              ? Icon(Icons.error_outline)
                                              : SizedBox.expand(
                                                  child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: SizedBox(
                                                    width: favoritesController
                                                        .favoriteVideos[
                                                            favoritesController
                                                                .tempIndex
                                                                .value]
                                                        .videoController!
                                                        .value
                                                        .size
                                                        .width,
                                                    height: favoritesController
                                                        .favoriteVideos[
                                                            favoritesController
                                                                .tempIndex
                                                                .value]
                                                        .videoController!
                                                        .value
                                                        .size
                                                        .height,
                                                    child: Obx(
                                                      () => VideoPlayer(
                                                          favoritesController
                                                              .favoriteVideos[
                                                                  favoritesController
                                                                      .tempIndex
                                                                      .value]
                                                              .videoController!),
                                                    ),
                                                  ),
                                                )),
                                    ),

                                    // interaction buttons
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 20),
                                            child: Obx(
                                              () => Text(
                                                (favoritesController
                                                        .favoriteVideos
                                                        .isNotEmpty)
                                                    ? 'Favorite video ${favoritesController.tempIndex.value + 1}'
                                                    : '',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: 240,
                                              width: 70,
                                              child: Column(
                                                spacing: 40,
                                                children: [
                                                  // like/unlike video
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (favoritesController
                                                          .favoriteVideos
                                                          .isNotEmpty) {
                                                        favoritesController
                                                            .homeController
                                                            .updateVideoLike(
                                                                videoId: favoritesController
                                                                    .favoriteVideos[
                                                                        favoritesController
                                                                            .tempIndex
                                                                            .value]
                                                                    .videoId!);
                                                      }
                                                    },
                                                    child: Obx(() => Icon(
                                                          Icons.thumb_up,
                                                          color: (favoritesController.homeController.videosStats.indexWhere((stat) =>
                                                                          stat.videoId ==
                                                                          favoritesController
                                                                              .favoriteVideos[favoritesController
                                                                                  .tempIndex.value]
                                                                              .videoId) >
                                                                      -1 &&
                                                                  favoritesController
                                                                      .homeController
                                                                      .videosStats
                                                                      .isNotEmpty)
                                                              ? Colors.red
                                                              : Colors.white,
                                                        )),
                                                  ),

                                                  // favorite/unfavorite video
                                                  GestureDetector(
                                                      onTap: () {
                                                        if (favoritesController
                                                            .favoriteVideos
                                                            .isNotEmpty) {
                                                          VideoModel tempVideo =
                                                              VideoModel(
                                                            link: favoritesController
                                                                .favoriteVideos[
                                                                    favoritesController
                                                                        .tempIndex
                                                                        .value]
                                                                .link,
                                                            id: favoritesController
                                                                .favoriteVideos[
                                                                    favoritesController
                                                                        .tempIndex
                                                                        .value]
                                                                .videoId,
                                                            videoId: favoritesController
                                                                .favoriteVideos[
                                                                    favoritesController
                                                                        .tempIndex
                                                                        .value]
                                                                .videoId,
                                                            // videoController: favoritesController
                                                            //     .favoriteVideos[favoritesController
                                                            //         .tempIndex
                                                            //         .value]
                                                            //     .videoController
                                                          );
                                                          favoritesController
                                                              .updateFavoriteVideo(
                                                                  video:
                                                                      tempVideo);
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      )),

                                                  // comment on video
                                                  GestureDetector(
                                                      onTap: () {
                                                        if (favoritesController
                                                            .favoriteVideos
                                                            .isNotEmpty) {
                                                          commentPopUp(
                                                              videoId: favoritesController
                                                                  .favoriteVideos[
                                                                      favoritesController
                                                                          .tempIndex
                                                                          .value]
                                                                  .videoId!,
                                                              context: context);
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.comment,
                                                        color: Colors.white,
                                                      )),

                                                  // share video
                                                  GestureDetector(
                                                      onTap: () {
                                                        if (favoritesController
                                                            .favoriteVideos
                                                            .isNotEmpty) {
                                                          favoritesController
                                                              .homeController
                                                              .onShareVideo(
                                                                  link: favoritesController
                                                                      .favoriteVideos[favoritesController
                                                                          .tempIndex
                                                                          .value]
                                                                      .link!);
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.share,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ));
  }
}
