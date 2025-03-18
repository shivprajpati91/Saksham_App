import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sakshamapi/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Bottomnav.dart';
class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirm_pass = TextEditingController();
  bool click1 = true;
  bool click2 = false;
  bool hide_pass=true;
  bool hide_confirm_pass=true;

  final _formkey = GlobalKey<FormState>();



  Future<void> _register() async {
    if (_formkey.currentState!.validate()) {
      final String url = "https://sakshamdigitaltechnology.com/api/register";

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": name.text,
            "email": email.text,
            "phone": phone.text,
            "password": password.text,
            "password_confirmation": confirm_pass.text,
          }),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Save user data in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', name.text);
          await prefs.setString('email', email.text);
          await prefs.setString('phone', phone.text);

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Registration successful")));

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BottomNavBar()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['error'] ?? "Registration Failed")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage("assets/Sign up.png"),height: 300),
                Form(
                    key: _formkey,
                    child: Column(children: [
                      TextFormField(
                        controller:name,
                        validator: (value){
                          if(value==null||value.isEmpty){
                            return "enter name";
                          }
                          else if(value.length<3){
                            return "name length should be greater than 3";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Enter name",
                            suffixIcon: Icon(CupertinoIcons.person),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),SizedBox(height: 10),
                      TextFormField(
                        controller: email,
                        validator: (value){
                          final emailFormat = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if(value==null||value.isEmpty){
                            return "Enter email";
                          }else if(!emailFormat.hasMatch(value)){
                            return "Enter valid email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Enter email",
                            suffixIcon: Icon(Icons.mail),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),SizedBox(height: 10),
                      TextFormField(
                        controller: phone,
                        validator: (value){
                          if(value==null||value.isEmpty){
                            return "enter number";
                          }else if (value.length < 10 || value.length > 10) {
                            return "invalid number";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Phone number",
                            suffixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),SizedBox(height: 10),
                      TextFormField(
                        controller: password,
                        validator: (value){
                          if(value==null||value.isEmpty){
                            return "enter password";
                          }else if(value.length<8){
                            return "password length should be atleast 8";
                          }
                          return null;
                        },
                        obscureText: hide_pass,
                        decoration: InputDecoration(
                          labelText: "Password",
                          suffixIcon: InkWell(
                              onTap: (){
                                setState(() {
                                  if(hide_pass==false){
                                    hide_pass=true;
                                  }else{
                                    hide_pass=false;
                                  }
                                });
                              },
                              child: hide_pass==true?Icon(CupertinoIcons.eye_fill):Icon(CupertinoIcons.eye_slash_fill)
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),SizedBox(height: 10),
                      TextFormField(
                        controller: confirm_pass,
                        validator: (value){
                          if(value==null||value.isEmpty){
                            return "enter password";
                          }else if(value!=password.text){
                            return "password doesn't match";
                          }
                          return null;
                        },
                        obscureText: hide_confirm_pass,
                        decoration: InputDecoration(
                            labelText: "Confirm password",
                            suffixIcon: InkWell(
                                onTap: (){
                                  setState(() {
                                    if(hide_confirm_pass==false){
                                      hide_confirm_pass=true;
                                    }else{
                                      hide_confirm_pass=false;
                                    }
                                  });
                                },
                                child: hide_confirm_pass==true?Icon(CupertinoIcons.eye_fill):Icon(CupertinoIcons.eye_slash_fill)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: click2,
                            onChanged: (value) {
                              setState(() {
                                click2 = value!;
                              });
                            },
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                            shape: RoundedRectangleBorder(),
                          ),
                          Text(
                            "I Agree to the",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     context, MaterialPageRoute(builder: (context) => Termcondition()));
                              },
                              child: Text(
                                " Terms & Conditions",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.blue),
                              )),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 40),
                              backgroundColor: Color(0xffff725e)
                          ),
                          onPressed: _register,
                          child: Text("Register",
                            style: TextStyle(color: Colors.white),))
                    ],))
              ],),
          ),
        ),
      ),
    );
  }
}