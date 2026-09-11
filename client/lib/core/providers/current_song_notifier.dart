import 'dart:math';

import 'package:just_audio_background/just_audio_background.dart';
import 'package:resona/features/home/models/song_model.dart';
import 'package:resona/features/home/repositories/home_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';
@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier{

  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  bool isShuffling = false;

  Duration? currentDuration;
  @override
  SongModel? build(){
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song) async{
    await audioPlayer?.stop();
    audioPlayer = AudioPlayer();
    // await audioPlayer!.setUrl(song.song_url);
    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
      tag:MediaItem(
        id: song.id,
        title: song.song_name,
        artist: song.artist,
        artUri: Uri.parse(song.thumbnail_url),
      ),
    );
    await audioPlayer!.setAudioSource(audioSource);
    currentDuration = await audioPlayer!.durationStream.firstWhere((d) => d != null);
    audioPlayer!.playerStateStream.listen((state) {
      if(state.processingState == ProcessingState.completed){
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;

        this.state = this.state?.copyWith(hex_code: this.state?.hex_code);
      }
    });
    _homeLocalRepository.uploadLocalSong(song);
    audioPlayer!.play();
    isPlaying = true;
    state = song;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    }else{
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seek(double val){
    audioPlayer!.seek(Duration(milliseconds: (val*audioPlayer!.duration!.inMilliseconds).toInt()));
  }

  void playPrevious(List<SongModel> songs) async {
    if(state == null) return;

    final currentIndex = songs.indexWhere((song) => song.id == state!.id);

    if( currentIndex == -1) return; // pehla song hai toh kuch mat karo

    int previousIndex;
    if(isShuffling) {
      previousIndex = Random().nextInt(songs.length); // ✅ Random song
    } else {
      previousIndex = currentIndex == 0 ? songs.length - 1 : currentIndex - 1;
    }

    updateSong(songs[previousIndex]);
  }

  void playNext(List<SongModel> songs) async {
    if (state == null) return;

    final currentIndex = songs.indexWhere((song) => song.id == state!.id);

    if(currentIndex == -1) return;

    int nextIndex;
    if(isShuffling) {
      nextIndex = Random().nextInt(songs.length);
    } else {
      nextIndex = currentIndex == songs.length - 1 ? 0 : currentIndex + 1;
    }

    updateSong(songs[nextIndex]);
  }

  void toggleShuffle() {
    isShuffling = !isShuffling;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

}