sealed class PostFailure {
  final String message;
  PostFailure(this.message);
}

class PostErrorFailure extends PostFailure {
  PostErrorFailure(super.message);
}
