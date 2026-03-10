/// Set to [true] before releasing to production.
/// When [false], US numbers (+1) are also accepted for testing.
const bool kProductionMode = false;

/// Set to [true] to run the app with mock data — no Firebase required.
/// Change [kMockStartRoute] to jump directly to any screen.
/// Set both to [false] / restore before connecting real Firebase.
const bool kUseMocks = true;

/// The route the app starts on when [kUseMocks] is true.
/// Options (copy from AppRoutes):
///   '/phone-auth'        — phone login screen
///   '/role-selection'    — client vs vendor picker
///   '/vendor-type'       — market vs individual vendor
///   '/vendor-onboarding' — vendor profile form
///   '/vendor-dashboard'  — vendor home (uses mock vendor data)
///   '/client-home'       — client home (uses mock markets data)
const String kMockStartRoute = '/client-home';
