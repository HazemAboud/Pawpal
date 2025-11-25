import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'url.dart';
import 'dart:convert';
import 'register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'models/user.dart';

class LoginMenu extends StatefulWidget {
  const LoginMenu({super.key});

  @override
  State<LoginMenu> createState() => _LoginMenuState();
}

class _LoginMenuState extends State<LoginMenu> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool rememberMe = false;
  bool isInvisible = true;
  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenwidth * 0.8,
            child: Column(
              children: [
                const SizedBox(height: 100),
                Image.asset('assets/images/splash.png', scale: 2),
                const Text(
                  'Log in',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    constraints: BoxConstraints(maxWidth: screenwidth * 0.7),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: passwordController,
                  obscureText: isInvisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    constraints: BoxConstraints(maxWidth: screenwidth * 0.7),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (isInvisible) {
                            isInvisible = false;
                          } else {
                            isInvisible = true;
                          }
                          setState(() {});
                        },
                        icon: Icon(Icons.visibility),
                      ),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Remember me'),
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                          updatePreferences(rememberMe);
                        });
                      },
                    ),
                    SizedBox(width: (screenwidth * 0.2) - 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {
                        validateInput();
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      style: TextButton.styleFrom(fixedSize: Size(80, 10)),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterMenu(),
                          ),
                        );
                      },
                      child: Text('Sign up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateInput() {
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All fields are required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email format'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    loginuser(email, password);
    updatePreferences(rememberMe);
  }

  void loginuser(String? email, String? password) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Logging in...'),
            ],
          ),
        );
      },
    );
    await
    http.post(
          Uri.parse('${URL.baseUrl}/pawpal/server/login_user.php'),
          body: {'email': email, 'password': password},
        )
        .then((response) {
          var res = jsonDecode(response.body);
          print(res.toString());
          Navigator.of(context).pop();
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Log in Successful'),
                backgroundColor: Colors.green,
              ),
            );
            var userdata = res['user'];    
            User user = User.fromJson(userdata);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  HomeMenu(user: user)),
            );
          } else {
            var res = jsonDecode(response.body);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Log in Failed ' + res['message']),
                backgroundColor: Colors.red,
              ),
            );
          }
        })
        .catchError((error) {
          Navigator.of(context).pop();
          print(error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }

  void updatePreferences(bool rememberMe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', rememberMe);
    if (rememberMe) {
      prefs.setString('email', emailController.text.trim());
      prefs.setString('password', passwordController.text.trim());
    } else {
      prefs.remove('email');
      prefs.remove('password');
    }
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rm = prefs.getBool('rememberMe');
      
      if (rm != null && rm) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        loginuser(email, password);
        rememberMe = true;
      }
    });
  }
}
void logout() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', false);
    prefs.remove('email');
    prefs.remove('password');
}

