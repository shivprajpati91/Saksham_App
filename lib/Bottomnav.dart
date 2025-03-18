import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:sakshamapi/ProfileScreen.dart';

import 'Course.dart';
import 'StudentTest.dart';
import 'mcq.dart';
import 'HomeScreen.dart';
import 'CourseDetailScreen.dart';
import 'InternshipForm.dart';
import 'TutorialScreen.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;
  BottomNavBar({this.initialIndex = 0});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade200,
        elevation: 5,
        title: Text(
          'SAKSHAM',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.help_outline, color: Colors.white))],
      ),
      drawer: Drawer(
        child: ListView(children: [
          Container(
            height: 200,
            color: Colors.red.shade200,
            width: 100,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavBar(initialIndex: 1)));
                  }, child: Text("InternshipForm",style: TextStyle(fontWeight:
                  FontWeight.w500,fontSize: 18,color: Colors.black),)),
                ),
                Divider(),
                Container(
                  child: TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavBar(initialIndex: 3)));
                  }, child: Text("MCQ",style: TextStyle(fontWeight:
                  FontWeight.w500,fontSize: 18,color: Colors.black),)),
                ),
                Divider(),
              ],
            ),
          )
        ],),
      ),
      body: FloatingNavBar(
        resizeToAvoidBottomInset: false,
        color: Colors.pinkAccent.shade200,
        initialIndex: _currentIndex,
        items: [
          FloatingNavBarItem(
            iconData: Icons.home,
            title: 'Home',
            page: HomeScreen(),
          ),
          FloatingNavBarItem(
            iconData: Icons.file_open,
            title: 'Form',
            page: InternshipFormScreen(),
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
            iconData: Icons.person,
            title: 'Person',
            page: ProfileScreen(),
          ),
        ],
        selectedIconColor: Colors.white,
        hapticFeedback: true,
        horizontalPadding: 40,
      ),
    );
  }
}