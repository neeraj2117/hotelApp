import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String? uid;
  String? imageProfile;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? city;
  String? state;
  String? country;
  String? gender;
  String? address;

  Person({
    required this.uid,
    required this.imageProfile,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.city,
    required this.state,
    required this.country,
    required this.gender,
    required this.address,
  });

  static Person fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return Person(
      uid: dataSnapshot["uid"],
      imageProfile: dataSnapshot["imageProfile"],
      name: dataSnapshot["name"],
      email: dataSnapshot["email"],
      password: dataSnapshot["password"],
      phone: dataSnapshot["phone"],
      city: dataSnapshot["city"],
      state: dataSnapshot["state"],
      country: dataSnapshot["country"],
      gender: dataSnapshot["gender"],
      address: dataSnapshot["address"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "imageProfile": imageProfile,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "city": city,
        "state": state,
        "country": country,
        "gender": gender,
        "address": address,
      };
}
