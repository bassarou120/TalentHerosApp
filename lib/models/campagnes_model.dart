class Campagne {
  int? _totalSize;
  int? _typeId;
  int? _offset;
  late List<CampagneModel> _campagnes;
  List<CampagneModel> get campagnes=>_campagnes;

  Campagne({required totalSize, required typeId, required offset, required campagnes}){
    this._totalSize=totalSize;
    this._totalSize=totalSize;
    this._typeId=typeId;
    this._offset=offset;
    this._campagnes=campagnes;
  }

  Campagne.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _typeId = json['type_id'];
    _offset = json['offset'];
    if (json['campagnes'] != null) {
      _campagnes = <CampagneModel>[];
      json['campagnes'].forEach((v) {
        _campagnes.add(CampagneModel.fromJson(v));
      });
    }
  }

}



class CampagneModel {
  int? id;
  String? titre;
  String? description;
  String? date_debut;
  String? date_fin;
  String? image;
  int? publication_gagante;
  String? visibilite;
  String? status;
  String? created_at;
  String? updated_at;


  CampagneModel(
  {this.id,
      this.titre,
      this.description,
      this.date_debut,
      this.date_fin,
      this.image,
      this.publication_gagante,
      this.visibilite,
      this.status,
      this.created_at,
      this.updated_at});




  CampagneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titre =json['titre'];
    description=json['description'];
    date_debut=json['date_debut'];
    date_fin=json['date_fin'];
    image=json['image'];
    publication_gagante=json['publication_gagante'];
    visibilite=json['visibilite'];
    status=json['status'];
    created_at=json['created_at'];
    updated_at=json['updated_at'];


  }

  Map<String, dynamic> toJson(){
    return{
    "id" :this.id,
    "titre":titre,
    "description":this.description,
    "date_debut":this.date_debut,
    "date_fin":this.date_fin,
    "image":this.image,
    "publication_gagante":publication_gagante,
    "visibilite":this.visibilite,
    "status":this.status,
    "created_at":this.created_at,
    "updated_at":this.updated_at
    };
  }
}