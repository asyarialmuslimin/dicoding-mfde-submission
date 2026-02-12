import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tvseries_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeDitontonPage extends StatefulWidget {
  const HomeDitontonPage({Key? key}) : super(key: key);

  @override
  State<HomeDitontonPage> createState() => _HomeDitontonPageState();
}

class _HomeDitontonPageState extends State<HomeDitontonPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeMoviePage(),
    HomeTVSeriesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/ic_movie.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0 ? Colors.white : Colors.grey[600]!,
                BlendMode.srcIn,
              ),
            ),
            label: 'Movie',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/ic_tv.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1 ? Colors.white : Colors.grey[600]!,
                BlendMode.srcIn,
              ),
            ),
            label: 'TV Series',
          ),
        ],
      ),
    );
  }
}
