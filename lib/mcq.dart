import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class McqPackagesScreen extends StatefulWidget {
  @override
  _McqPackagesScreenState createState() => _McqPackagesScreenState();
}

class _McqPackagesScreenState extends State<McqPackagesScreen> {
  List<dynamic> packages = [];
  List<dynamic> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    try {
      final response = await http.get(Uri.parse('https://sakshamdigitaltechnology.com/api/mcq-packages'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            packages = data['mcq_packages'] ?? [];
            courses = data['course_menu'] ?? [];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load packages');
      }
    } catch (e) {
      print('Error fetching packages: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MCQ Packages'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📦 MCQ Packages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: packages.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(packages[index]['package_name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Course ID: ${packages[index]['course_id']}'),
                        Text('Rating: ${packages[index]['rating_count']}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PackageDetailsScreen(package: packages[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Divider(),
            Text('📚 Available Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(courses[index]['course_name']),
                  subtitle: Text('Page Name: ${courses[index]['page_name']}'),
                );},
            ),],
        ),),
    );}
}
class PackageDetailsScreen extends StatelessWidget {
  final dynamic package;

  const PackageDetailsScreen({Key? key, required this.package}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(package['package_name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course ID: ${package['course_id']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Description: ${package['description']}', style: TextStyle(fontSize: 16)),
          ],
        ),),
    );}
}

