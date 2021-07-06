import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_vp/utils/textstyles.dart';
import 'package:the_vp/utils/tools.dart';
import 'package:the_vp/views/addMedicine.dart';
import 'package:the_vp/views/infoApp.dart';
import 'package:the_vp/views/profile.dart';
import 'package:the_vp/views/search.dart';

import 'home.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  FirebaseFirestore database = FirebaseFirestore.instance;
  int _pageIndex = 0;
  GlobalKey _menuKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    List<Widget> tabes = [HomePage(), SearchPage(), Profile(), InfoApp()];

    return Scaffold(
        bottomNavigationBar: Directionality(
          textDirection: TextDirection.rtl,
          child: BottomNavyBar(
            backgroundColor: Tools.greenColor1,
            selectedIndex: _pageIndex,
            showElevation: true, // use this to remove appBar's elevation
            onItemSelected: (index) => setState(() {
              _pageIndex = index;
            }),
            items: [
              BottomNavyBarItem(
                icon: Icon(
                  Icons.home,
                  color: Tools.whiteColor,
                ),
                title: Text(
                  'الرئيسية',
                  style: twoTS,
                ),
                activeColor: Tools.whiteColor,
              ),
              BottomNavyBarItem(
                icon: Icon(
                  Icons.search,
                  color: Tools.whiteColor,
                ),
                title: Text(
                  'بحث',
                  style: twoTS,
                ),
                activeColor: Tools.whiteColor,
              ),
              BottomNavyBarItem(
                icon: Icon(
                  Icons.person,
                  color: Tools.whiteColor,
                ),
                title: Text(
                  'حسابي',
                  style: twoTS,
                ),
                activeColor: Tools.whiteColor,
              ),
              BottomNavyBarItem(
                icon: Icon(
                  Icons.info,
                  color: Tools.whiteColor,
                ),
                title: Text(
                  'التطبيق',
                  style: twoTS,
                ),
                activeColor: Tools.whiteColor,
              ),
            ],
          ),
        ),
        body: tabes[_pageIndex],
        floatingActionButton: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Tools.greenColor1,
            ),
            width: 125,
            child: FlatButton.icon(
              icon: Icon(
                Icons.add,
                color: Tools.whiteColor,
              ),
              label: Text(
                "إضافة دواء",
                style: twoTS,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMedicine(),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
