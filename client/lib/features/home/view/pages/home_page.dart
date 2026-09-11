import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resona/core/theme/app_pallete.dart';
import 'package:resona/features/home/view/pages/library_page.dart';
import 'package:resona/features/home/view/pages/song_page.dart';
import 'package:resona/features/home/view/widgets/music_slab.dart';
import 'package:resona/core/providers/current_user_notifier.dart';

import '../../../../core/utils.dart';
import 'account_page.dart';

class HomePage extends ConsumerStatefulWidget{
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex=0;

  final pages = [
    SongPage(),
    LibraryPage(),
    AccountPage(),
  ];
@override
  Widget build(BuildContext context){
  final currentUser = ref.watch(currentUserNotifierProvider);
  return Scaffold(
      body: Stack(
        children: [
          pages[selectedIndex],
          const Positioned(
            bottom: 0,
            child: MusicSlab(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Pallete.backgroundColor,
        currentIndex: selectedIndex,
          onTap: (value){
            setState(() {
              selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon:Image.asset(
                selectedIndex ==0
                  ? 'assets/images/home_filled.png'
                  : 'assets/images/home_unfilled.png',
              color: selectedIndex ==0
                ? Pallete.whiteColor
                :Pallete.inactiveBottomBarItemColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:Image.asset(
                  'assets/images/library.png',
              color: selectedIndex == 1
                  ? Pallete.whiteColor
                  :Pallete.inactiveBottomBarItemColor,
              ),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: selectedIndex == 2
                      ? Border.all(color: Pallete.whiteColor, width: 1)   // Selected pe white border
                      : null,                                              // Inactive pe koi border nahi
                ),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: getAvatarColor(currentUser?.name ?? '?'),
                  child: Text(
                    currentUser != null && currentUser.name.isNotEmpty
                        ? currentUser.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              label: 'Account',
            ),

          ],
      ),
    );
  }
}