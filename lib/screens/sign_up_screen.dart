import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/date_select.dart";
import "package:shared_todo_app/providers/auth_provider.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime _birthDate = DateTime.now();

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
            const SizedBox(height: 16),
            _buildFullNameFields(),
            _buildUserNameField(),
            _buildEmailField(),
            _buildPasswordField(),
            _buildBirthDateFields(),
            _buildLocationField(),
            _buildSignUpButton(),
            _buildBackButton()
          ],
        ),
      ),
    );
  }

  Widget _buildFullNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: "First name"),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: "Last name"),
          ),
        ),
      ],
    );
  }

  Widget _buildUserNameField() {
    return TextField(
      controller: _userNameController,
      decoration: const InputDecoration(
        labelText: "Username",
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: "Email",
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Password",
      ),
    );
  }

  Widget _buildBirthDateFields() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Birthdate"),
          DateSelect(
            onChanged: (birthDate) {
              setState(() => _birthDate = birthDate);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return TextField(
      controller: _locationController,
      decoration: const InputDecoration(
        labelText: "Location",
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: ElevatedButton(
        onPressed: () {
          _signUp().then((_) {
            if (context.read<AuthProvider>().isAuthenticated) {
              Navigator.pop(context);
            }
          });
        },
        child: const Text("Create account"),
      ),
    );
  }

  _signUp() async {
    await context.read<AuthProvider>().signUp(
          _firstNameController.text,
          _lastNameController.text,
          _userNameController.text,
          _emailController.text,
          _passwordController.text,
          _birthDate,
          _locationController.text,
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
