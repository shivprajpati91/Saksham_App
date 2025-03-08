import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  List courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  fetchCourses() async {
    final response = await http.get(Uri.parse('https://www.sakshamdigitaltechnology.com/api/tutorials'));
    if (response.statusCode == 200) {
      setState(() {
        courses = json.decode(response.body)['tutorials'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Courses')),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(courses[index]['course_name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(
                    courseName: courses[index]['course_name'],
                    courseDescription: courses[index]['description'],
                    courseImage: courses[index]['image_url'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CourseDetailScreen extends StatelessWidget {
  final String courseName;
  final String courseDescription;
  final String courseImage;

  CourseDetailScreen({
    required this.courseName,
    required this.courseDescription,
    required this.courseImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Course Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(courseImage, height: 200, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(
              courseName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              courseDescription,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
