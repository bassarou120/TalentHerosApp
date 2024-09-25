import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talentherosapp/controllers/auth_controller.dart';
import 'package:talentherosapp/controllers/campagne_controller.dart';
import 'package:talentherosapp/utils/app_constants.dart';
import 'package:talentherosapp/utils/colors.dart';
import 'package:talentherosapp/utils/dimensions.dart';
import 'package:http/http.dart' as http;
import 'package:talentherosapp/widgets/app_text_field.dart';
import 'package:talentherosapp/widgets/big_text.dart';
import 'package:video_player/video_player.dart';

class CampagneDescriptionPage extends StatefulWidget {
  final int campagneId;

  CampagneDescriptionPage({required this.campagneId});

  @override
  _CampagneDescriptionPageState createState() => _CampagneDescriptionPageState();
}

class _CampagneDescriptionPageState extends State<CampagneDescriptionPage> {
  final TextEditingController descriptionController = TextEditingController();
  File? videoFile;
  VideoPlayerController? _videoPlayerController;

  bool isPlaying = false;
  bool isLoading = false;
  String token="";

  @override
  void dispose() {
    // Libérer le contrôleur lorsque le widget est supprimé
    descriptionController.dispose();
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


  @override
  Widget build(BuildContext context) {
    final CampagneController campagneController = Get.find();
    final AuthController authController = Get.find();
    campagneController.getCampagneById(widget.campagneId);

    token=authController.getUserToken();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(
          "Campagne",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.chevron_left, color: Colors.black),
        ),
      ),
      body: GetBuilder<CampagneController>(builder: (controller) {
        if (!controller.isLoaded) {
          return Center(child: CircularProgressIndicator(color: Colors.blue));
        }

        var campagne = controller.campagne;
        if (campagne == null) {
          return Center(child: Text('Campagne non trouvée'));
        }

        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Image.network(
                '${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}${campagne.image}',
                fit: BoxFit.contain,
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.only(top: 40, right: 14, left: 14),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child:
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            campagne.titre ?? '',
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
                                color: campagne.status == "EN COURS"
                                    ? AppColors.ColorGreen:AppColors.ColorRead,
                                size: Dimensions.iconSize16,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                campagne.status == "EN COURS"
                                    ? 'EN COURS'
                                    : 'Terminé',
                                style: TextStyle(
                                  fontSize: Dimensions.font12,
                                  color: campagne.status == "EN COURS"
                                      ? AppColors.ColorGreen:AppColors.ColorRead,
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
                                'Debut: ${campagne.date_debut}',
                                style: TextStyle(fontSize: Dimensions.font12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.visibility,
                                color:  AppColors.iconColor2 ,
                                size: Dimensions.iconSize16,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                campagne.visibilite!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: Dimensions.font12-1,

                                  // color: campagne.status == "EN COURS"
                                  //     ? AppColors.ColorGreen:AppColors.ColorRead,
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
                                'Fin: ${campagne.date_fin}',
                                style: TextStyle(fontSize: Dimensions.font12),
                              ),
                            ],
                          ),
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
                            campagne.description ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.signColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
        color: Colors.white,
        child: Row(
          children: [
            // Bouton Postuler
            Expanded(
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => _buildParticipationForm(context),
                  ).then((onValue){

                    descriptionController.clear();
                  _videoPlayerController=null;

                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Participer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour afficher le formulaire de participation
  Widget _buildParticipationForm(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start, // Aligner en haut
          crossAxisAlignment: CrossAxisAlignment.center, // Centrer horizontalement

          children: [
            BigText(text: "Participation"),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                child:  Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                        textController: descriptionController,
                        hintText: "Description",
                        isObscure: false,
                        icon: Icons.description),
                    // TextField(
                    //   controller: descriptionController,
                    //   decoration: InputDecoration(labelText: 'Description'),
                    //   maxLines: 3,
                    // ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        // Code pour sélectionner une vidéo
                        final pickedFile = await ImagePicker().pickVideo(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            videoFile = File(pickedFile.path);
                            print("ici");

                            _videoPlayerController =
                            VideoPlayerController.file(videoFile!)
                              ..initialize().then((_) {
                                setState(() {}); // Actualiser pour afficher la vidéo
                                _videoPlayerController!.play(); // Lire automatiquement la vidéo
                              });

                          });
                        }
                      },
                      child: Text('Télécharger Vidéo'),
                    ),
                    const SizedBox(height: 20),

                    _videoPlayerController != null && _videoPlayerController!.value.isInitialized
                        ? Column(
                          children: [
                            AspectRatio(
                                                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                                                  child: VideoPlayer(_videoPlayerController!,
                                                  ),
                                                ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                                  onPressed: _togglePlayPause,
                                ),
                                IconButton(
                                  icon: Icon(Icons.stop),
                                  onPressed: _stopVideo,
                                ),
                              ],
                            ),
                          ],
                        )
                        : Container(
                      child: Text("..."),
                    ),
                    const SizedBox(height: 10),
                    isLoading // Afficher le spinner si l'envoi est en cours
                        ? Center(child: CircularProgressIndicator()):
                    ElevatedButton(
                      onPressed: () {
                        if (videoFile != null &&
                            descriptionController.text.isNotEmpty) {
                          // Logique pour envoyer les données à l'API Laravel
                          _submitParticipation(videoFile!, descriptionController.text,token);
                          // Get.back();
                        } else {
                          // Afficher une erreur si la vidéo ou la description est manquante
                          Get.snackbar('Erreur', 'Veuillez ajouter une vidéo et une description.',snackPosition:SnackPosition.BOTTOM);
                        }
                      },
                      child: Text('Envoyer'),
                    ),
                  ],
                ),
              )

            ),
          ],
        ),
      );
  }

  // Fonction pour envoyer la vidéo et la description à l'API
  Future<void> _submitParticipation(File video, String description, String token) async {
    // Utilisez un package comme 'http' pour envoyer la vidéo et la description à l'API Laravel
    setState(() {
      isLoading = true; // Activer le spinner pendant l'envoi
    });
    try {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.BASE_URL}/api/participer'),

    );

   print('voici mon token --------->>>>>'+token);
    // Ajout des en-têtes à la requête
    request.headers.addAll({
      'Authorization': 'Bearer $token', // Exemple pour un token d'authentification
      // 'Content-Type': 'multipart/form-data',
      // Ajoutez d'autres en-têtes si nécessaire
    });
    request.fields['description'] = description;
    request.fields['campagne_id'] = widget.campagneId.toString();
    request.files.add(await http.MultipartFile.fromPath('video', video.path));

    // Envoi de la requête
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);  // Convertir en réponse normale

    print(response.statusCode);
    print(response.body);


    if (response.statusCode == 200) {
      Get.snackbar('Succès', 'Participation envoyée avec succès.',snackPosition:SnackPosition.TOP,duration: Duration(seconds: 15));
      // Get.back();

      descriptionController.clear();
      _videoPlayerController=null;

      setState(() {
        isLoading = false;
      });
    } else {
      Get.snackbar('Erreur', 'Échec de l\'envoi de la participation.',snackPosition:SnackPosition.BOTTOM,duration: Duration(seconds: 30));
    }

    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue : $e',snackPosition:SnackPosition.BOTTOM);
      print(e);

      setState(() {
        isLoading = false;
      });
    }


  }
}



