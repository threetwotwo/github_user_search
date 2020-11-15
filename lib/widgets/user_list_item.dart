import 'package:flutter/material.dart';
import 'package:github_user_search/models/user.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({Key key, @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: Colors.grey[300],
              child: Image.network(user.avatarUrl ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(user.username ?? 'Username'),
          ),
        ],
      ),
    );
  }
}
