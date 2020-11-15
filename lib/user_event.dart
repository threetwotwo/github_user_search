abstract class UserEvent {
  const UserEvent();
}

class UserFetchEvent extends UserEvent {
  final String query;

  UserFetchEvent(this.query);
}

class UserFetchMoreEvent extends UserEvent {
  const UserFetchMoreEvent();
}
