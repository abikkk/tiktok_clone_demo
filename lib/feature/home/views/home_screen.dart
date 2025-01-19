import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/core/utils/custom_drawer.dart';
import 'package:tiktok_clone_demo/feature/comments/controllers/comments_controller.dart';
import 'package:tiktok_clone_demo/feature/comments/views/comment_pop_up.dart';
import 'package:tiktok_clone_demo/feature/favorites/controllers/favorites_controller.dart';
import 'package:tiktok_clone_demo/feature/home/controllers/home_controller.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FavoritesController favoritesController = Get.put(FavoritesController());
  CommentsController commentsController = Get.put(CommentsController());
  HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDB();
  }

  fetchDB() async {
    await homeController.getVideos();
    await homeController.getVideoStat();
    await favoritesController.getFavoriteVideos();
  }

  @override
  void dispose() {
    super.dispose();

    for (var vid in homeController.videos) {
      if (vid != homeController.videos[homeController.tempIndex.value]) {
        homeController.videos[homeController.tempIndex.value].videoController =
            null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            // refresh feeds button
            IconButton(
                onPressed: () => fetchDB(),
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ))
          ],
        ),
        drawer: CustomDrawer(),
        body: Column(
          children: [
            Expanded(
              child: Obx(
                () => (homeController.loadingVideos.value)
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : PageView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: homeController.videos.length,
                        onPageChanged: (v) {
                          if (homeController
                              .videos[homeController.tempIndex.value]
                              .videoController!
                              .value
                              .isPlaying) {
                            homeController
                                .videos[homeController.tempIndex.value]
                                .videoController!
                                .pause();
                          }

                          homeController.tempIndex(v);

                          if (homeController.videos[v].videoController ==
                              null) {
                            homeController.downloadAndCacheVideos(
                                url: Uri.parse(homeController.videos[v].link!));
                          } else if (homeController
                              .videos[v].videoController!.value.isInitialized) {
                            homeController.videos[v].videoController!.play();
                          }

                          commentsController.getVideoComments(
                              videoId: homeController.videos[v].id!);

                          // disposing video controller at index + 2 position of the current video
                          if (v < (homeController.videos.length - 1) &&
                              homeController
                                      .videos[homeController.videos.length - 1]
                                      .videoController !=
                                  null) {
                            debugPrint('## CLEARING 2 STEPS BACK');
                            homeController.videos[v + 2].videoController = null;
                          }

                          // disposing video controller at index - 2 position of the current video
                          if (v > 1 &&
                              homeController.videos[v - 2].videoController !=
                                  null) {
                            debugPrint('## CLEARING 2 STEPS AHEAD');
                            homeController.videos[v - 2].videoController = null;
                          }
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if (homeController
                                  .videos[homeController.tempIndex.value]
                                  .videoController!
                                  .value
                                  .isPlaying) {
                                homeController
                                    .videos[homeController.tempIndex.value]
                                    .videoController!
                                    .pause();
                              } else {
                                homeController
                                    .videos[homeController.tempIndex.value]
                                    .videoController!
                                    .play();
                              }
                            },
                            child: Stack(
                              children: [
                                Obx(
                                  () => (homeController.cachingVideo.value)
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : (homeController
                                                  .videos[homeController
                                                      .tempIndex.value]
                                                  .videoController ==
                                              null)
                                          ? Icon(Icons.error_outline)
                                          : SizedBox.expand(
                                              child: FittedBox(
                                              fit: BoxFit.cover,
                                              child: SizedBox(
                                                width: homeController
                                                    .videos[homeController
                                                        .tempIndex.value]
                                                    .videoController!
                                                    .value
                                                    .size
                                                    .width,
                                                height: homeController
                                                    .videos[homeController
                                                        .tempIndex.value]
                                                    .videoController!
                                                    .value
                                                    .size
                                                    .height,
                                                child: Obx(
                                                  () => VideoPlayer(
                                                      homeController
                                                          .videos[homeController
                                                              .tempIndex.value]
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // video label
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 20),
                                        child: Obx(
                                          () => Text(
                                            (homeController.videos.isNotEmpty)
                                                ? 'Video ${homeController.tempIndex.value + 1}'
                                                : '',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: 240,
                                          width: 70,
                                          child: Column(
                                            spacing: 40,
                                            children: [
                                              // like/unlike button
                                              GestureDetector(
                                                onTap: () {
                                                  if (homeController
                                                      .videos.isNotEmpty) {
                                                    homeController.updateVideoLike(
                                                        videoId: homeController
                                                            .videos[
                                                                homeController
                                                                    .tempIndex
                                                                    .value]
                                                            .id!);
                                                  }
                                                },
                                                child: Obx(() => Icon(
                                                      Icons.thumb_up,
                                                      color: (homeController.videosStats.indexWhere((stat) =>
                                                                      stat.videoId ==
                                                                      homeController
                                                                          .videos[homeController
                                                                              .tempIndex
                                                                              .value]
                                                                          .id) >
                                                                  -1 &&
                                                              homeController
                                                                  .videosStats
                                                                  .isNotEmpty)
                                                          ? Colors.red
                                                          : Colors.white,
                                                    )),
                                              ),

                                              // favorite/unfavorite button
                                              GestureDetector(
                                                onTap: () {
                                                  if (homeController
                                                      .videos.isNotEmpty) {
                                                    favoritesController
                                                        .updateFavoriteVideo(
                                                            video: homeController
                                                                    .videos[
                                                                homeController
                                                                    .tempIndex
                                                                    .value]);
                                                  }
                                                },
                                                child: Obx(() => Icon(
                                                      Icons.favorite,
                                                      color: (favoritesController.favoriteVideos.indexWhere((fav) =>
                                                                      fav.videoId ==
                                                                      homeController
                                                                          .videos[homeController
                                                                              .tempIndex
                                                                              .value]
                                                                          .id) >
                                                                  -1 &&
                                                              favoritesController
                                                                  .favoriteVideos
                                                                  .isNotEmpty)
                                                          ? Colors.red
                                                          : Colors.white,
                                                    )),
                                              ),

                                              // comment section
                                              GestureDetector(
                                                  onTap: () {
                                                    if (homeController
                                                        .videos.isNotEmpty) {
                                                      homeController
                                                          .videos[homeController
                                                              .tempIndex.value]
                                                          .videoController!
                                                          .pause();
                                                      commentPopUp(
                                                              context: context,
                                                              videoId: homeController
                                                                  .videos[homeController
                                                                      .tempIndex
                                                                      .value]
                                                                  .id!)
                                                          .whenComplete(() {
                                                        if (commentsController
                                                            .timer.isActive) {
                                                          commentsController
                                                              .timer
                                                              .cancel();
                                                        }
                                                        homeController
                                                            .videos[
                                                                homeController
                                                                    .tempIndex
                                                                    .value]
                                                            .videoController!
                                                            .play();
                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.comment,
                                                    color: Colors.white,
                                                  )),

                                              // share button
                                              GestureDetector(
                                                  onTap: () {
                                                    if (homeController
                                                        .videos.isNotEmpty) {
                                                      homeController
                                                          .videos[homeController
                                                              .tempIndex.value]
                                                          .videoController!
                                                          .pause();
                                                      homeController.onShareVideo(
                                                          link: homeController
                                                              .videos[
                                                                  homeController
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
