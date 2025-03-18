import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'CourseDetailScreen.dart';
import 'StudentTest.dart';
import 'TutorialScreen.dart';
import 'data.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;
  List<dynamic> _courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final response = await http.get(Uri.parse('https://www.sakshamdigitaltechnology.com/api/courses'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('courses')) {
        setState(() {
          _courses = data['courses'].take(5).toList(); // Show only the top 5 courses
        });
      } else {
        throw Exception('Invalid API response format');
      }
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.yellow.shade700, size: 20);
        } else if (hasHalfStar && index == fullStars) {
          return Icon(Icons.star_half, color: Colors.yellow.shade700, size: 20);
        } else {
          return Icon(Icons.star_border, color: Colors.yellow.shade700, size: 20);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Power-Packed Learning",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 15),
            _courses.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlutterCarousel(
                  options: CarouselOptions(
                    height: 255,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    showIndicator: false, // Shows dots indicator
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.85,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  items: _courses.map((course) {
                    double rating = double.tryParse(course['rating']?.toString() ?? '0.0') ?? 0.0;

                    // Define imageUrl inside the map function
                    final imageUrl = (course['logo'] != null && course['logo'].isNotEmpty)
                        ? (course['logo'].startsWith('http')
                        ? course['logo']
                        : 'https://www.sakshamdigitaltechnology.com/${course['logo']}')
                        : 'https://via.placeholder.com/200';

                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailScreen(course: course),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.pinkAccent),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    imageUrl,
                                    height: 50,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      print("Image Load Error: $error"); // Debugging
                                      return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course['course_name'] ?? 'No Name',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        _buildRatingStars(rating), // Show stars based on rating
                                        SizedBox(height: 15),
                                        Text(
                                          course['short'] ?? 'No Short Description',
                                          style: TextStyle(fontSize: 16, color: Colors.black54),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),

                    // Centered & Styled Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Menu Courses",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    // Course Menu Container with better styling
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        height: 60, // Slightly increased height
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CourseMenuScreen(),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Tutorial List Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TutorialListScreen(),
                      ),
                    ),
                    Container(
                      height: 170,
                      color: Colors.white,
                      child: TestimonialsScreen(),
                    ),

                    SizedBox(height: 50),
                  ],
                )

              ],
            ),

          ],
        ),
      ),
    );
  }
}
