import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/feature/comments/controllers/comments_controller.dart';

Future commentPopUp({required BuildContext context, required String videoId}) {
  CommentsController commentsController = Get.find<CommentsController>();
  commentsController.getVideoComments(videoId: videoId);

  return Get.bottomSheet(Container(
    height: 500,
    color: Colors.white,
    child: SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        spacing: 10,
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            height: 2,
            width: 20,
            color: Colors.grey,
          ),
          Text(
            'Comments',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 300,
            child: Obx(
              () => (commentsController.loadingComments.value)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : (commentsController.videoComments.isNotEmpty)
                      ? ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onLongPress: () {
                                if (commentsController
                                        .videoComments[index].userId! ==
                                    commentsController
                                        .homeController.userId.value!.email) {
                                  deleteCommentPopUP(
                                      commentId: commentsController
                                          .videoComments[index].id!);
                                }
                              },
                              title: Text(commentsController
                                  .videoComments[index].userId!),
                              subtitle: Text(commentsController
                                  .videoComments[index].comment!),
                            );
                          },
                          itemCount: commentsController.videoComments.length,
                        )
                      : Center(
                          child: Text(
                              textAlign: TextAlign.center,
                              'No comments so far...\nBe the first one to leave a comment.'),
                        ),
            ),
          ),
          Divider(
            endIndent: 10,
            indent: 10,
          ),
          Focus(
            onFocusChange: (f) {
              if (commentsController.timer.isActive) {
                commentsController.timer.cancel();
              }
            },
            child: TextFormField(
              controller: commentsController.commentController.value,
              decoration: InputDecoration(
                  suffix: GestureDetector(
                    onTap: () async {
                      await commentsController.addVideoComment(
                          videoId: videoId,
                          comment:
                              commentsController.commentController.value.text);
                    },
                    child: Icon(Icons.send),
                  ),
                  hintText: "What's on your mind...",
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10)),
            ),
          )
        ],
      ),
    ),
  ));
}

Future deleteCommentPopUP({required String commentId}) {
  CommentsController commentsController = Get.find<CommentsController>();
  return Get.bottomSheet(Container(
    height: 200,
    color: Colors.white,
    child: Column(
      spacing: 10,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          height: 2,
          width: 20,
          color: Colors.grey,
        ),
        Text(
          'Deletion confirmation',
          style: TextStyle(fontSize: 18),
        ),
        Expanded(
          child: Center(
            child: Text(
                textAlign: TextAlign.center,
                'Are you sure you want to delete your comment?\nIt cannot be undone.'),
          ),
        ),
        // Divider(
        //   endIndent: 10,
        //   indent: 10,
        // ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: SizedBox(
                  height: 45,
                  child: Center(child: Text('Cancel')),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.back();
                  commentsController.deleteComment(commentId: commentId);
                },
                child: Container(
                  color: Colors.green,
                  height: 45,
                  child: Center(
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  ));
}
