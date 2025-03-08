import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class TutorialListScreen extends StatefulWidget {
  @override
  _TutorialListScreenState createState() => _TutorialListScreenState();
}

class _TutorialListScreenState extends State<TutorialListScreen> {
  List<dynamic> _tutorials = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    fetchTutorials();
  }

  Future<void> fetchTutorials() async {
    try {
      final response = await http.get(Uri.parse('https://www.sakshamdigitaltechnology.com/api/tutorials'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey('tutorials')) {
          setState(() {
            _tutorials = data['tutorials'];
            _isLoading = false;
            _hasError = false;
          });
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception('Failed to load tutorials');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      padding: EdgeInsets.all(12),
      child: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : _hasError
          ? Center(
          child: Text("Error loading tutorials",
              style: TextStyle(color: Colors.red, fontSize: 16)))
          : _tutorials.isEmpty
          ? Center(
          child: Text("No tutorials available",
              style: TextStyle(fontSize: 16, color: Colors.black54)))
          : SizedBox(
        height: 200,
        child: ListView.builder(
          itemCount: _tutorials.length,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final tutorial = _tutorials[index];
            return TutorialCard(tutorial);
          },
        ),
      ),
    );
  }
}

class TutorialCard extends StatelessWidget {
  final dynamic tutorial;

  TutorialCard(this.tutorial);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.redAccent.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 2)
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Tutorial Image with CachedNetworkImage
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: "https://www.sakshamdigitaltechnology.com/uploads/${tutorial['image']}",
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(height: 100, color: Colors.white),
                ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
              ),
            ),
        
            // ✅ Content Section
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Tutorial Title
                  Text(
                    tutorial['title'] ?? "No Title",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
        
                  // ✅ Course Name (from course_menu)
                  Text(
                    "Course: ${tutorial['course_menu'] != null
                        ? tutorial['course_menu']['course_name'] ?? 'N/A' : 'N/A'}",

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 6),
        
                  // ✅ Status & Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: tutorial['status'] == 'active'
                              ? Colors.greenAccent
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tutorial['status'] ?? "Unknown",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
        
                      // Rating Section
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.pinkAccent, size: 18),
                          SizedBox(width: 4),
                          Text(
                            "${tutorial['rating_star'] ?? '0'}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
        
                  // ✅ Educator Name
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.redAccent, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Educator: ${tutorial['educator_name'] ?? 'Unknown'}",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.pinkAccent),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
        
                  // ✅ Total Rating Count
                  Row(
                    children: [
                      Icon(Icons.people, color: Colors.blue, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Ratings: ${tutorial['rating_count'] ?? '0'}",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
