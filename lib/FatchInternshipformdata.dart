import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InternshipFormListScreen extends StatefulWidget {
  @override
  _InternshipFormListScreenState createState() => _InternshipFormListScreenState();
}

class _InternshipFormListScreenState extends State<InternshipFormListScreen> {
  List<dynamic> internshipForms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInternshipForms();
  }

  Future<void> fetchInternshipForms() async {
    String url = "https://www.sakshamdigitaltechnology.com/api/internship-forms";

    try {
      var response = await http.get(Uri.parse(url));

      print("🔹 Response Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);

        if (decodedData is List) {
          // If API returns a List
          setState(() {
            internshipForms = decodedData;
            isLoading = false;
          });
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          // If API returns an object with "data" key
          setState(() {
            internshipForms = decodedData['data'];
            isLoading = false;
          });
        } else {
          throw Exception("Unexpected API response format");
        }
      } else {
        throw Exception("Failed to fetch data! Status Code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🚨 Error: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Internship Forms")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : internshipForms.isEmpty
          ? Center(child: Text("No internship forms found!"))
          : ListView.builder(
        itemCount: internshipForms.length,
        itemBuilder: (context, index) {
          var form = internshipForms[index];

          print("🔹 Form Data: $form");  // Debugging

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(form["full_name"] ?? "No Name"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email: ${form["email"] ?? "N/A"}"),
                  Text("Phone: ${form["contact_number"] ?? "N/A"}"),
                  Text("Qualification: ${form["educational_qualification"] ?? "N/A"}"),
                  Text("Field of Interest: ${form["field_of_interest"] ?? "N/A"}"),
                  Text("Introduction: ${form["brief_introduction"] ?? "N/A"}"),
                ],
              ),
            ),
          );
        },
      )

    );
  }
}
