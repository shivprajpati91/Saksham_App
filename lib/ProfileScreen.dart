import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'RegisterScreen.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load stored data
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "No Name";
      email = prefs.getString('email') ?? "No Email";
      phone = prefs.getString('phone') ?? "No Phone";
    });
  }

  // Logout and clear data
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Registration()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              Text("Name: $name", style: TextStyle(fontSize: 20)),
              Text("Email: $email", style: TextStyle(fontSize: 20)),
              Text("Phone: $phone", style: TextStyle(fontSize: 20)),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Logout", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
