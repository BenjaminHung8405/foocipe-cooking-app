// lib/presentation/pages/SettingPage/account_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final storage = const FlutterSecureStorage();
  String firstname = '';
  String lastname = '';
  String bio = '';
  String country = '';
  int? age;
  String username = ''; // Thêm biến username
  String email = ''; // Thêm biến email

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // Fetch user info when the widget is initialized
  }

  Future<void> fetchUserInfo() async {
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      print('No access token found');
      return;
    }

    // Gọi API để lấy thông tin người dùng
    final userInfoResponse = await http.get(
      Uri.parse('${dotenv.env['USER_SERVICE_API']}/user/user-info'),
      headers: {
        'access_token': accessToken ?? '',
        'Content-Type': 'application/json',
      },
    );

    if (userInfoResponse.statusCode == 200) {
      final jsonResponse = json.decode(userInfoResponse.body);
      if (jsonResponse['status'] == 'success') {
        setState(() {
          firstname = jsonResponse['data']['firstname'];
          lastname = jsonResponse['data']['lastname'];
          bio = jsonResponse['data']['bio'];
          country = jsonResponse['data']['country'];
          age = jsonResponse['data']['age'];
        });
      }
    } else {
      // Handle error
      throw Exception('Failed to load user info');
    }

    // Gọi API để lấy username và email
    final userResponse = await http.get(
      Uri.parse('${dotenv.env['USER_SERVICE_API']}/user'),
      headers: {
        'access_token': accessToken ?? '',
        'Content-Type': 'application/json',
      },
    );

    if (userResponse.statusCode == 200) {
      final jsonResponse = json.decode(userResponse.body);
      if (jsonResponse['status'] == 'success') {
        setState(() {
          username = jsonResponse['data']['username']; // Thêm username
          email = jsonResponse['data']['email']; // Thêm email
        });
      }
    } else {
      // Handle error
      throw Exception('Failed to load user data');
    }
  }

  Future<void> updateUsername(String newUsername) async {
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      print('No access token found');
      return;
    }

    // Gọi API để cập nhật username
    final response = await http.put(
      Uri.parse('${dotenv.env['USER_SERVICE_API']}/user/update/username'),
      headers: {
        'access_token': accessToken ?? '',
        'Content-Type': 'application/json',
      },
      body: json.encode({'username': newUsername}),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        setState(() {
          username = newUsername;
        });
      }
    } else {
      // Handle error
      throw Exception('Failed to update username');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Personal Data',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      body: CustomScrollView(
        // Sử dụng CustomScrollView thay vì Column
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage('https://i.ibb.co/ZmwX7K6/1.jpg'),
                      ),
                      SizedBox(height: 20),
                      StyledTextField(
                        labelText: 'First Name',
                        maxLines: 1,
                        hintText: 'Enter your first name',
                        controller: TextEditingController(text: firstname),
                      ),
                      SizedBox(height: 10),
                      StyledTextField(
                        labelText: 'Last Name',
                        maxLines: 1,
                        hintText: 'Enter your last name',
                        controller: TextEditingController(text: lastname),
                      ),
                      SizedBox(height: 10),
                      StyledTextField(
                        labelText: 'Bio',
                        maxLines: 3,
                        hintText: 'Tell us about yourself',
                        controller: TextEditingController(text: bio),
                      ),
                      SizedBox(height: 10),
                      StyledTextField(
                        labelText: 'Country',
                        maxLines: 1,
                        hintText: 'Enter your country',
                        controller: TextEditingController(text: country),
                      ),
                      SizedBox(height: 10),
                      StyledTextField(
                        labelText: 'Age',
                        maxLines: 1,
                        hintText: 'Enter your age',
                        controller:
                            TextEditingController(text: age?.toString() ?? ''),
                      ),
                      SizedBox(height: 10),
                      StyledTextField(
                        labelText: 'Username', // Thêm trường Username
                        maxLines: 1,
                        hintText: 'Enter your username',
                        controller: TextEditingController(text: username),
                      ),
                      SizedBox(height: 10),
                      StyledTextField(
                        labelText: 'Email', // Thêm trường Email
                        maxLines: 1,
                        hintText: 'Enter your email',
                        controller: TextEditingController(text: email),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Gender:'),
                          Radio(
                              value: 'Male',
                              groupValue: 'gender',
                              onChanged: (value) {}),
                          Text('Male'),
                          Radio(
                              value: 'Female',
                              groupValue: 'gender',
                              onChanged: (value) {}),
                          Text('Female'),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          updateUsername(username);
                        },
                        child: Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StyledTextField extends StatelessWidget {
  final String labelText;
  final String hintText; // Added hintText parameter
  final int maxLines;
  final TextEditingController controller; // Added controller parameter

  const StyledTextField({
    Key? key,
    required this.labelText,
    this.hintText = '', // Default value for hintText
    this.maxLines = 1,
    required this.controller, // Required controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[40],
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: TextField(
        controller: controller, // Use the controller
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText, // Use hintText in the decoration
          border: UnderlineInputBorder(),
          contentPadding:
              EdgeInsets.all(8), // Increased padding for better touch targets
        ),
        maxLines: maxLines,
      ),
    );
  }
}
