import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;

  // Mock credentials for testing
  final String _mockEmail = "doctor@healthcamp.com";
  final String _mockPassword = "health123";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    if (_emailController.text.trim() == _mockEmail &&
        _passwordController.text == _mockPassword) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/home-screen');
    } else {
      // Show error message
      _showErrorSnackBar('Invalid email or password. Please try again.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Forgot Password',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Password recovery feature will be available soon. Please contact support for assistance.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    _showErrorSnackBar('$provider login will be available soon');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 4.h),

                // App Logo and Header
                _buildHeader(),

                SizedBox(height: 6.h),

                // Login Form
                _buildLoginForm(),

                SizedBox(height: 4.h),

                // Social Login Options
                _buildSocialLogin(),

                SizedBox(height: 4.h),

                // Sign Up Link
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App Logo
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: CustomIconWidget(
            iconName: 'local_hospital',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 10.w,
          ),
        ),

        SizedBox(height: 3.h),

        // Welcome Message
        Text(
          'Welcome Back',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 1.h),

        Text(
          'Sign in to continue to HealthCamp Finder',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email Field
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: _validateEmail,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your email',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Password Field
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.done,
          validator: _validatePassword,
          onFieldSubmitted: (_) => _handleLogin(),
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: CustomIconWidget(
                iconName: _isPasswordVisible ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Remember Me and Forgot Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                Text(
                  'Remember me',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ],
            ),
            TextButton(
              onPressed: _handleForgotPassword,
              child: Text(
                'Forgot Password?',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Sign In Button
        SizedBox(
          height: 6.h,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            child: _isLoading
                ? SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    'Sign In',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        // Divider with "OR"
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1.0,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Social Login Buttons
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                'Google',
                'g_translate',
                () => _handleSocialLogin('Google'),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildSocialButton(
                'Apple',
                'apple',
                () => _handleSocialLogin('Apple'),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Privacy Message
        Text(
          'Your health data is protected with medical-grade security',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      String label, String iconName, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        side: BorderSide(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 5.w,
          ),
          SizedBox(width: 2.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New to HealthCamps? ',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: () {
            _showErrorSnackBar('Sign up feature will be available soon');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign Up',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
