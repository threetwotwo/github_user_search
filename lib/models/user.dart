class User {
  final int id;
  final String username;
  final String avatarUrl;

  User({
    this.id,
    this.username,
    this.avatarUrl,
  });

  factory User.fromJson(Map json) {
    return User(
      id: json['id'],
      username: json['login'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
    );
  }
}
