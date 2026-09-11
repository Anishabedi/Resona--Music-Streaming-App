// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllSongsHash() => r'a06f06bef1b9213d7a6fb1458e5a4d32f0c45f7e';

/// See also [getAllSongs].
@ProviderFor(getAllSongs)
final getAllSongsProvider = AutoDisposeFutureProvider<List<SongModel>>.internal(
  getAllSongs,
  name: r'getAllSongsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllSongsRef = AutoDisposeFutureProviderRef<List<SongModel>>;
String _$getFavSongsHash() => r'a87018e84ac4917a7a2b793d0931a0667503c6bb';

/// See also [getFavSongs].
@ProviderFor(getFavSongs)
final getFavSongsProvider = AutoDisposeFutureProvider<List<SongModel>>.internal(
  getFavSongs,
  name: r'getFavSongsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getFavSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetFavSongsRef = AutoDisposeFutureProviderRef<List<SongModel>>;
String _$searchSongsHash() => r'872daf0ff92c16d173b3af799e81219b95f4bee3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [searchSongs].
@ProviderFor(searchSongs)
const searchSongsProvider = SearchSongsFamily();

/// See also [searchSongs].
class SearchSongsFamily extends Family<AsyncValue<List<SongModel>>> {
  /// See also [searchSongs].
  const SearchSongsFamily();

  /// See also [searchSongs].
  SearchSongsProvider call(
    String query,
  ) {
    return SearchSongsProvider(
      query,
    );
  }

  @override
  SearchSongsProvider getProviderOverride(
    covariant SearchSongsProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchSongsProvider';
}

/// See also [searchSongs].
class SearchSongsProvider extends AutoDisposeFutureProvider<List<SongModel>> {
  /// See also [searchSongs].
  SearchSongsProvider(
    String query,
  ) : this._internal(
          (ref) => searchSongs(
            ref as SearchSongsRef,
            query,
          ),
          from: searchSongsProvider,
          name: r'searchSongsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchSongsHash,
          dependencies: SearchSongsFamily._dependencies,
          allTransitiveDependencies:
              SearchSongsFamily._allTransitiveDependencies,
          query: query,
        );

  SearchSongsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<SongModel>> Function(SearchSongsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchSongsProvider._internal(
        (ref) => create(ref as SearchSongsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SongModel>> createElement() {
    return _SearchSongsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchSongsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchSongsRef on AutoDisposeFutureProviderRef<List<SongModel>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchSongsProviderElement
    extends AutoDisposeFutureProviderElement<List<SongModel>>
    with SearchSongsRef {
  _SearchSongsProviderElement(super.provider);

  @override
  String get query => (origin as SearchSongsProvider).query;
}

String _$homeViewmodelHash() => r'ce28bc79655b6e42d719f0f0f682357952695742';

/// See also [HomeViewmodel].
@ProviderFor(HomeViewmodel)
final homeViewmodelProvider =
    AutoDisposeNotifierProvider<HomeViewmodel, AsyncValue?>.internal(
  HomeViewmodel.new,
  name: r'homeViewmodelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewmodelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewmodel = AutoDisposeNotifier<AsyncValue?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
