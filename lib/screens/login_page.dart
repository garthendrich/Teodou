import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/providers/auth_provider.dart";
import "package:shared_todo_app/screens/sign_up_page.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(32),
          children: [
            const Text(
              "Log In",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            _buildEmailField(),
            _buildPasswordField(),
            _buildSignInButton(),
            _buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Password",
      ),
    );
  }

  Widget _buildSignInButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: ElevatedButton(
        onPressed: () {
          context
              .read<AuthProvider>()
              .signIn(emailController.text, passwordController.text);
        },
        child: const Text("Sign In"),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SignUpPage()),
          );
        },
        child: const Text("Create an account"),
      ),
    );
  }
}
