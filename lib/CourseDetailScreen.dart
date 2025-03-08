import 'package:flutter/material.dart';
import 'package:html/parser.dart'; // Import HTML parser

class CourseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> course;

  CourseDetailScreen({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Soft background
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildCourseDetails(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🔹 AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            course['page_name'] ?? 'Page Name',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.pinkAccent.shade400,
      elevation: 5,
    );
  }

  // 🔹 Header Section with Gradient and Image
  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.redAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 20,
          right: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              course['logo'] != null && course['logo'].isNotEmpty
                  ? 'https://www.sakshamdigitaltechnology.com/${course['logo']}'
                  : 'https://via.placeholder.com/300',
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Course Details Section
  Widget _buildCourseDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseTitle(), // Title
              SizedBox(height: 10),
              _buildCourseMetaInfo(), // Type & Status
              SizedBox(height: 15),
              _buildRatingsAndStudents(), // Ratings & Student Count
              SizedBox(height: 15),
              Divider(thickness: 1),
              SizedBox(height: 10),
              _buildCourseShortDescription(), // Short Description
              SizedBox(height: 10),
              _buildCourseDescription(), // Full Description
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Course Title
  // 🔹 Course Title with Page Name
  Widget _buildCourseTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course['course_name'] ?? 'No Course Name',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 4),
        Text(
          course['page_name'] ?? 'No Page Name',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
      ],
    );
  }

  // 🔹 Course Type & Status
  Widget _buildCourseMetaInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoChip(Icons.category, course['course_type'] ?? 'Unknown Type'),
        _infoChip(Icons.verified, course['status'] ?? 'Unknown Status'),
      ],
    );
  }

  // 🔹 Ratings & Student Count
  Widget _buildRatingsAndStudents() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRatingInfo(), // Rating Section
        _buildStudentInfo(), // Student Count Section
      ],
    );
  }

  // 🔹 Short Description
  Widget _buildCourseShortDescription() {
    return Text(
      course['short'] ?? 'No Short Description',
      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
    );
  }

  // 🔹 Full Description
  Widget _buildCourseDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 5),
        Text(
          _sanitizeText(course['description'] ?? 'No Description Available'),
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }


  Widget _infoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.white),
      label: Text(text, style: TextStyle(color: Colors.white, fontSize: 14)),
      backgroundColor: Colors.pinkAccent.shade400,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }

  // 🔹 Rating Info Widget
  Widget _buildRatingInfo() {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 22),
        SizedBox(width: 4),
        Text(
          "${course['rating_star'] ?? '0.0'}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 6),
        Text(
          "(${course['rating_count'] ?? '0'} Reviews)",
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
      ],
    );
  }

  // 🔹 Enrolled Students Info Widget
  Widget _buildStudentInfo() {
    return Row(
      children: [
        Icon(Icons.people, color: Colors.blueAccent, size: 22),
        SizedBox(width: 4),
        Text(
          "${course['student_count'] ?? '0'} Enrolled",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // 🔹 Sanitize HTML Content
  String _sanitizeText(String htmlString) {
    final document = parse(htmlString);
    return document.body?.text.trim() ?? '';
  }
}
