class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'Ndangira';
  static const String appTagline = 'Your local market, digitized.';

  // Auth
  static const String phoneNumber = 'Phone Number';
  static const String phoneHint = '+250 7XX XXX XXX';
  static const String sendOtp = 'Send OTP';
  static const String enterOtp = 'Enter OTP';
  static const String otpSentTo = 'We sent a code to';
  static const String verifyOtp = 'Verify Code';
  static const String resendCode = 'Resend Code';
  static const String resendIn = 'Resend in';
  static const String invalidPhone = 'Please enter a valid Rwandan phone number.';
  static const String invalidOtp = 'Invalid code. Please try again.';

  // Role Selection
  static const String iAmA = 'I am a...';
  static const String client = 'Client';
  static const String vendor = 'Vendor';
  static const String clientDescription = 'Browse markets and shop from local vendors';
  static const String vendorDescription = 'Sell your products to nearby customers';

  // Vendor Onboarding
  static const String vendorType = 'Vendor Type';
  static const String marketVendor = 'Market Vendor';
  static const String individualVendor = 'Individual Vendor';
  static const String marketVendorDescription =
      'I sell from a stall inside a specific market (e.g., Kimironko, Nyabugogo)';
  static const String individualVendorDescription =
      'I sell from home or a neighborhood location';
  static const String vendorProfile = 'Vendor Profile';
  static const String businessName = 'Business / Stall Name';
  static const String selectMarket = 'Select Market';
  static const String stallCode = 'Stall Code';
  static const String stallCodeHint = 'e.g., NYA-A2-04';
  static const String stallCodeHelper =
      'Format: [MarketPrefix]-[Aisle]-[Stall#]';
  static const String neighborhood = 'Neighborhood / Location';
  static const String neighborhoodHint = 'e.g., Gisozi, Remera';
  static const String productCategory = 'Main Product Category';
  static const String completeSetup = 'Complete Setup';
  static const String next = 'Next';
  static const String back = 'Back';

  // Markets
  static const String kigali = 'Kigali';
  static const String northern = 'Northern Province';

  // Validation
  static const String fieldRequired = 'This field is required.';
  static const String invalidStallCode =
      'Stall code must follow the format: NYA-A2-04';

  // General
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String somethingWentWrong = 'Something went wrong. Please try again.';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String rwf = 'RWF';
}
