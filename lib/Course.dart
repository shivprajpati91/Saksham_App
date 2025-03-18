import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart'; // Import HTML parser

class Course extends StatefulWidget {
  final int courseId;

  Course({required this.courseId});

  @override
  _CourseState createState() => _CourseState();
}

class _CourseState extends State<Course> {
  Map<String, dynamic>? _courseDetails;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCourseDetails();
  }

  Future<void> fetchCourseDetails() async {
    final url = Uri.parse('https://www.sakshamdigitaltechnology.com/api/courses/${widget.courseId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("API Response: $data");

        if (data is Map<String, dynamic> && data.containsKey('course')) {
          setState(() {
            _courseDetails = data['course'];
            _isLoading = false;
          });
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception('Failed to load course details');
      }
    } catch (e) {
      print("Error fetching course: $e");
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  /// Function to remove HTML tags from the description
  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    return document.body?.text ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError || _courseDetails == null
          ? Center(child: Text('Error loading course details'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _courseDetails!['course_name'] ?? 'No Name',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Status: ${_courseDetails!['status'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green),
              ),
              SizedBox(height: 10),
              Text(
                _courseDetails!['title']?.toString() ?? 'No Title Found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                parseHtmlString(_courseDetails!['description'] ?? 'No Description'), // Convert HTML to plain text
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
