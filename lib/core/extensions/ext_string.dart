extension ExtString on String {
  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  String trunctPostBody(int maxLength) =>
      length > maxLength ? '${substring(0, 100)}...' : this;
}
