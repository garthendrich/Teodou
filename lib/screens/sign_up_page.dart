import "package:flutter/material.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
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
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            _buildFirstNameField(),
            _buildLastNameField(),
            _buildEmailField(),
            _buildPasswordField(),
            _buildSignUpButton(),
            _buildBackButton()
          ],
        ),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return TextField(
      controller: firstNameController,
      decoration: const InputDecoration(
        hintText: "First name",
      ),
    );
  }

  Widget _buildLastNameField() {
    return TextField(
      controller: lastNameController,
      decoration: const InputDecoration(
        hintText: "Last name",
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

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: ElevatedButton(
        onPressed: () {},
        child: const Text("Create account"),
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Already have an account"),
      ),
    );
  }
}
