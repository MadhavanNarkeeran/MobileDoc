import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobiledoc/services/auth_service.dart';
import 'package:mobiledoc/views/navigation/app_navigation.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  final AuthService _authService = AuthService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      try {
        final user = await _authService.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;

        if (user != null) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (_) => AppNavigation()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Try Again.')),
        );
      }

      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  static const TextStyle headerStyle = TextStyle(
    color: CupertinoColors.white,
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Semantics(
                excludeSemantics: true,
                child: const Text(
                  'Login',
                  style: headerStyle,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 30),
                      CupertinoTextFormFieldRow(
                        controller: _emailController,
                        placeholder: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Enter email"
                            : null,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      const SizedBox(height: 16),
                      CupertinoTextFormFieldRow(
                        controller: _passwordController,
                        placeholder: "Password",
                        obscureText: true,
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Enter password"
                            : null,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      const SizedBox(height: 24),
                      _loading
                          ? Center(child: CupertinoActivityIndicator())
                          : CupertinoButton(
                              color: CupertinoColors.activeBlue,
                              borderRadius: BorderRadius.circular(8),
                              onPressed: _login,
                              child: Text("Login"),
                            ),
                      const SizedBox(height: 16),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => const RegisterPage()),
                          );
                        },
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text(
                          "Don't have an account? Register here",
                          style: TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.activeBlue,
                          ),
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
    );
  }
}
