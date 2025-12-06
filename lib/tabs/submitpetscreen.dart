import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pawpal/models/user.dart';
import 'mainpage.dart';

class SubmitPetScreen extends StatefulWidget {
  final User user;
  const SubmitPetScreen({super.key, required this.user});

  @override
  State<SubmitPetScreen> createState() => _SubmitPetScreenState();
}

class _SubmitPetScreenState extends State<SubmitPetScreen> {
  TextEditingController petnameCtr = TextEditingController();
  TextEditingController descCtr = TextEditingController();
  TextEditingController addCtr = TextEditingController();
  TextEditingController petTypeCtr = TextEditingController(text: 'Cat');
  var lat = 0.0, lng = 0.0;
  String selectedPetType = 'Cat';
  String selectedSubType = 'Adoption';

  final formKey = GlobalKey<FormState>();

  int currentIndex = 0;
  List<XFile?> images = [];

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Pet'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: screenwidth * 0.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (images.length >= 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You can upload a maximum of 3 images'),
                        ),
                      );
                      return;
                    }
                    pickimagedialog();
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: images.isEmpty
                            ? const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.blueGrey,
                                size: 250,
                              )
                            : Image.file(
                                File(images[currentIndex]!.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                      ),

                      //close button
                      if (images.isNotEmpty)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  images.removeAt(currentIndex);
                                  previousImage();
                                });
                              },
                            ),
                          ),
                        ),

                      // Previous arrow
                      if (images.length > 1)
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: previousImage,
                            ),
                          ),
                        ),

                      // Next arrow
                      if (images.length > 1)
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onPressed: nextImage,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const Text(
                  'Add Pet',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      //pet name
                      TextFormField(
                        controller: petnameCtr,
                        validator: (value) => value!.length < 3
                            ? 'Enter at least 3 characters'
                            : null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pet Name',
                        ),
                      ),

                      const SizedBox(height: 10),

                      //pet type
                      Row(
                        children: [
                          SizedBox(
                            width: screenwidth * 0.6,
                            child: TextFormField(
                              controller: petTypeCtr,
                              readOnly: selectedPetType != 'Other',
                              validator: (value) => value!.length < 3
                                  ? 'Enter at least 3 characters'
                                  : null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Pet Type',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: screenwidth * 0.2 - 10,
                            child: DropdownButton<String>(
                              value: selectedPetType,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Cat',
                                  child: Text('Cat'),
                                ),
                                DropdownMenuItem(
                                  value: 'Dog',
                                  child: Text('Dog'),
                                ),
                                DropdownMenuItem(
                                  value: 'Rabbit',
                                  child: Text('Rabbit'),
                                ),
                                DropdownMenuItem(
                                  value: 'Other',
                                  child: Text('Other'),
                                ),
                              ],
                              onChanged: (newValue) {
                                setState(() {
                                  selectedPetType = newValue!;
                                  petTypeCtr.text = (newValue == 'Other')
                                      ? ''
                                      : newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      //description
                      TextFormField(
                        controller: descCtr,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (value) => value!.length < 10
                            ? 'Enter at least 10 characters'
                            : null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                        ),
                      ),

                      const SizedBox(height: 10),

                      //submission type
                      Row(
                        children: [
                          SizedBox(
                            width: screenwidth * 0.4,
                            child: const Text(
                              "Submission Type",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenwidth * 0.4,
                            child: DropdownButton<String>(
                              value: selectedSubType,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Adoption',
                                  child: Text('Adoption'),
                                ),
                                DropdownMenuItem(
                                  value: 'Donation Request',
                                  child: Text('Donation Request'),
                                ),
                                DropdownMenuItem(
                                  value: 'Help/Rescue',
                                  child: Text('Help/Rescue'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedSubType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      //address
                      TextFormField(
                        controller: addCtr,
                        validator: (value) {
                          if (value!.length < 10) {
                            return 'Address must be at least 10 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Address',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.location_on),
                            onPressed: () async {
                              var loc = await _determinePosition();
                              lat = loc.latitude;
                              lng = loc.longitude;

                              List<Placemark> placemarks =
                                  await placemarkFromCoordinates(lat, lng);

                              setState(() {
                                Placemark place = placemarks[0];
                                addCtr.text =
                                    "${place.name},${place.street},${place.locality},${place.administrativeArea},${place.country}";
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                //submit button
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      if (images.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select at least one image'),
                          ),
                        );
                      } else {
                        List<String> base64Images = [];
                        for (var image in images) {
                          if (image != null) {
                            final bytes = File(image.path).readAsBytesSync();
                            final base64String = base64Encode(bytes);
                            base64Images.add(base64String);
                          }
                        }
                        submitPet(base64Images, lat, lng);
                      }
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.black45, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final imgs = await picker.pickMultiImage();
    if(images.length + imgs.length > 3) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You can only select 3 images')));
    }else if (imgs.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cannot pick image')));
    }else{
      for(var image in imgs) {
      images.add(image);
      setState(() {});
    }
    }
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      images.add(pickedFile);
      setState(() {});
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cannot pick image')));
    }
  }

  void pickimagedialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void nextImage() {
    if (images.isNotEmpty) {
      setState(() {
        currentIndex = (currentIndex + 1) % images.length;
      });
    }
  }

  void previousImage() {
    if (images.isNotEmpty) {
      setState(() {
        currentIndex = (currentIndex - 1 + images.length) % images.length;
      });
    }
  }

  void submitPet(List<String> imgs, var lat, var lng) async {
    Map<String, String> body = {
      'user_id': widget.user.userId.toString(),
      'pet_name': petnameCtr.text.trim(),
      'pet_type': petTypeCtr.text.trim(),
      'category': selectedSubType,
      'description': descCtr.text.trim(),
      'lat': lat.toString(),
      'lng': lng.toString(),
      'images': jsonEncode(imgs),
    };

    try {
      final response = await http.post(
        Uri.parse('${URL.baseUrl}/pawpal/server/submit_pet.php'),
        body: body,
      );

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        if (res['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res['message']),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(user: widget.user),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res['message'] ?? 'Submission failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

//location
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  return await Geolocator.getCurrentPosition();
}
