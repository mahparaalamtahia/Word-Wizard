class AppRoutes {
  AppRoutes._();

    // ── Onboarding ──
    static const String splash = '/';
    static const String onboarding = '/onboarding';
    static const String login = '/login';
    static const String register = '/register';
    static const String verifyEmail = '/verify-email';

    // ── User (Seeker) Shell ── IndexedStack: Home/Bookings/Alerts/Profile
    static const String shell = '/shell';

    // Backwards-compatible aliases
    static const String home = shell;

    // ── Worker (Provider) Shell ── Split sidebar dashboard
    static const String workerShell = '/worker-shell';

    // Backwards-compatible alias
    static const String dashboard = workerShell;

    // ── Admin Shell ── Full admin panel
    static const String adminShell = '/admin-shell';

    // Backwards-compatible alias
    static const String admin = adminShell;

    // ── Shared screens (pushed on top of any shell) ──
    static const String workers = '/workers';
    static const String workerProfile = '/worker-profile';
    static const String booking = '/booking';
    static const String bookingDetail = '/booking-detail';
    static const String bookingConfirm = '/booking-confirmation';
    static const String bookings = '/bookings';
    static const String reviews = '/reviews';
    static const String notifications = '/notifications';
    static const String profile = '/profile';
    static const String editProfile = '/edit-profile';
    static const String chat = '/chat';
    static const String rating = '/rating';
    static const String favorites = '/favorites';
    static const String myJobs = '/my-jobs';
  }
