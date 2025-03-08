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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Testimonials')),
      body: testimonials.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: testimonials.length,
        itemBuilder: (context, index) {
          final testimonial = testimonials[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://sakshamdigitaltechnology.com/uploads/${testimonial['image']}'),
              ),
              title: Text(testimonial['name'],
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(testimonial['designation']),
                  SizedBox(height: 5),
                  Text(testimonial['feedback']),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
