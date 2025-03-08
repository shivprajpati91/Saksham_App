import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';

import 'Course.dart';
import 'StudentTest.dart';
import 'mcq.dart';
import 'HomeScreen.dart';
import 'CourseDetailScreen.dart';
import 'InternshipForm.dart';
import 'TutorialScreen.dart';

class bottomnavbar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FloatingNavBar(
        resizeToAvoidBottomInset: false,
        color: Colors.pinkAccent.shade200,
        items: [
          FloatingNavBarItem(
            iconData: Icons.home,
            title: 'Home',
            page: HomeScreen(),
          ),
          FloatingNavBarItem(
            iconData: Icons.file_open,
            title: 'Form',
            page:InternshipFormScreen(),
          ),
          FloatingNavBarItem(
            iconData: Icons.file_copy,
            title: 'CourseID',
            page: Course(courseId: 1,),
          ),
          FloatingNavBarItem(
            iconData: Icons.bookmark_remove_outlined,
            title: 'Package',
            page: McqPackagesScreen(),
          ),
          FloatingNavBarItem(
            iconData: Icons.transfer_within_a_station,
            title: 'Test',
            page:TestimonialsScreen(),
          ),
        ],
        selectedIconColor: Colors.white,
        hapticFeedback: true,
        horizontalPadding: 40,
      ),
    );
  }
}


