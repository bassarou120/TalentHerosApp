class SignUpBody{

  String nom  ;
  String prenom  ;
  String email  ;
  String telephone  ;
  String password ;
  String pays ;
  String genre  ;


  SignUpBody({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.pays,
    required this.password,
    required this.genre,
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["nom"] = this.nom;
    data["prenom"] = this.prenom;
    data['email'] = this.email;
    data['telephone'] = this.telephone;
    data['password'] = this.password;
    data['pays'] = this.pays;
    data['genre'] = this.genre;
    return data;
  }
}