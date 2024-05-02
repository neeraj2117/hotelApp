import 'package:cloud_firestore/cloud_firestore.dart';

class Hotels {
  String? id;
  String? imageProfile;
  String? lookingTo;
  String? KindOfProperty;
  String? PropertyType;
  String? title;
  String? address;
  String? contact;
  String? description;
  String? bedrooms;
  String? bathrooms;
  String? balconies;
  String? furnishing;
  String? parking;
  String? pet;
  String? smoke;
  String? wifi;
  String? price;

  Hotels({
    required this.id,
    required this.imageProfile,
    required this.lookingTo,
    required this.KindOfProperty,
    required this.PropertyType,
    required this.title,
    required this.address,
    required this.contact,
    required this.description,
    required this.bedrooms,
    required this.bathrooms,
    required this.balconies,
    required this.furnishing,
    required this.parking,
    required this.pet,
    required this.smoke,
    required this.wifi,
    required this.price,
  });

  static Hotels fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return Hotels(
      id: dataSnapshot["id"],
      imageProfile: dataSnapshot["imageProfile"],
      lookingTo: dataSnapshot["lookingTo"],
      KindOfProperty: dataSnapshot["KindOfProperty"],
      PropertyType: dataSnapshot["PropertyType"],
      title: dataSnapshot["title"],
      address: dataSnapshot["address"],
      contact: dataSnapshot["contact"],
      description: dataSnapshot["description"],
      bedrooms: dataSnapshot["bedrooms"],
      bathrooms: dataSnapshot["bathrooms"],
      balconies: dataSnapshot["balconies"],
      furnishing: dataSnapshot["furnishing"],
      parking: dataSnapshot["parking"],
      pet: dataSnapshot["pet"],
      smoke: dataSnapshot["smoke"],
      wifi: dataSnapshot["wifi"],
      price: dataSnapshot["price"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageProfile": imageProfile,
        "lookingTo": lookingTo,
        "KindOfProperty": KindOfProperty,
        "PropertyType": PropertyType,
        "title": title,
        "address": address,
        "contact": contact,
        "description": description,
        "bedrooms": bedrooms,
        "bathrooms": bathrooms,
        "balconies": balconies,
        "furnishing": furnishing,
        "parking": parking,
        "pet": pet,
        "smoke": smoke,
        "wifi": wifi,
        "price": price,
      };

  bool isInFavorites(List<Hotels> favorites) {
    return favorites.any((element) => element.id == id);
  }
}
