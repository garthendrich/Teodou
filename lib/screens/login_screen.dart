import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:shared_todo_app/components/error_message.dart";

import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/screens/sign_up_screen.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _submitErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _loginFormKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(32),
            children: [
              const Text(
                "Log In",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              _buildEmailField(),
              _buildPasswordField(),
              if (_submitErrorMessage != null)
                ErrorMessage(message: _submitErrorMessage!),
              _buildActionButtons(),
            ].map((child) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: child,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      validator: (email) {
        if (email == null || email.isEmpty) {
          return "This field is required";
        }

        return null;
      },
      decoration: const InputDecoration(
        hintText: "Email",
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      validator: (password) {
        if (password == null || password.isEmpty) {
          return "This field is required";
        }

        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Password",
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_buildSignInButton(), _buildSignUpButton()],
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      key: const Key("login-button"),
      onPressed: () async {
        setState(() => _submitErrorMessage = null);

        if (_loginFormKey.currentState!.validate()) {
          final submitErrorMessage = await context
              .read<AuthProvider>()
              .signIn(_emailController.text, _passwordController.text);

          setState(() => _submitErrorMessage = submitErrorMessage);
        }
      },
      child: const Text("Log In"),
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      },
      child: const Text("Create an account"),
    );
  }
}
