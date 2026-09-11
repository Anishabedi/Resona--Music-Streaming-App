import 'dart:io';
import 'dart:ui';
import 'package:fpdart/fpdart.dart';
import 'package:resona/core/providers/current_user_notifier.dart';
import 'package:resona/core/utils.dart';
import 'package:resona/features/home/models/fav_song_model.dart';
import 'package:resona/features/home/repositories/home_local_repository.dart';
import 'package:resona/features/home/repositories/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/song_model.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(
    token: token,
  );

  return switch(res){
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavSongs(GetFavSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(homeRepositoryProvider).getFavSongs(
    token: token,
  );

  return switch(res){
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> searchSongs(SearchSongsRef ref, String query) async {
  if (query.trim().isEmpty) {
    return [];
  }
  final token = ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(homeRepositoryProvider).searchSongs(
    token: token,
    query: query,
  );

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel{
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;
  @override
  AsyncValue? build() {
    _homeRepository =ref.watch(homeRepositoryProvider);
    _homeLocalRepository=ref.watch(homeLocalRepositoryProvider);
    return null;
  }
  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
        selectedAudio: selectedAudio,
        selectedThumbnail: selectedThumbnail,
        songName: songName,
        artist: artist,
        hexCode: rgbToHex(selectedColor),
        token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch(res){
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  List<SongModel> getRecentlyPlayerSongs(){
    return _homeLocalRepository.loadSongs();
  }

  Future<void> favSong({
    required String songId
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.favSong(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch(res){
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r,songId),
    };
    print(val);
  }

  AsyncValue _favSongSuccess(bool isFavourited, String songId){
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if(isFavourited){
      userNotifier.addUser(
          ref.read(currentUserNotifierProvider)!.copyWith(
            favourites: [
              ...ref.read(currentUserNotifierProvider)!.favourites,
              FavSongModel(id: '', song_id: songId, user_id: ''),
            ],
          ),
      );
    } else {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
          favourites: ref
              .read(currentUserNotifierProvider)!
              .favourites
              .where(
                (fav) => fav.song_id != songId,
              )
              .toList(),
        ),
      );
    }
    ref.invalidate(getFavSongsProvider);
    return state = AsyncValue.data(isFavourited);
  }
}

