import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resona/core/utils.dart';
import 'package:resona/core/widgets/loader.dart';

import '../../../../core/providers/current_song_notifier.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../viewmodel/home_viewmodel.dart';

class SongPage extends ConsumerWidget{
  const SongPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSong = ref.watch(homeViewmodelProvider.notifier).getRecentlyPlayerSongs();
    final currentSong = ref.watch(currentSongNotifierProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,                 // Status bar ko transparent karo
        statusBarIconBrightness: Brightness.light,           // Icons (time, battery) white rakho
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: currentSong == null ? null : BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                hexToColor(currentSong!.hex_code),
                Pallete.transparentColor,
              ],
              stops: const [0.0,0.3],
            ),
          ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:16.0,right: 16,bottom: 10),
                child: SizedBox(
                  height: 280,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: recentlyPlayedSong.length,
                    itemBuilder: (context,index){
                      final song = recentlyPlayedSong[index];
                      return GestureDetector(
                        onTap: (){
                          ref.read(currentSongNotifierProvider.notifier).updateSong(song);
                        },
                        child: Container(
                          decoration:BoxDecoration(
                            color: Pallete.borderColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.only(right:20),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        song.thumbnail_url,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomLeft: Radius.circular(4),
                                    )
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  song.song_name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  'Latest Today',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              ref.watch(getAllSongsProvider).when(
                  data: (songs) {
                    return SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: songs.length > 10 ? 10 : songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return GestureDetector(
                              onTap: (){
                                ref
                                    .read(currentSongNotifierProvider.notifier)
                                    .updateSong(song);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left:16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 180,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                                song.thumbnail_url),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                    ),
                                    const SizedBox(height:5),
                                    SizedBox(
                                      width: 180,
                                        child: Text(
                                          song.song_name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        ),
                                    ),

                                    SizedBox(
                                      width: 180,
                                      child: Text(
                                        song.artist,
                                        style: const TextStyle(
                                          color: Pallete.subtitleText,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                      ),
                    );
                  } ,
                  error: (error,st) {
                    return Center(
                      child: Text(error.toString()),
                      );
                  },
                  loading:() => const Loader(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}


// function esa bnao ki song jo hai latest mei limited dikhe