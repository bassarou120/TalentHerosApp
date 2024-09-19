import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talentherosapp/controllers/campagne_controller.dart';
import 'package:talentherosapp/utils/app_constants.dart';
import 'package:talentherosapp/utils/dimensions.dart';

class CampagneDescriptionPage extends StatelessWidget {
  final int campagneId;

  CampagneDescriptionPage({required this.campagneId});

  @override
  Widget build(BuildContext context) {
    final CampagneController campagneController = Get.find();
    campagneController.getCampagneById(campagneId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Campagne'),
      ),
      body: GetBuilder<CampagneController>(builder: (controller) {
        if (!controller.isLoaded) {
          return Center(child: CircularProgressIndicator(color: Colors.blue));
        }

        var campagne = controller.campagne;
        if (campagne == null) {
          return Center(child: Text('Campagne non trouvée'));
        }

        // Vérification de l'état de la campagne (en cours ou terminé)
        // bool isCampagneTerminee = DateTime.now().isAfter(DateTime.parse(campagne.date_fin));

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.height15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  '${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}${campagne.image}',
                  fit: BoxFit.cover,
                  height: Dimensions.popularFoodImgSize,
                  width: double.infinity,
                ),
                SizedBox(height: Dimensions.height20),
                Text(
                  campagne.titre ?? '',
                  style: TextStyle(
                    fontSize: Dimensions.font26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Dimensions.height10),
                Row(
                  children: [
                    // Icon(
                    //   Icons.circle,
                    //   color: isCampagneTerminee ? Colors.red : Colors.green,
                    //   size: Dimensions.iconSize16,
                    // ),
                    // SizedBox(width: Dimensions.width10),
                    // Text(
                    //   isCampagneTerminee ? 'Terminé' : 'En cours',
                    //   style: TextStyle(
                    //     fontSize: Dimensions.font16,
                    //     color: isCampagneTerminee ? Colors.red : Colors.green,
                    //   ),
                    // ),
                    SizedBox(width: Dimensions.width30),
                    Icon(
                      Icons.access_time,
                      size: Dimensions.iconSize16,
                    ),
                    SizedBox(width: Dimensions.width10),
                    Text(
                      'Date de fin: ${campagne.date_fin}',
                      style: TextStyle(fontSize: Dimensions.font16),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height20),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Dimensions.height10),
                Text(
                  campagne.description ?? '',
                  style: TextStyle(fontSize: Dimensions.font16),
                ),
                SizedBox(height: Dimensions.height30),
                Center(
                  child: ElevatedButton(
                    onPressed:  () {
                            // Logique pour postuler à la campagne
                          },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.height15,
                        horizontal: Dimensions.width30,
                      ),
                      // primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radius15),
                      ),
                    ),
                    child: Text(
                      'Postuler',
                      style: TextStyle(fontSize: Dimensions.font20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
