import 'package:flutter/material.dart';
import '../styles/apptext_styles.dart';
import '../widgets/app_widgets.dart';
import '../services/auth_server.dart';
import '../utils/validators.dart';
// import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  //const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  // Controller for email & password
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _loginError;

  @override
  //this allocates memory fo keep of the text in the Textfield.
  //dispost() cleanup method for widgets before they are destroyed
  void dispose() {
    _emailController.dispose();
    _passwordController
        .dispose(); // release memory used by the text controllers
    super.dispose(); // run flutter's internal cleanup.
  }

  Future<void> _login() async {
    //setState() local state, widget-only
    setState(() => _loginError = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await AuthService.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);
    if (!success) {
      setState(() => _loginError = 'Invalid Email or Password');
    } else {
      // if success redirecte to dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login Screen",
          style: AppTextStyles.logintitle,
        ), // login title style from app text style
        backgroundColor: const Color.fromARGB(255, 109, 199, 241),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 50),
                    Text('Welcome Back!', style: AppTextStyles.loginheader),
                    const SizedBox(height: 50),
                    buildAppTextField(
                      controller: _emailController,
                      label: "Enter Email",
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

                    if (_loginError != null)
                      Text(
                        _loginError!,
                        style: AppTextStyles
                            .loginerror, // make sure this is a TextStyle
                      ),

                    const SizedBox(height: 10),
                    buildPrimaryButton(
                      text: "Login",
                      isLoading: _isLoading,
                      onPressed: _login,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
