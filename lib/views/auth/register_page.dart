import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For SnackBar fallback
import 'package:mobiledoc/views/navigation/app_navigation.dart';
import '../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  final AuthService _authService = AuthService();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      try {
        final user = await _authService.registerWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
          _usernameController.text,
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
          SnackBar(content: Text('Registration failed: \${e.toString()}')),
        );
      }

      setState(() => _loading = false);
    }
  }

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
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
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
                        controller: _usernameController,
                        placeholder: "Username",
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Enter username"
                            : null,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      const SizedBox(height: 16),
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
                          ? const Center(child: CupertinoActivityIndicator())
                          : CupertinoButton(
                              color: CupertinoColors.activeBlue,
                              borderRadius: BorderRadius.circular(8),
                              onPressed: _register,
                              child: const Text("Register"),
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
