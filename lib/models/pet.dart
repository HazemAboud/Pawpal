import 'package:geocoding/geocoding.dart';

class Pet {
  String? petId;
  String? userId;
  String? petName;
  String? petType;
  String? category;
  String? description;
  String? lat;
  String? lng;
  List<String>? imagePaths;
  String? address;
  String? createdAt;

  Pet({
    this.petId,
    this.userId,
    this.petName,
    this.petType,
    this.category,
    this.description,
    this.imagePaths,
    this.lat,
    this.lng,
    this.createdAt,
  });

  Pet.fromJson(Map<String, dynamic> json){
    petId = json['pet_id']?.toString();
    userId = json['user_id']?.toString();
    petName = json['pet_name'];
    petType = json['pet_type'];
    category = json['category'];
    description = json['description'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    createdAt = json['created_at'];
    imagePaths = List<String>.from(json['image_paths']);
  }
  setAddress() async {
    List<Placemark> placemarks =await placemarkFromCoordinates(double.parse(lat ?? '0'), double.parse(lng ?? '0'));
    Placemark place = placemarks[0];
    address = "${place.name},${place.street},${place.locality},${place.administrativeArea},${place.country}";
  }
  Map<String, dynamic> toJson() {
    return {
      'pet_id': petId,
      'user_id': userId,
      'pet_name': petName,
      'pet_type': petType,
      'category': category,
      'description': description,
      'lat': lat,
      'long': lng,
      'address': address,
      'created_at': createdAt,
      'image_paths': imagePaths,
    };
  }
}
