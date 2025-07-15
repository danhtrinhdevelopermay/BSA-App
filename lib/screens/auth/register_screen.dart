import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final appProvider = context.read<AppProvider>();
    
    final success = await authProvider.register(
      _usernameController.text.trim(),
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
                      const SizedBox(height: 40),
                      
                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Register form
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
                              appProvider.t('register'),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Username field
                            CustomTextField(
                              controller: _usernameController,
                              label: appProvider.t('username'),
                              prefixIcon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appProvider.t('required_field');
                                }
                                if (value.length < 3) {
                                  return appProvider.t('field_too_short');
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
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
                            
                            const SizedBox(height: 16),
                            
                            // Confirm Password field
                            CustomTextField(
                              controller: _confirmPasswordController,
                              label: appProvider.t('confirm_password'),
                              prefixIcon: Icons.lock_outline,
                              obscureText: !_isConfirmPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible 
                                      ? Icons.visibility 
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appProvider.t('required_field');
                                }
                                if (value != _passwordController.text) {
                                  return appProvider.t('passwords_not_match');
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Register button
                            CustomButton(
                              text: appProvider.t('register'),
                              onPressed: _register,
                              isLoading: authProvider.isLoading,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Đã có tài khoản? ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              appProvider.t('login'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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