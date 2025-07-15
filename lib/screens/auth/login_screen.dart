import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final appProvider = context.read<AppProvider>();
    
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted && success) {
      Navigator.pushReplacementNamed(context, '/main');
    } else if (mounted && authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Consumer2<AuthProvider, AppProvider>(
        builder: (context, authProvider, appProvider, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor.withOpacity(0.8),
                  AppTheme.secondaryColor.withOpacity(0.6),
                  AppTheme.backgroundColor,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      
                      // Logo
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryColor,
                                      AppTheme.secondaryColor,
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.school,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Welcome text
                      Text(
                        appProvider.t('welcome'),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        appProvider.t('app_full_name'),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Login form
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              appProvider.t('login'),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Email field
                            CustomTextField(
                              controller: _emailController,
                              label: appProvider.t('email'),
                              prefixIcon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appProvider.t('required_field');
                                }
                                if (!value.contains('@')) {
                                  return appProvider.t('invalid_email');
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Password field
                            CustomTextField(
                              controller: _passwordController,
                              label: appProvider.t('password'),
                              prefixIcon: Icons.lock,
                              obscureText: !_isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible 
                                      ? Icons.visibility 
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appProvider.t('required_field');
                                }
                                if (value.length < 6) {
                                  return appProvider.t('password_too_short');
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Login button
                            CustomButton(
                              text: appProvider.t('login'),
                              onPressed: _login,
                              isLoading: authProvider.isLoading,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Forgot password
                            TextButton(
                              onPressed: () {
                                // TODO: Implement forgot password
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(appProvider.t('coming_soon')),
                                  ),
                                );
                              },
                              child: Text(
                                appProvider.t('forgot_password'),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chưa có tài khoản? ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              appProvider.t('register'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Language switcher
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => appProvider.changeLanguage('vi'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: appProvider.currentLanguage == 'vi' 
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Text(
                                  '🇻🇳 Tiếng Việt',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => appProvider.changeLanguage('en'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: appProvider.currentLanguage == 'en' 
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Text(
                                  '🇺🇸 English',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}