/*
class CampagneDescriptionPage extends StatelessWidget {
  final int campagneId;

  CampagneDescriptionPage({required this.campagneId});

  @override
  Widget build(BuildContext context) {
    final CampagneController campagneController = Get.find();
    campagneController.getCampagneById(campagneId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text("Campagne",
        style: TextStyle(color: Colors.white),),
        // backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.chevron_left, color: Colors.black),
        ),
      ),
      body: GetBuilder<CampagneController>(builder: (controller) {
        if (!controller.isLoaded) {
          return Center(child: CircularProgressIndicator(color: Colors.blue));
        }

        var campagne = controller.campagne;
        if (campagne == null) {
          return Center(child: Text('Campagne non trouvée'));
        }

        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Image.network(
                '${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}${campagne.image}',
                fit: BoxFit.contain,
              ),
            ),

            // Section de description
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 40, right: 14, left: 14),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre de la campagne
                          Text(
                            campagne.titre ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainBlackColor,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Détails de la campagne (status, date)
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: campagne.status == "EN COURS"
                                    ? AppColors.ColorGreen:AppColors.ColorRead,
                                size: Dimensions.iconSize16,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                campagne.status == "EN COURS"
                                    ? 'EN COURS'
                                    : 'Terminé',
                                style: TextStyle(
                                  fontSize: Dimensions.font12,
                                  color: campagne.status == "EN COURS"
                                      ? AppColors.ColorGreen:AppColors.ColorRead,
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
                                'Debut: ${campagne.date_debut}',
                                style: TextStyle(fontSize: Dimensions.font12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.visibility,
                                color:  AppColors.iconColor2 ,
                                size: Dimensions.iconSize16,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                campagne.visibilite!,
                                style: TextStyle(
                                  fontSize: Dimensions.font12,
                                  // color: campagne.status == "EN COURS"
                                  //     ? AppColors.ColorGreen:AppColors.ColorRead,
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
                                'Fin: ${campagne.date_fin}',
                                style: TextStyle(fontSize: Dimensions.font12),
                              ),
                            ],
                          ),
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
                            campagne.description ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.signColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Petit élément  en haut du conteneur
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20 ),
        color: Colors.white,
        child: Row(
          children: [
            // Bouton Postuler
            Expanded(
              child: InkWell(
                onTap: () {
                  // Logique pour postuler à la campagne
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildParticipationForm(context),
                  );

                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Participer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour afficher le formulaire de participation au centre
  Widget _buildParticipationForm(BuildContext context) {
    final TextEditingController descriptionController = TextEditingController();
    File? videoFile;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // Code pour sélectionner une vidéo (en utilisant package 'image_picker' par exemple)
                  final pickedFile = await ImagePicker().pickVideo(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    videoFile = File(pickedFile.path);
                  }
                },
                child: Text('Télécharger Vidéo'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (videoFile != null &&
                      descriptionController.text.isNotEmpty) {
                    // Logique pour envoyer les données à l'API Laravel
                    _submitParticipation(videoFile!, descriptionController.text);
                    Get.back();
                  } else {
                    // Afficher une erreur si la vidéo ou la description est manquante
                    Get.snackbar('Erreur', 'Veuillez ajouter une vidéo et une description.');
                  }
                },
                child: Text('Envoyer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // // Fonction pour afficher le formulaire de participation
  // Widget _buildParticipationForm(BuildContext context) {
  //   final TextEditingController descriptionController =
  //   TextEditingController();
  //   File? videoFile;
  //
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           AppTextField(
  //               textController: descriptionController, hintText: "Description",
  //               icon: Icons.description
  //           ),
  //           // TextField(
  //           //   controller: descriptionController,
  //           //   decoration: InputDecoration(labelText: 'Description'),
  //           //   maxLines: 3,
  //           // ),
  //           const SizedBox(height: 10),
  //           ElevatedButton(
  //             onPressed: () async {
  //               // Code pour sélectionner une vidéo (en utilisant package 'image_picker' par exemple)
  //               final pickedFile = await ImagePicker().pickVideo(
  //                 source: ImageSource.gallery,
  //               );
  //               if (pickedFile != null) {
  //                 videoFile = File(pickedFile.path);
  //               }
  //             },
  //             child: Text('Télécharger Vidéo'),
  //           ),
  //           const SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (videoFile != null && descriptionController.text.isNotEmpty) {
  //                 // Logique pour envoyer les données à l'API Laravel
  //                 _submitParticipation(videoFile!, descriptionController.text);
  //                 Get.back();
  //               } else {
  //                 // Afficher une erreur si la vidéo ou la description est manquante
  //                 Get.snackbar('Erreur', 'Veuillez ajouter une vidéo et une description.');
  //               }
  //             },
  //             child: Text('Envoyer'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Fonction pour envoyer la vidéo et la description à l'API
  Future<void> _submitParticipation(File video, String description) async {
    // Utilisez un package comme 'http' pour envoyer la vidéo et la description à l'API Laravel
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.BASE_URL}/api/participer'),
    );
    request.fields['description'] = description;
    request.fields['campagne_id'] = campagneId.toString();
    request.files.add(await http.MultipartFile.fromPath('video', video.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      Get.snackbar('Succès', 'Participation envoyée avec succès.');
    } else {
      Get.snackbar('Erreur', 'Échec de l\'envoi de la participation.');
    }
  }

}
*/