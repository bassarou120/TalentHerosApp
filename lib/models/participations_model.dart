class ParticipationModel {
  int id;
  String description;
  String video;
  String? rang;  // rang peut être null
  String? campagne_image;  // rang peut être null
  String campagneTitre;
  int campagneId;
  int userId;
  String? status;  // status peut être null
  String etat;
  DateTime createdAt;
  DateTime updatedAt;

  ParticipationModel({
    required this.id,
    required this.description,
    required this.video,
    this.rang,  // Peut être null, donc facultatif
    this.campagne_image,  // Peut être null, donc facultatif
    required this.campagneTitre,
    required this.campagneId,
    required this.userId,
    this.status,  // Peut être null, donc facultatif
    required this.etat,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory pour créer une instance à partir d'un JSON
  factory ParticipationModel.fromJson(Map<String, dynamic> json) {
    return ParticipationModel(
      id: json['id'],
      description: json['description'],
      video: json['video'],
      rang: json['rang'],  // Peut être null, donc ne pas utiliser 'required'
      campagne_image: json['campagne_image'],  // Peut être null, donc ne pas utiliser 'required'
      campagneTitre: json['campagne_titre'],
      campagneId: json['campagne_id'],
      userId: json['user_id'],
      status: json['status'],  // Peut être null
      etat: json['etat'],
      createdAt: DateTime.parse(json['created_at']),  // Convertir la date en DateTime
      updatedAt: DateTime.parse(json['updated_at']),  // Convertir la date en DateTime
    );
  }

  // Pour convertir en JSON (si nécessaire)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'video': video,
      'rang': rang,
      'campagne_image': campagne_image,
      'campagne_titre': campagneTitre,
      'campagne_id': campagneId,
      'user_id': userId,
      'status': status,
      'etat': etat,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/*
class ParticipationModel{
  int? id;
  String? description;
  String? video;
  String? rang;
  String? status;
  String? etat;
  int? user_id;
  String? campagne_titre;
  int? campagne_id;
  String? created_at;
  String? updated_at;


  ParticipationModel({this.id, this.description, this.video, this.rang,
    this.status,this.user_id,this.etat, this.campagne_titre, this.campagne_id, this.created_at,
    this.updated_at});


  @override
  String toString() {
    return 'ParticipationModel{id: $id, description: $description, video: $video, rang: $rang, status: $status, etat: $etat, user_id: $user_id, campagne_titre: $campagne_titre, campagne_id: $campagne_id, created_at: $created_at, updated_at: $updated_at}';
  }

  ParticipationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description=json['description'];
    video=json['video'];
    rang=json['rang'];
    campagne_titre=json['campagne_titre'];
    campagne_id=json['campagne_id'];
    user_id=json['user_id'];
    status=json['status'];
    etat=json['etat'];
    created_at=json['created_at'];
    updated_at=json['updated_at'];


  }

  Map<String, dynamic> toJson(){
    return{
    "id" :this.id,
    "description":this.description,
    "video":this.video,
   "rang":this.rang,
    "campagne_titre":this.campagne_titre,
    "campagne_id":this.campagne_id,
    "user_id":this.user_id,
    "status":this.status,
    "created_at":this.created_at,
    "updated_at":this.updated_at
    };
  }
}
*/

// {id: 8, campagne_id: 4, user_id: 14, video: videos/ubDQEa2jcDkhmBalTwOKZBZSUpOWedbSqUkpU5y3.mov, description: tu, created_at: 2024-09-23T12:36:51.000000Z, updated_at: 2024-09-23T12:36:51.000000Z, status: null, rang: null, etat: EN COURS, campagne_titre: challenge meilleur cuisinier, campagne: {id: 4, titre: challenge meilleur cuisinier, description: bgdfgd, date_debut: 2024-09-10, date_fin: 2024-09-12, image: /campagne_image/4/01J80KVYJZN7RW3WHD4GZA3F1F.jpg, visibilite: TOUT LE MONDE, status: EN COURS, created_at: 2024-09-17T18:28:12.000000Z, updated_at: 2024-09-17T18:28:12.000000Z, publication_gagnante: null, nbr_participant: null}}