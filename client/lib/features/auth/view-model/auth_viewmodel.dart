import 'package:fpdart/fpdart.dart';
import 'package:resona/core/failure/failure.dart';
import 'package:resona/core/providers/current_user_notifier.dart';
import 'package:resona/core/models/user_model.dart';
import 'package:resona/features/auth/repositories/auth_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_remote_repositories.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel{
  late AuthRemoteRepositories _authRemoteRepositories;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;
  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepositories = ref.watch(authRemoteRepositoriesProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepositories.signup(
        name: name,
        email: email,
        password: password,
    );
    final val = switch(res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepositories.login(
      email: email,
      password: password,
    );
    final val = switch(res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => _loginSuccess(r),
    };
    print(val);
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user){
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    print('Token: $token');
    if (token != null) {
      final res = await _authRemoteRepositories.getCurrentUserData(token);
      print('Res: $res');
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
        Right(value: final r) =>  _getDataSuccess(r),

      };
      return val.value;
    }
    return null;
  }

    AsyncValue<UserModel> _getDataSuccess(UserModel user) {
      _currentUserNotifier.addUser(user);
      return state = AsyncValue.data(user);
    }
}



// state notifier and notifier