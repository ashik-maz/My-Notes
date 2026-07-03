import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../service_locator.dart';
import '../controllers/auth_notifier.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final AuthNotifier _authNotifier = sl<AuthNotifier>();
  bool _obscurePassword = true;
  bool _isGoogleLoading = false;
  bool _isAnonymousLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await _authNotifier.signIn(email, password);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in successfully!', style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFF0C6B37),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authNotifier.errorMessage ?? 'Login Failed', style: GoogleFonts.outfit()),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });

    final success = await _authNotifier.signInWithGoogle();
    if (success && mounted) {
      final user = _authNotifier.currentUser;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome, ${user?.displayName ?? "User"}! 👋', style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFF0C6B37),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authNotifier.errorMessage ?? 'Google Sign-In Failed', style: GoogleFonts.outfit()),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  Future<void> _loginAnonymously() async {
    setState(() {
      _isAnonymousLoading = true;
    });

    final success = await _authNotifier.signInAnonymously();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in anonymously as Guest! 🕵️', style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFF0C6B37),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authNotifier.errorMessage ?? 'Anonymous Login Failed', style: GoogleFonts.outfit()),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isAnonymousLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF6F0), // Soft grayish green background
      body: ListenableBuilder(
        listenable: _authNotifier,
        builder: (context, _) {
          return Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive width check
                    if (constraints.maxWidth > 850) {
                      return _buildDesktopLayout(context);
                    } else {
                      return _buildMobileLayout(context);
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    const primaryGreen = Color(0xFF0C6B37);

    return Container(
      constraints: const BoxConstraints(maxWidth: 950, minHeight: 520),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          // Left Column (Green Panel)
          Expanded(
            flex: 11,
            child: Container(
              height: 520,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryGreen, Color(0xFF1B8E4B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Circle
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: primaryGreen,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'My Note',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'To stay connected with us\nplease login with your personal info',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Outlined button to trigger Sign Up page
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'SIGN UP',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Right Column (White Panel Form)
          Expanded(
            flex: 12,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: _buildFormContent(context, primaryGreen, true),
            ),
          ),
        ],
      ),
    );
  }

  // --- Mobile Stacked Layout ---
  Widget _buildMobileLayout(BuildContext context) {
    const primaryGreen = Color(0xFF0C6B37);

    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          // Top curved green header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryGreen, Color(0xFF1B8E4B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              children: [
                // Circular White Logo
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: primaryGreen,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'My Note',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Welcome Back!',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          
          // Form content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            child: _buildFormContent(context, primaryGreen, false),
          ),
        ],
      ),
    );
  }

  // --- Reusable Form Fields & Buttons ---
  Widget _buildFormContent(BuildContext context, Color primaryGreen, bool isDesktop) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'welcome',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: primaryGreen,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Login in to your account to continue',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.grey[500],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 30),

          // Email Field with custom style
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.outfit(color: primaryGreen, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Email........',
              hintStyle: GoogleFonts.outfit(color: primaryGreen.withValues(alpha: 0.4)),
              prefixIcon: Icon(Icons.email_outlined, color: primaryGreen),
              filled: true,
              fillColor: const Color(0xFFD8EFE4), // Mint Green background tint
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: primaryGreen, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),

          // Password Field with custom style
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.outfit(color: primaryGreen, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Password........',
              hintStyle: GoogleFonts.outfit(color: primaryGreen.withValues(alpha: 0.4)),
              prefixIcon: Icon(Icons.lock_outline, color: primaryGreen),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: primaryGreen,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              filled: true,
              fillColor: const Color(0xFFD8EFE4), // Mint Green background tint
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: primaryGreen, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          // Forgot Password Link
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: Text(
                'Forgot your password?',
                style: GoogleFonts.outfit(
                  color: Colors.grey[500],
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Log In Button
          _authNotifier.isLoading
              ? Center(
                  child: SpinKitRing(
                    color: primaryGreen,
                    size: 40.0,
                  ),
                )
              : Center(
                  child: Container(
                    width: 160,
                    height: 46,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: primaryGreen.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'LOG IN',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 20),

          // Google Sign-In Option
          _isGoogleLoading
              ? Center(
                  child: SpinKitThreeBounce(
                    color: primaryGreen,
                    size: 30.0,
                  ),
                )
              : Center(
                  child: OutlinedButton(
                    onPressed: _loginWithGoogle,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/24px-Google_%22G%22_logo.svg.png',
                          height: 18,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.g_mobiledata, color: Colors.blue, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sign in with Google',
                          style: GoogleFonts.outfit(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          const SizedBox(height: 12),

          // Anonymous Sign-In option
          _isAnonymousLoading
              ? Center(
                  child: SpinKitRing(
                    color: primaryGreen,
                    size: 24.0,
                  ),
                )
              : Center(
                  child: TextButton(
                    onPressed: _loginAnonymously,
                    child: Text(
                      'Continue Anonymous',
                      style: GoogleFonts.outfit(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 16),

          // Bottom Toggle Redirect Text
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 13),
              ),
              GestureDetector(
                onTap: () {
                  if (isDesktop) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  }
                },
                child: Text(
                  'sign up',
                  style: GoogleFonts.outfit(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
