import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for user inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker(); // ✅ Use ImagePicker instance


  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("⚠️ Image picker error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to pick image")));
    }
  }

  Future<void> _uploadProfile() async {
    String apiUrl = "https://www.sakshamdigitaltechnology.com/api/user-profile";

    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      request.fields['name'] = _nameController.text;
      request.fields['dob'] = _dobController.text;
      request.fields['address'] = _addressController.text;
      request.fields['city'] = _cityController.text;
      request.fields['state'] = _stateController.text;
      request.fields['pincode'] = _pincodeController.text;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath("image", _imageFile!.path));
      }
      request.headers['Content-Type'] = 'multipart/form-data';


      var response = await http.Response.fromStream(await request.send());


      if (response.statusCode == 200) {
        print("✅ Success: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated Successfully")));
      } else {
        print("❌ Error: ${response.statusCode}");
        print("🔍 Response Body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update profile: ${response.statusCode}")));
      }
    } catch (e) {
      print("⚠️ Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [

                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                ),

                SizedBox(height: 10),
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Full Name"),
                  validator: (value) => value!.isEmpty ? "Enter your name" : null,
                ),

                // DOB Field
                TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(labelText: "Date of Birth (YYYY-MM-DD)"),
                  validator: (value) => value!.isEmpty ? "Enter DOB" : null,
                ),

                // Address Field
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: "Address"),
                  validator: (value) => value!.isEmpty ? "Enter your address" : null,
                ),

                // City Field
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: "City"),
                  validator: (value) => value!.isEmpty ? "Enter city" : null,
                ),

                // State Field
                TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(labelText: "State"),
                  validator: (value) => value!.isEmpty ? "Enter state" : null,
                ),

                // Pincode Field
                TextFormField(
                  controller: _pincodeController,
                  decoration: InputDecoration(labelText: "Pincode"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter pincode" : null,
                ),

                SizedBox(height: 20),

                // Upload Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _uploadProfile();
                    }
                  },
                  child: Text("Upload Profile"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
