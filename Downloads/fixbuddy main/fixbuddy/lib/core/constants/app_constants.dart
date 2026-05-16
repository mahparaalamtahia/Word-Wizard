/// Application-wide constants
class AppConstants {
  // Supabase credentials are loaded from environment (.env) at runtime.

  // Database tables
  static const String profilesTable = 'profiles';
  static const String usersTable = profilesTable;
  static const String workersTable = 'workers';
  static const String bookingsTable = 'bookings';
  static const String chatsTable = 'chats';
  static const String ratingsTable = 'ratings';

  // User roles
  static const String roleUser = 'user';
  static const String roleWorker = 'worker';
  static const String roleAdmin = 'admin';

  // Validation
  static const int minPasswordLength = 6;
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // Error messages
  static const String invalidEmail = 'Please enter a valid email address';
  static const String passwordTooShort =
      'Password must be at least $minPasswordLength characters';
  static const String passwordMismatch = 'Passwords do not match';
  static const String emailAlreadyExists = 'Email is already registered';
  static const String invalidCredentials = 'Invalid email or password';
  static const String networkError = 'Network error. Please try again.';
  static const String unknownError = 'An unknown error occurred';
  static const String sessionExpired = 'Session expired. Please login again.';
}
