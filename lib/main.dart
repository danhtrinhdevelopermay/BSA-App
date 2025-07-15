import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/app_provider.dart';
import 'providers/study_provider.dart';
import 'services/localization_service.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize localization service
  await LocalizationService.init();
  
  runApp(const BSAApp());
}

class BSAApp extends StatelessWidget {
  const BSAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudyProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'BSA - Bright Starts Academy',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: appProvider.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: appProvider.supportedLocales,
            home: const AppWrapper(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/main': (context) => const MainScreen(),
            },
          );
        },
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final appProvider = context.read<AppProvider>();
    final authProvider = context.read<AuthProvider>();
    
    // Initialize app settings
    await appProvider.init();
    
    // Initialize auth state
    await authProvider.init();
    
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SplashScreen();
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const SplashScreen();
        }
        
        if (authProvider.isAuthenticated) {
          return const MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}