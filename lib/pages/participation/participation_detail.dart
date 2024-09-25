
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:talentherosapp/controllers/participation_controller.dart';
import 'package:talentherosapp/utils/colors.dart';
import 'package:talentherosapp/utils/dimensions.dart';
import 'package:video_player/video_player.dart';

import '../../utils/app_constants.dart';

class ParticipationDetail extends StatefulWidget {

  final int participationId;

  const ParticipationDetail({super.key,required this.participationId });

  @override
  State<ParticipationDetail> createState() => _ParticipationDetailState();
}

class _ParticipationDetailState extends State<ParticipationDetail> {

  late VideoPlayerController? _videoPlayerController;

  bool isPlaying = false;

  final participation = Get.arguments;

  @override
  void initState() {
    super.initState();

    print('${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}/${participation.video}');
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        '${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}/${participation.video}'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });


  }

  @override
  void dispose() {
    // Libérer le contrôleur lorsque le widget est supprimé

    _videoPlayerController?.dispose();
    super.dispose();
  }

  // Fonction pour gérer lecture/pause
  void _togglePlayPause() {
    setState(() {
      if (_videoPlayerController!.value.isPlaying) {
        _videoPlayerController!.pause();
        isPlaying = false;
      } else {
        _videoPlayerController!.play();
        isPlaying = true;
      }
    });
  }

  // Fonction pour arrêter la vidéo et revenir au début
  void _stopVideo() {
    setState(() {
      _videoPlayerController?.pause();
      _videoPlayerController?.seekTo(Duration.zero);
      isPlaying = false;
    });
  }

  String formatDate(DateTime date) {
    // Formater la date dans le format jj/mm/aaaa
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(
          "Ma publication",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.chevron_left, color: Colors.black),
        ),
      ),
        body: GetBuilder<ParticipationController>(builder: (controller) {

          return    Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _videoPlayerController!.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                  )
                      : Container(
                    child:  CircularProgressIndicator(color: Colors.white,),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 35,),
                        onPressed: _togglePlayPause,
                      ),
                      IconButton(
                        icon: Icon(Icons.stop, size: 35,),
                        onPressed: _stopVideo,
                      ),
                    ],
                  ),


                  Text(
                    participation.campagneTitre,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainBlackColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Détails de la campagne
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color:  AppColors.ColorGreen ,
                        size: Dimensions.iconSize16,
                      ),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        participation.status,
                        style: TextStyle(
                          fontSize: Dimensions.font12-1.6,
                          color:  AppColors.ColorGreen ,
                        ),
                      ),
                      SizedBox(width: Dimensions.width30),
                      Icon(
                          Icons.access_time_rounded,
                          size: Dimensions.iconSize16,
                          color: AppColors.iconColor2
                      ),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        'publiée le : '+ formatDate(participation.createdAt),
                        style: TextStyle(fontSize: Dimensions.font12-1.6,
                        overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  const SizedBox(height: 15),
                  // Description
                  Text(
                    'Description :',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    participation.description + '${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}/${participation.video}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.signColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );

    })
    );
  }
}
