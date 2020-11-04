import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:kilo_analiz_uygulamasi/screens/anasayfa/page_five.dart';
import 'package:kilo_analiz_uygulamasi/screens/anasayfa/page_four.dart';
import 'package:kilo_analiz_uygulamasi/screens/anasayfa/page_one.dart';
import 'package:kilo_analiz_uygulamasi/screens/anasayfa/page_three.dart';
import 'package:kilo_analiz_uygulamasi/screens/anasayfa/page_two.dart';

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  PageController _pageController;
  int _aktifSayfaNo = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: new Container(
        height: 70.0,
        color: Colors.white,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: _aktifSayfaNo,
          unselectedIconTheme: IconThemeData(size: 24),
          onTap: (value) {
            setState(() {
              _aktifSayfaNo = value;
              // _pageController.jumpToPage(value);
              _pageController.animateToPage(value,
                  curve: Curves.easeOutExpo, duration: Duration(seconds: 1));
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.search),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark_border,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity),
              label: 'Home',
            ),
          ],
        ),
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _aktifSayfaNo = value;
          });
        },
        children: [
          PageFive(),
          PageTwo(),
          PageThree(),
          PageFour(),
          PageFive(),
        ],
      ),
    );
  }
}
