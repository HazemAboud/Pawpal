PawPal

Module 1: User authentication

App Screenshots:
![alt text](<Screenshot 2025-11-25 224906.png>)
![alt text](<Screenshot 2025-11-25 225021.png>)
![alt text](<Screenshot 2025-11-25 225205.png>)
![alt text](<Screenshot 2025-11-25 225312.png>)

JSON response:

•	Registration:
{status: error, message: Email already registered.}

{status: success, message: Registered successfully.}
•	Log in:
{status: error, message: Incorrect password.}

{status: success, message: Login successful, user: {user_id: 35, name: Hazem, email: hazem@gmail.com, password: e87acbc52d009d6a1d619f235198765c663e4ebe, phone: 01209283874, reg_date: 2025-11-25 22:22:44.345830}

Links:

Github: 

YouTube: https://youtu.be/uxUQIvvrsTE

Dart code segment for handling Json response for user registration:

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
          if (response.statusCode == 200) {
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








User Class:
class User {
  String? userId;
  String? userName;
  String? email;
  String? password;
  String? phone;
  String? regDate;

  User(
      {this.userId,
      this.email,
      this.userName,
      this.phone,
      this.password,
      this.regDate});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    regDate = json['reg_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = userName;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['reg_date'] = regDate;
    return data;
  }
}




Database screenshot for user data model:
 
![alt text](<Screenshot 2025-11-25 225809.png>)