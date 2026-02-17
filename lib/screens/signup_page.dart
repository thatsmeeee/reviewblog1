import 'package:flutter/material.dart';
import '../styles/apptext_styles.dart';
import '../widgets/app_widgets.dart';
import '../services/auth_server.dart';
import '../utils/validators.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _signupError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    setState(() => _signupError = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await AuthService.signup(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      username: _usernameController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);
    if (!success) {
      setState(
        () =>
            _signupError = 'Signup failed. Email confirmation may be required.',
      );
    } else {
      // Show success message and navigate to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created! If email confirmation is required, please check your email.',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );
      context.pushReplacement('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account", style: AppTextStyles.logintitle),
        backgroundColor: const Color.fromARGB(255, 109, 199, 241),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Text('Create Account', style: AppTextStyles.loginheader),
                      const SizedBox(height: 50),
                      buildAppTextField(
                        controller: _usernameController,
                        label: "Username",
                        textInputAction: TextInputAction.next,
                        validator: Validators.username,
                      ),
                      const SizedBox(height: 16),
                      buildAppTextField(
                        controller: _emailController,
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 16),
                      buildAppTextField(
                        controller: _passwordController,
                        label: "Password",
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        validator: Validators.password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_signupError != null)
                        Text(_signupError!, style: AppTextStyles.loginerror),

                      const SizedBox(height: 10),
                      buildPrimaryButton(
                        text: "Create Account",
                        isLoading: _isLoading,
                        onPressed: _signup,
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          context.pushReplacement('/');
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Color.fromARGB(255, 109, 199, 241),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
