import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_user_search/search_screen.dart';
import 'package:github_user_search/services/repo.dart';
import 'package:github_user_search/user_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(backgroundColor: Colors.white),
      title: 'Flutter Demo',
      home: BlocProvider(
        create: (context) => UserBloc(repo: Repo()),
        child: SearchScreen(),
      ),
    );
  }
}
