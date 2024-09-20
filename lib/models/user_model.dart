
// $table->string('name');
// $table->string('first_name')->nullable();
// $table->string('email')->unique();
// $table->string("telephone")->nullable();
// $table->string("photo")->nullable();
// $table->string("sexe")->nullable();
// $table->string("adresse")->nullable();
// $table->string("role")->nullable();

class UserModel{
  int? id;
  String? first_name;
  String? name;
  String? email;
  String? telephone;
  String? photo;
  String? password;
  String? sexe;
  String? adresse;
  String? role;


  UserModel({this.id, this.first_name, this.name, this.email, this.telephone,
      this.photo,
      this.password,
    this.sexe, this.adresse, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id:json['id'],
      name: json['name'],
      first_name: json['first_name'],
      email:json['email'],
      telephone: json['telephone'],
      photo: json['photo'],
      password: json['password'],
      sexe: json['sexe'],
      adresse: json['adresse'],
      role: json['role'],

    );
  }
}