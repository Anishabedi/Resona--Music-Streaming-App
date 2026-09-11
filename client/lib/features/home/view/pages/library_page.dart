import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resona/core/providers/current_song_notifier.dart';
import 'package:resona/core/widgets/custom_field.dart';
import 'package:resona/features/home/view/pages/upload_song_page.dart';
import 'package:resona/features/home/viewmodel/home_viewmodel.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/widgets/loader.dart';

class LibraryPage extends ConsumerStatefulWidget{
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  Timer? _debounce;
  String searchQuery = '';
  bool isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {     // 👈 NAYA - focus change hone pe listen karo
      setState(() {
        isSearchFocused = searchFocusNode.hasFocus;
      });
    });
  }

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        searchQuery = value.trim();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }
// @override
//   Widget build(BuildContext context) {
//     return ref.watch(getFavSongsProvider).when(
//         data: (data){
//           return ListView.builder(
//             itemCount: data.length +1 ,
//             itemBuilder: (context,index) {
//               if(index == data.length){
//                 return ListTile(
//                   onTap: (){
//                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UploadSongPage(),),);
//                   },
//                   leading: const CircleAvatar(
//                     radius: 35,
//                     backgroundColor: Pallete.backgroundColor,
//                     child: Icon(
//                       CupertinoIcons.plus,
//                     ),
//                   ),
//                   title: const Text(
//                     'Upload New Song',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 );
//               }
//               final song = data[index];
//               return ListTile(
//                 onTap: (){
//                   ref.read(currentSongNotifierProvider.notifier).updateSong(song);
//                 },
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(song.thumbnail_url),
//                   radius: 35,
//                   backgroundColor: Pallete.backgroundColor,
//                 ),
//                 title: Text(
//                   song.song_name,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 subtitle: Text(
//                   song.artist,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//         error: (error,st){
//           return Center(child: Text(error.toString()),);
//         },
//         loading: () => const Loader(),
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isSearchFocused,                          // Agar search focused hai, back button se app exit na ho
      onPopInvokedWithResult: (didPop,result) {
        if (!didPop && isSearchFocused) {
          FocusScope.of(context).unfocus();               // Pehle focus/keyboard hatao
        }
      },
      child: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: CustomField(
                  hintText: "Search songs or artists",
                  controller: searchController,
                  focusNode: searchFocusNode,
                  onChanged: onSearchChanged,
                  prefixIcon: Icons.search,
                ),
              ),
              Expanded(
                // 👇 CHANGE - ab "isSearchFocused" ke basis pe switch hoga, "searchQuery.isEmpty" ke basis pe nahi
                child: isSearchFocused
                    ? _buildSearchResults()
                    : _buildFavouritesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavouritesList() {
    return ref.watch(getFavSongsProvider).when(
      data: (data) {
        return ListView.builder(
          itemCount: data.length + 1,
          itemBuilder: (context, index) {
            if (index == data.length) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const UploadSongPage()),
                  );
                },
                leading: const CircleAvatar(
                  radius: 35,
                  backgroundColor: Pallete.backgroundColor,
                  child: Icon(CupertinoIcons.plus),
                ),
                title: const Text(
                  'Upload New Song',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              );
            }
            final song = data[index];
            return ListTile(
              onTap: () {
                ref.read(currentSongNotifierProvider.notifier).updateSong(song);
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(song.thumbnail_url),
                radius: 35,
                backgroundColor: Pallete.backgroundColor,
              ),
              title: Text(
                song.song_name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                song.artist,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            );
          },
        );
      },
      error: (error, st) => Center(child: Text(error.toString())),
      loading: () => const Loader(),
    );
  }

  Widget _buildSearchResults() {
    // 👇 Agar kuch type nahi kiya, sirf tap kiya hai, to khaali state dikhao
    if (searchQuery.isEmpty) {
      return const Center(
        child: Text(
          'Type to search songs or artists',
          style: TextStyle(color: Pallete.subtitleText),
        ),
      );
    }

    return ref.watch(searchSongsProvider(searchQuery)).when(
      data: (songs) {
        if (songs.isEmpty) {
          return const Center(
            child: Text('No songs found', style: TextStyle(color: Pallete.subtitleText)),
          );
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(       // 👈 "Dropdown jaisa" look dene ke liye
            color: Pallete.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                onTap: () {
                  ref.read(currentSongNotifierProvider.notifier).updateSong(song);
                  FocusScope.of(context).unfocus();   // Song select karne pe keyboard/focus hatao
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(song.thumbnail_url),
                  radius: 25,
                  backgroundColor: Pallete.backgroundColor,
                ),
                title: Text(
                  song.song_name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  song.artist,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        );
      },
      error: (error, st) => Center(child: Text(error.toString())),
      loading: () => const Loader(),
    );
  }

}