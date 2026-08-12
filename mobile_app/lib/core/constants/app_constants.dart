class AppConstants {
  // Shared Preferences Keys
  static const String authTokenKey = 'auth_token';
  static const String userEmailKey = 'user_email';
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String setupWizardCompleteKey = 'setup_wizard_complete';

  // Supabase configuration
  // Replace with your project values or inject via flutter_dotenv.
  static const String supabaseUrl = 'https://ftfiqabnvlztnoaiogms.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0ZmlxYWJudmx6dG5vYWlvZ21zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY1MzQxMDAsImV4cCI6MjEwMjExMDEwMH0.MhbYSe81cgcMPko_PZMsnt5SHcFGmWn7870w2bAnlzg';

  // App Settings
  static const String appName = 'CentralHealth';
  static const String appVersion = '1.0.0';
  
  // Timeout durations
  static const int apiTimeoutSeconds = 30;
  static const int chatTimeoutSeconds = 60;
  
  // Default values
  static const String defaultUserEmail = 'patient@example.com';
  static const String defaultUserPassword = 'Password123!';
}
