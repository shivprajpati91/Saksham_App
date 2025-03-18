import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TestimonialsScreen extends StatefulWidget {
  @override
  _TestimonialsScreenState createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen> {
  List testimonials = [];

  @override
  void initState() {
    super.initState();
    fetchTestimonials();
  }

  Future<void> fetchTestimonials() async {
    final response = await http.get(Uri.parse(
        'https://sakshamdigitaltechnology.com/api/student-testimonials'));
    if (response.statusCode == 200) {
      setState(() {
        testimonials = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load testimonials');
    }
  }


    Widget build(BuildContext context) {
      return Container(
        height: 250,
        color: Colors.white,// Enforce a fixed height for the widget
        child: testimonials.isEmpty
            ? Center(child: CircularProgressIndicator())
            : PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: testimonials.length,
          itemBuilder: (context, index) {
            final testimonial = testimonials[index];
            return
               Row(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://sakshamdigitaltechnology.com/uploads/${testimonial['image']}',
                    ),
                    onBackgroundImageError: (_, __) {
                      setState(() {}); // Force a rebuild when an error occurs
                    },
                    child: Icon(Icons.person, size: 30, color: Colors.white), // Placeholder icon
                  ),

                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          testimonial['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          testimonial['designation'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          testimonial['feedback'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  )] );


          },
        ),
      );
    }

  }
