import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/components/date_select.dart";
import "package:shared_todo_app/components/error_message.dart";
import "package:shared_todo_app/providers/auth_provider.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _signUpFormKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime _birthDate = DateTime.now();

  String? _submitErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _signUpFormKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(32),
            children: [
              const Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              _buildFullNameFields(),
              _buildUserNameField(),
              _buildEmailField(),
              _buildPasswordField(),
              _buildLocationField(),
              _buildBirthDateFields(),
              if (_submitErrorMessage != null)
                ErrorMessage(message: _submitErrorMessage!),
              _buildActionButtons()
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

  Widget _buildFullNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            validator: (firstName) {
              if (firstName == null || firstName.isEmpty) {
                return "This field is required";
              }

              return null;
            },
            decoration: const InputDecoration(labelText: "First name"),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            validator: (lastName) {
              if (lastName == null || lastName.isEmpty) {
                return "This field is required";
              }

              return null;
            },
            decoration: const InputDecoration(labelText: "Last name"),
          ),
        ),
      ],
    );
  }

  Widget _buildUserNameField() {
    return TextFormField(
      controller: _userNameController,
      validator: (userName) {
        if (userName == null || userName.isEmpty) {
          return "This field is required";
        }

        return null;
      },
      decoration: const InputDecoration(labelText: "Username"),
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
      decoration: const InputDecoration(labelText: "Email"),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      validator: (password) {
        if (password == null || password.isEmpty) {
          return "This field is required";
        }

        if (password.length < 8) {
          return "Password must be at least 8 characters long";
        }

        if (!_isValidPassword(password)) {
          return "Password must contain at least one lowercase, uppercase, numeric, and special character";
        }

        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(labelText: "Password"),
    );
  }

  _isValidPassword(String password) {
    final hasLowerCaseCharacter = password.toUpperCase() != password;
    final hasUpperCaseCharacter = password.toLowerCase() != password;
    final hasNumericCharacter = RegExp(r"\d").hasMatch(password);
    final hasSpecialCharacter =
        RegExp(r"""[~`!@#%&_=:;'",<>/\$\^\*\(\)\-\+\[\]\{\}\|\\\.\?]""")
            .hasMatch(password);

    return hasLowerCaseCharacter &&
        hasUpperCaseCharacter &&
        hasNumericCharacter &&
        hasSpecialCharacter;
  }

  Widget _buildBirthDateFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Birthdate", style: TextStyle(color: Colors.grey[600])),
        DateSelect(
          onChanged: (birthDate) => setState(() => _birthDate = birthDate),
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      decoration: const InputDecoration(labelText: "Location"),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_buildSignUpButton(), _buildBackButton()],
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() => _submitErrorMessage = null);

        if (_signUpFormKey.currentState!.validate()) {
          _signUp().then((_) {
            if (context.read<AuthProvider>().isAuthenticated) {
              Navigator.pop(context);
            }
          });
        }
      },
      child: const Text("Create account"),
    );
  }

  _signUp() async {
    final submitErrorMessage = await context.read<AuthProvider>().signUp(
          _firstNameController.text,
          _lastNameController.text,
          _userNameController.text,
          _emailController.text,
          _passwordController.text,
          _birthDate,
          _locationController.text,
        );

    setState(() => _submitErrorMessage = submitErrorMessage);
  }

  Widget _buildBackButton() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text("Already have an account"),
    );
  }
}
