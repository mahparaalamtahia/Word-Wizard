/// String utility extensions
extension StringExtensions on String {
  /// Validates if the string is a valid email
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Validates if the string is a strong password
  bool isStrongPassword() {
    return length >= 6;
  }

  /// Capitalizes the first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Checks if the string is empty or only whitespace
  bool get isEmptyOrNull => trim().isEmpty;
}
