import 'package:dio/dio.dart';
import 'package:github_user_search/user.dart';

class Repo {
  //Singleton
  static final Repo _repo = Repo._();
  Repo._();
  factory Repo() => _repo;

  final dio = Dio();

  Future<List<User>> getUsers(String query, int page) async {
    try {
      final response = await dio
          .get('https://api.github.com/search/users?q=$query&page=$page');

      final data = response.data ?? {};

      final List items = List.from(data['items']);

      return items.map((e) => User.fromJson(e)).toList();
    } on DioError catch (e) {
      print('Repo.getUsers ${e.response}');
      throw (e.response.statusMessage);
    }
  }
}
