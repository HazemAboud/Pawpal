import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/tabs/login.dart';
import 'SubmitPetScreen.dart';
import 'url.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Pet> pets = [];
  bool loading = true;
  bool empty = false;
  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  Future<void> fetchPets() async {
    try {
      final response = await http.get(
        Uri.parse('${URL.baseUrl}/pawpal/server/get_my_pets.php'),
      );
      var res = jsonDecode(response.body);
      if(res['message'] == 'No submissions yet'){
        setState(() {
          loading = false;
          empty = true;
          pets = [];
        });
      }else if (res['success'] == true) {
        final petsLs = res['data'] as List;
        pets = petsLs.map((json) => Pet.fromJson(json)).toList();
        for (var pet in pets) {
          pet.setAddress();
        }
        setState(() {
          loading = false;
        });
      }else{
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error fetching pets: ${res['message']}')));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching pets: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPetScreen(user: widget.user),
            ),
          );
        },
        child: const Icon(Icons.pets),
      ),
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginMenu()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              fetchPets();
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (loading) const Center(child: CircularProgressIndicator()),

              if (empty)
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No submissions yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

              for (var pet in pets)
                Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                          Image.network(
                            "${URL.baseUrl}/pawpal/server/${pet.imagePaths![0]}",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pet.petName ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Type: ${pet.petType ?? ''}"),
                              Text("Category: ${pet.category ?? ''}"),
                              Text(
                                "Description: ${(pet.description!.length > 15 ? pet.description!.substring(0, 15) + "..." : pet.description!)}",
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => showPetDetailsDialog(pet),
                          child: const Text('Details'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showPetDetailsDialog(Pet pet) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.petName ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Type: ${pet.petType ?? ''}"),
                  Text("Category: ${pet.category ?? ''}"),
                  Text("Submission Type: ${pet.category ?? ''}"),
                  Text("Description: ${pet.description ?? ''}"),
                  Text("Address: ${pet.address ?? ''}"),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      for (var img in pet.imagePaths!)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Image.network(
                            "${URL.baseUrl}/pawpal/server/$img",
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
