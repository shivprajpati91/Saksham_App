import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class InternshipFormScreen extends StatefulWidget {
  @override
  _InternshipFormScreenState createState() => _InternshipFormScreenState();
}

class _InternshipFormScreenState extends State<InternshipFormScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController educationalQualificationController = TextEditingController();
  TextEditingController fieldOfInterestController = TextEditingController();
  TextEditingController briefIntroductionController = TextEditingController();

  File? resumeFile;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  // 🔹 Pick Resume File
  Future<void> pickResumeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        resumeFile = File(result.files.single.path!);
      });
    }
  }

  // 🔹 Submit Form
  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate() || resumeFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🚨 Please fill all fields & upload a resume.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String url = "https://www.sakshamdigitaltechnology.com/api/internship-form";

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['full_name'] = fullNameController.text
      ..fields['email'] = emailController.text
      ..fields['contact_number'] = contactNumberController.text
      ..fields['educational_qualification'] = educationalQualificationController.text
      ..fields['field_of_interest'] = fieldOfInterestController.text
      ..fields['brief_introduction'] = briefIntroductionController.text
      ..files.add(await http.MultipartFile.fromPath('resume', resumeFile!.path));

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var responseData = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ ${responseData['message']}")),
        );
        _formKey.currentState!.reset();
        setState(() {
          resumeFile = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Validation Failed: ${responseData['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🚨 Error: $e")),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50, // Soft pink background
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.white, // Clean white card
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(fullNameController, "Full Name", Icons.person, TextInputType.text),
                      buildTextField(emailController, "Email", Icons.email, TextInputType.emailAddress, validator: (value) {
                        return value!.contains("@") ? null : "Enter a valid email";
                      }),
                      buildTextField(contactNumberController, "Contact Number", Icons.phone, TextInputType.phone, validator: (value) {
                        return value!.length == 10 ? null : "Enter a valid 10-digit number";
                      }),
                      buildTextField(educationalQualificationController, "Educational Qualification", Icons.school, TextInputType.text),
                      buildTextField(fieldOfInterestController, "Field of Interest", Icons.work, TextInputType.text),
                      buildTextField(briefIntroductionController, "Brief Introduction", Icons.info, TextInputType.multiline),

                      SizedBox(height: 15),


                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: pickResumeFile,
                              icon: Icon(Icons.upload_file),
                              label: Text(resumeFile != null ? "Resume Selected" : "Upload Resume"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                textStyle: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      if (resumeFile != null)
                        Text("📄 ${resumeFile!.path.split('/').last}", style: TextStyle(fontSize: 14, color: Colors.pinkAccent)),

                      SizedBox(height: 25),

                      // 🔹 Submit Button
                      isLoading
                          ? CircularProgressIndicator()
                          : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: submitForm,
                          child: Text("Submit Application"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Custom TextField with Icons
  Widget buildTextField(
      TextEditingController controller, String label, IconData icon, TextInputType type,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.pinkAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pinkAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: type,
        validator: validator ?? (value) => value!.isEmpty ? "Enter $label" : null,
      ),
    );
  }
}
