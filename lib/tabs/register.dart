import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'url.dart';
import 'dart:convert';
import 'login.dart';


class RegisterMenu extends StatefulWidget {
  const RegisterMenu({super.key});

  @override
  State<RegisterMenu> createState() => _RegisterMenuState();
}

class _RegisterMenuState extends State<RegisterMenu> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isInvisible = true;
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
                  'Registration',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    constraints: BoxConstraints(maxWidth: screenwidth * 0.7),
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 5),
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
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    constraints: BoxConstraints(maxWidth: screenwidth * 0.7),
                    labelText: 'Phone Number',
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
                const SizedBox(height: 5),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: isInvisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    constraints: BoxConstraints(maxWidth: screenwidth * 0.7),
                    labelText: 'Confirm Password',
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
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    validateInput();
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    TextButton(
                      style: TextButton.styleFrom(fixedSize: Size(70, 10)),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginMenu()),
                        );
                      },
                      child: Text('Log in'),
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
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All fields are required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 6 characters long'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
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
    if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid phone number format'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    registeruser(username, email, phone, password);
  }


  void registeruser(
    String username,
    String email,
    String phone,
    String password,
  ) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Registering...'),
            ],
          ),
        );
      },
    );
    await
    http
        .post(
          Uri.parse('${URL.baseUrl}/pawpal/server/register_user.php'),
          body: {
            'name': username,
            'email': email,
            'phone': phone,
            'password': password,
          },
        )
        .then((response) {
          var res = jsonDecode(response.body);
          print(res.toString());
          Navigator.of(context).pop();
          if (res['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Registration Successful'),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(Duration(seconds: 1));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginMenu()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Registration Failed ' + res['message']),
                backgroundColor: Colors.red,
              ),
            );
          }
        })
        .catchError((error) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }
}
