import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Bottomnav.dart';
import 'RegisterScreen.dart';
import 'UserProfile.dart';
class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool hide=true;
  bool loginCheck=false;

  final _formkey = GlobalKey<FormState>();

  void set_data()async{
    final prefs =await SharedPreferences.getInstance();
    prefs.setString("email", email.text);
  }

  Future<void> Login () async {
    if (_formkey.currentState!.validate()) {
      loginCheck = true;
      final pref = await SharedPreferences.getInstance();
      pref.setString("email", email.text);
      pref.setString("password", password.text);
      pref.setBool("isLoggedIn", loginCheck);

      final String url = "https://sakshamdigitaltechnology.com/api/login";

      try {
        final response = await http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": email.text,
              "password": password.text
            })
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          print(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Login Successful")));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) =>BottomNavBar()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Login Failed")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
            "Something went wrong! Check your Internet Connection.")));
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
                Image(image: AssetImage("assets/Log_in.jpeg"),height: 300),
                Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Login",
                              style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Please Sign in to continue",
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300
                              )),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: email,
                          validator: (value){
                            final emailFormat = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if(value==null||value.isEmpty){
                              return "Enter email";
                            }else if(!emailFormat.hasMatch(value)){
                              return "Enter valid email";
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail_outline,size: 22,),
                              labelText: "Enter email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: password,
                          validator: (value){
                            if( value==null||value.isEmpty){
                              return "please enter password";
                            }else if(value.length<8){
                              return "password length should be atleast 8";
                            }
                          },
                          obscureText: hide,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline,size: 22),
                              suffixIcon: InkWell(onTap: (){
                                setState(() {
                                  if(hide==false){
                                    hide=true;
                                  }else{
                                    hide=false;
                                  }
                                });},
                                  child: hide==true? Icon(CupertinoIcons.eye_fill):Icon(CupertinoIcons.eye_slash_fill)
                              ),
                              // suffixIcon: Icon(CupertinoIcons.eye_fill),
                              labelText: "Enter password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                        ),
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfileScreen()));
                        },
                            child: Text("Forgot password?",
                                style: TextStyle(color: Colors.blue))),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffff725e),
                                minimumSize: Size(double.infinity, 40)
                            ),
                            onPressed: Login,
                            child: Text("Login",style: TextStyle(color:Colors.white))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? "),
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Registration()));
                            },
                                child: Text("Register",
                                    style: TextStyle(color: Colors.blue))),
                          ],)
                      ],))
              ],),
          ),
        ),
      ),
    );
  }


}