import 'package:dio/dio.dart';
import 'package:github_user_search/user.dart';

abstract class UserState {
  const UserState();
}

class UserInitialState extends UserState {
  const UserInitialState();
}

class UserLoadingState extends UserState {
  const UserLoadingState();
}

class UserFetchMoreState extends UserState {
  const UserFetchMoreState();
}

class UserErrorState extends UserState {
  final String message;
  final VoidCallback onRetry;
  const UserErrorState(this.message, {this.onRetry});
}

class UserSuccessState extends UserState {
  final List<User> users;
  final String query;
  final int page;

  UserSuccessState({
    this.users,
    this.query,
    this.page,
  });

  UserSuccessState copyWith({List<User> users, String query, int page}) {
    return UserSuccessState(
      users: users ?? this.users,
      query: query ?? this.query,
      page: page ?? this.page,
    );
  }
}
