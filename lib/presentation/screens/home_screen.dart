import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shagf/core/locale_provider.dart';
import 'package:shagf/core/theme_provider.dart';
import 'package:shagf/data/services/auth_service.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _themeProvider.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _themeProvider.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authService = Provider.of<AuthService>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final String displayName = widget.user.displayName ?? l10n.shaghaf;
    final String email = widget.user.email ?? '...';
    final String? photoURL = widget.user.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.signOut,
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
                child: photoURL == null
                    ? Text(
                        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 24),
              Text(
                displayName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Language toggle
              ElevatedButton.icon(
                icon: const Icon(Icons.language),
                label: Text(l10n.toggleLanguage),
                onPressed: () {
                  final currentLocale = localeProvider.locale;
                  if (currentLocale.languageCode == 'en') {
                    localeProvider.setLocale(const Locale('ar'));
                  } else {
                    localeProvider.setLocale(const Locale('en'));
                  }
                },
              ),
              const SizedBox(height: 16),
              // Theme toggle
              ElevatedButton.icon(
                icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                label: Text(themeProvider.themeMode == ThemeMode.dark ? 'Light Mode' : 'Dark Mode'),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
