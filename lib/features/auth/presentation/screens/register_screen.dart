import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../service_locator.dart';
import '../controllers/auth_notifier.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  final AuthNotifier _authNotifier = sl<AuthNotifier>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await _authNotifier.signUp(name, email, password);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully!', style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFF0C6B37),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      Navigator.pop(context); // Back to login
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authNotifier.errorMessage ?? 'Registration Failed', style: GoogleFonts.outfit()),
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0C6B37);

    return Scaffold(
      backgroundColor: const Color(0xFFEBF6F0), // Soft grayish green background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: _authNotifier,
        builder: (context, _) {
          return Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 850) {
                      return _buildDesktopLayout(context, primaryGreen);
                    } else {
                      return _buildMobileLayout(context, primaryGreen);
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

  // --- Desktop Split Layout ---
  Widget _buildDesktopLayout(BuildContext context, Color primaryGreen) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 950, minHeight: 560),
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
              height: 560,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryGreen, const Color(0xFF1B8E4B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
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
                    'Join Us Today! 🚀',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'To keep track of your notes\nplease create an account with us',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to login screen
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'SIGN IN',
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
  Widget _buildMobileLayout(BuildContext context, Color primaryGreen) {
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
          // Top green header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryGreen, const Color(0xFF1B8E4B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
            child: Column(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_fire_department_rounded,
                    color: primaryGreen,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'My Note',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Create Account',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          
          // Form content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 25.0),
            child: _buildFormContent(context, primaryGreen, false),
          ),
        ],
      ),
    );
  }

  // --- Reusable Form Fields ---
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
            'Create your account to continue',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.grey[500],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 25),

          // Name Field
          TextFormField(
            controller: _nameController,
            style: GoogleFonts.outfit(color: primaryGreen, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Name........',
              hintStyle: GoogleFonts.outfit(color: primaryGreen.withValues(alpha: 0.4)),
              prefixIcon: Icon(Icons.person_outline_rounded, color: primaryGreen),
              filled: true,
              fillColor: const Color(0xFFD8EFE4),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.outfit(color: primaryGreen, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Email........',
              hintStyle: GoogleFonts.outfit(color: primaryGreen.withValues(alpha: 0.4)),
              prefixIcon: Icon(Icons.email_outlined, color: primaryGreen),
              filled: true,
              fillColor: const Color(0xFFD8EFE4),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Password Field
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
              fillColor: const Color(0xFFD8EFE4),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a password';
              }
              if (value.trim().length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            style: GoogleFonts.outfit(color: primaryGreen, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Confirm Password........',
              hintStyle: GoogleFonts.outfit(color: primaryGreen.withValues(alpha: 0.4)),
              prefixIcon: Icon(Icons.lock_clock_outlined, color: primaryGreen),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: primaryGreen,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              filled: true,
              fillColor: const Color(0xFFD8EFE4),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value.trim() != _passwordController.text.trim()) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 25),

          // Sign Up Button
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
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'SIGN UP',
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

          // Bottom Toggle Redirect Text
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 13),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'sign in',
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
