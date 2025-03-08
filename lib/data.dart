import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseMenuScreen extends StatefulWidget {
  @override
  _CourseMenuScreenState createState() => _CourseMenuScreenState();
}

class _CourseMenuScreenState extends State<CourseMenuScreen> {
  List<String> _courseNames = [];
  bool _isLoading = true;
  bool _hasError = false;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchCourseMenu();
    startAutoScroll();
  }

  Future<void> fetchCourseMenu() async {
    try {
      final response = await http.get(Uri.parse('https://www.sakshamdigitaltechnology.com/api/tutorials'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("API Response: $data"); // Debugging - check response

        if (data is Map && data.containsKey('tutorials')) {
          final List<dynamic> tutorials = data['tutorials'];

          setState(() {
            _courseNames = tutorials
                .map<String>((course) => course['title'] ?? 'No Name')
                .toList();
            _isLoading = false;
            _hasError = false;
          });
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception('Failed to load course menu');
      }
    } catch (error) {
      print("Error fetching courses: $error");
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void startAutoScroll() {
    Future.delayed(Duration(seconds: 2), () {
      if (_courseNames.isNotEmpty) {
        _pageController.animateToPage(
          _currentPage + 1,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ).then((_) {
          setState(() {
            _currentPage = (_currentPage + 1) % _courseNames.length;
          });
          startAutoScroll();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: [Colors.pinkAccent, Colors.redAccent]),
      ),
      child: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white)) // Show loading indicator
          : _hasError
          ? Center(child: Text("Error loading courses", style: TextStyle(color: Colors.white)))
          : _courseNames.isEmpty
          ? Center(child: Text("No courses available", style: TextStyle(color: Colors.white)))
          : PageView.builder(
        controller: _pageController,
        itemCount: _courseNames.length,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              _courseNames[index],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
