import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_user_search/user_event.dart';
import 'package:github_user_search/user.dart';
import 'package:github_user_search/user_bloc.dart';
import 'package:github_user_search/user_state.dart';
import 'package:github_user_search/widgets/search_bar.dart';
import 'package:github_user_search/widgets/user_list_item.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  UserBloc _bloc;
  //Delay search
  Timer _debouncer;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  List<User> _users = [];

  @override
  void dispose() {
    _scrollController.dispose();
    _debouncer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = BlocProvider.of<UserBloc>(context);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          controller: _searchController,
          onTextChange: (val) {
            if (_debouncer?.isActive ?? false) _debouncer.cancel();
            _debouncer = Timer(const Duration(milliseconds: 500), () {
              if (val.isNotEmpty) {
                _bloc.add(UserFetchEvent(val));
                _users.clear();
              }
            });
          },
          onCancel: () => _searchController.clear(),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child:
            BlocConsumer<UserBloc, UserState>(listener: (context, userState) {
          if (userState is UserErrorState) {
            _removeCurrentSnackbar(context);
            Scaffold.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 60),
              content: Text(
                userState.message,
                style: TextStyle(color: Colors.redAccent),
              ),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: userState.onRetry,
              ),
            ));
          }
          if (userState is UserFetchMoreState) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Loading...'),
            ));
          }
        }, builder: (context, userState) {
          if (userState is UserInitialState)
            return Center(
              child: Text('Search Users'),
            );
          if (userState is UserLoadingState && _users.isEmpty)
            return Center(child: CircularProgressIndicator());

          if (userState is UserSuccessState) {
            _removeCurrentSnackbar(context);
            final users = userState.users ?? [];
            _users = users;
          }

          return _users.isEmpty
              ? Center(child: Text('No user found'))
              : ListView.separated(
                  controller: _scrollController,
                  itemCount: _users.length,
                  itemBuilder: (context, i) => UserListItem(
                    user: _users[i],
                  ),
//For debugging
                  separatorBuilder: (_, i) => Text(i.toString()),
//            separatorBuilder: (_, __) => Divider(),
                );
        }),
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= 200 &&
        !(_bloc.state is UserFetchMoreState || _bloc.state is UserErrorState))
      _bloc.add(UserFetchMoreEvent());
  }

  void _removeCurrentSnackbar(BuildContext context) {
    if (mounted) Scaffold.of(context).hideCurrentSnackBar();
  }
}
