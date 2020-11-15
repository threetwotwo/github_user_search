import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_user_search/bloc/user_event.dart';
import 'package:github_user_search/services/repo.dart';
import 'package:github_user_search/models/user.dart';
import 'package:github_user_search/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Repo repo;

  UserBloc({@required this.repo}) : super(UserInitialState());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserFetchEvent) {
      final query = event.query;
      print('UserBloc.mapEventToState fetch $query');
      try {
        yield UserLoadingState();
        final users = await _fetchPosts(query, 1);
        yield UserSuccessState(users: users, query: query, page: 1);
        return;
      } catch (e) {
        yield UserErrorState(e.toString(),
            onRetry: () => this.add(UserFetchEvent(query)));
      }
    }
    if (event is UserFetchMoreEvent && state is UserSuccessState) {
      final currentState = (state as UserSuccessState);
      try {
        yield UserFetchMoreState();

        final page = currentState.page + 1;
        print('UserBloc.mapEventToState fetch more page $page');

        final users = await repo.getUsers(currentState.query, page);
        yield currentState.copyWith(
            users: currentState.users + users, page: page);
        return;
      } catch (e) {
        yield UserErrorState(e.toString(), onRetry: () {
          this.add(UserFetchMoreEvent());
        });
        //go back to previous success state
        await Future.delayed(Duration(milliseconds: 3000));
        yield currentState;
      }
    }
  }

  Future<List<User>> _fetchPosts(String query, int page) {
    return repo.getUsers(query, page).catchError((e) => throw (e.toString()));
  }
}
