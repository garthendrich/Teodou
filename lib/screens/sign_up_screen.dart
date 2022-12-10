import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:shared_todo_app/providers/auth_provider.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final List<String> birthMonths = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  String? selectedBirthMonth;
  int? selectedBirthDay;
  int? selectedBirthYear;

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
            controller: firstNameController,
            decoration: const InputDecoration(labelText: "First name"),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: lastNameController,
            decoration: const InputDecoration(labelText: "Last name"),
          ),
        ),
      ],
    );
  }

  Widget _buildUserNameField() {
    return TextField(
      controller: userNameController,
      decoration: const InputDecoration(
        labelText: "Username",
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(
        labelText: "Email",
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
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
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButton(
                  hint: const Text("Month"),
                  value: selectedBirthMonth,
                  onChanged: (month) {
                    setState(() {
                      selectedBirthMonth = month!;
                    });
                  },
                  items: birthMonths.map((birthMonth) {
                    return DropdownMenuItem(
                      value: birthMonth,
                      child: Text(birthMonth),
                    );
                  }).toList(),
                  isExpanded: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton(
                  hint: const Text("Day"),
                  value: selectedBirthDay,
                  onChanged: (day) {
                    setState(() {
                      selectedBirthDay = day!;
                    });
                  },
                  items: List.generate(31, (number) {
                    return DropdownMenuItem(
                      value: number + 1,
                      child: Text((number + 1).toString()),
                    );
                  }),
                  isExpanded: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton(
                  hint: const Text("Year"),
                  value: selectedBirthYear,
                  onChanged: (year) {
                    setState(() {
                      selectedBirthYear = year!;
                    });
                  },
                  items: List.generate(150, (number) {
                    return DropdownMenuItem(
                      value: DateTime.now().year - number,
                      child: Text((DateTime.now().year - number).toString()),
                    );
                  }),
                  isExpanded: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return TextField(
      controller: locationController,
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
    final birthDate = DateTime.utc(
      selectedBirthYear!,
      birthMonths.indexOf(selectedBirthMonth!) + 1,
      selectedBirthDay!,
    );

    await context.read<AuthProvider>().signUp(
          firstNameController.text,
          lastNameController.text,
          userNameController.text,
          emailController.text,
          passwordController.text,
          birthDate,
          locationController.text,
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
