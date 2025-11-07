// This file just holds the string constants for all routes
class AppRoutes {
  // Core & Auth
  static const String splash = '/';
  static const String home = '/home'; // The new GridView dashboard
  static const String login = '/login';
  static const String register = '/register';
  static const String pendingApproval = '/pending-approval';

  // IBS Platform Features
  static const String calendar = '/calendar';
  static const String japaCounter = '/japa-counter';
  static const String vaishnavPuran = '/vaishnav-puran';
  static const String vaishnavSong = '/vaishnav-song';

  // --- Courses Feature Routes ---

  // Student Dashboard Shell
  static const String subjectsList = '/subjects'; // Main student screen
  static const String subjectPDF = '/subjectPDF';
  static const String testSubject = '/testSubject';
  static const String profile = '/profile';

  // Student Content
  static const String chaptersList = '/chapters';
  // ... all your other course routes

  // Admin
  static const String adminDashboard = '/admin';
// ... all your other admin routes
}