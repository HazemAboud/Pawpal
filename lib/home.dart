import 'package:flutter/material.dart';
import 'package:pawpal/login.dart';
import 'package:pawpal/models/user.dart';

class HomeMenu extends StatefulWidget {
  final User user;
  const HomeMenu({super.key, required this.user});
  
  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PawPal'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome ${widget.user.userName}!'), 
            Text('Email: ${widget.user.email}'), 
            Text('Phone: ${widget.user.phone}'), 
            Text('Registration Date: ${widget.user.regDate}'),
            SizedBox(height: 20),
            TextButton(onPressed: (){
              logout();
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  LoginMenu()),
            );
            }, child: Text('Log out'))
          ],
        ),
      )
    );
  }
}