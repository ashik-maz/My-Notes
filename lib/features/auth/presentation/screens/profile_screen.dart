import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../../../../service_locator.dart';
import '../controllers/auth_notifier.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0C6B37);
    final authNotifier = sl<AuthNotifier>();
    final user = authNotifier.currentUser;
    final theme = Theme.of(context);

    // Determine authentication provider type
    String providerType = 'Email & Password';
    if (user != null) {
      if (user.email == 'googleuser@gmail.com' || user.uid.contains('google')) {
        providerType = 'Google Account';
      } else if (user.uid == 'mock-anonymous-user' || user.email == 'anonymous@guest.com') {
        providerType = 'Guest Account (Demo)';
      } else if (user.email == null || user.email!.isEmpty) {
        providerType = 'Anonymous Firebase Guest';
      }
    }

    final displayName = user?.displayName ?? 
        (user?.email != null && user!.email!.isNotEmpty ? user.email!.split('@')[0] : 'Guest User');
    
    final emailDisplay = user?.email ?? 'No email associated (Guest)';
    final avatarLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryGreen, Color(0xFF1B8E4B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar & Name Card
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFFD8EFE4),
                            child: Text(
                              avatarLetter,
                              style: GoogleFonts.outfit(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: primaryGreen,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            displayName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8EFE4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              providerType,
                              style: GoogleFonts.outfit(
                                color: primaryGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // User details info list
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          _buildInfoTile(
                            context,
                            Icons.email_outlined,
                            'Email Address',
                            emailDisplay,
                            false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),


                  Center(
                    child: Container(
                      width: 180,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await authNotifier.signOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'LOG OUT',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    bool showCopy,
  ) {
    const primaryGreen = Color(0xFF0C6B37);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFEBF6F0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryGreen, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 12,
          color: Colors.grey[500],
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.outfit(
          fontSize: 15,
          color: Colors.grey[900],
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: showCopy
          ? IconButton(
              icon: const Icon(Icons.copy_rounded, color: Colors.grey, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('UID copied to clipboard!', style: GoogleFonts.outfit()),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            )
          : null,
    );
  }
}
