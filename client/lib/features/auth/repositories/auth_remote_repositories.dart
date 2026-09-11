import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:resona/core/constants/server_constant.dart';
import 'package:resona/core/failure/failure.dart';
import 'package:resona/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repositories.g.dart';
@riverpod
AuthRemoteRepositories authRemoteRepositories(AuthRemoteRepositoriesRef ref){
  return AuthRemoteRepositories();
}

class AuthRemoteRepositories {
  Future<Either<AppFailure, UserModel>> signup({                  // yha pr pta nhi tha ki konsa error through hoga isliye hmne fpdart package import kiya or either yha lgaya taki failur or success ka return type likh ske
    required String name,
    required String email,
    required String password,
  }) async {
    try{
      final response = await http.post(
          Uri.parse(
              '${ServerConstant.serverURL}/auth/signup',
          ),
          headers: {
            'Content-Type':'application/json'
          },
          body: jsonEncode(
            {
              'name' : name,
              'email' : email,
              'password' : password,
            },
          )
      );
      final resBodyMap= jsonDecode(response.body) as Map<String,dynamic>;
      if(response.statusCode != 201){
        // handled error
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(UserModel.fromJson(response.body));
    } catch (e){
      return Left(AppFailure(e.toString()) );
    }
  }


  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try{
      final response = await http.post(
          Uri.parse('${ServerConstant.serverURL}/auth/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email' : email,
            'password': password,

          },),
      );
      final resBodyMap= jsonDecode(response.body) as Map<String,dynamic>;
      if(response.statusCode != 200){
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right(UserModel.fromMap(resBodyMap['user']).copyWith(token: resBodyMap['token']));
    } catch (e){
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try{
      final response = await http.get(
        Uri.parse('${ServerConstant.serverURL}/auth/'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      final resBodyMap= jsonDecode(response.body) as Map<String,dynamic>;
      if(response.statusCode != 200){
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right(UserModel.fromMap(resBodyMap).copyWith(token: token));
    } catch (e){
      return Left(AppFailure(e.toString()));
    }
  }
}


// darts pattern matching feature