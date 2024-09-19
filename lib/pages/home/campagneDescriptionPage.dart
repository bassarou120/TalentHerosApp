import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talentherosapp/controllers/campagne_controller.dart';
import 'package:talentherosapp/utils/app_constants.dart';
import 'package:talentherosapp/utils/colors.dart';
import 'package:talentherosapp/utils/dimensions.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CampagneDescriptionPage extends StatelessWidget {
  final int campagneId;

  CampagneDescriptionPage({required this.campagneId});

  @override
  Widget build(BuildContext context) {
    final CampagneController campagneController = Get.find();
    campagneController.getCampagneById(campagneId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                fit: BoxFit.cover,
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
                              fontSize: 24,
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
                                    ? AppColors.ColorGreen
                                    : AppColors.ColorRead,
                                size: Dimensions.iconSize16,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                campagne.status == "EN COURS"
                                    ? 'EN COURS'
                                    : 'Terminé',
                                style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  color: campagne.status == "EN COURS"
                                      ? AppColors.ColorGreen
                                      : AppColors.ColorRead,
                                ),
                              ),
                              SizedBox(width: Dimensions.width30),
                              Icon(Icons.access_time_rounded,
                                  size: Dimensions.iconSize16,
                                  color: AppColors.iconColor2),
                              SizedBox(width: Dimensions.width10),
                              Text(
                                'Date de fin: ${campagne.date_fin}',
                                style: TextStyle(fontSize: Dimensions.font16),
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
                                color: AppColors.titleColor),
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
        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
        color: Colors.white,
        child: Row(
          children: [
            // Bouton Postuler
            Expanded(
              child: InkWell(
                onTap: () {
                  showPostulerDialog(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Postuler',
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

  void showPostulerDialog(BuildContext context) {
  // Initialisation des contrôleurs de texte
  TextEditingController descriptionController = TextEditingController();
  File? videoFile;

  final ImagePicker _picker = ImagePicker();

  // Fonction pour choisir une vidéo depuis la galerie
  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      videoFile = File(pickedFile.path);
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Postuler à la Campagne',
          style: TextStyle(
            color: AppColors.mainBlackColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bouton pour sélectionner la vidéo
              ElevatedButton(
                onPressed: _pickVideo,
                child: Text('Sélectionner une vidéo'),
              ),
              const SizedBox(height: 10),
              // Afficher le nom du fichier sélectionné
              if (videoFile != null)
                Text(
                  'Vidéo sélectionnée: ${videoFile!.path.split('/').last}',
                  style: TextStyle(color: AppColors.mainBlackColor),
                ),
              const SizedBox(height: 10),
              // Champ pour la description
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: AppColors.mainBlackColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.mainColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.mainColor),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          // Bouton "Envoyer"
          InkWell(
            onTap: () {
              // Récupérer les valeurs des champs de texte et le fichier vidéo lorsque l'utilisateur appuie sur le bouton
              String description = descriptionController.text;
              print('Description: $description');
              if (videoFile != null) {
                print('Vidéo sélectionnée: ${videoFile!.path}');
                // Ajoutez votre logique pour envoyer les données ici
              }
              
              Navigator.of(context).pop(); // Fermer le dialogue
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Envoyer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
}
