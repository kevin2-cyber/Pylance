import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timily/app/presentation/home_screen.dart';
import 'package:timily/app/presentation/sign_in_screen.dart';

import '../../core/constants.dart';
import '../provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController =  TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();

  bool validate() {
    if(_key.currentState!.validate()) {
      _key.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> registerWithEmail() async {
    try {
      if(validate()) {
        await Provider.of<AuthenticationProvider>(context, listen: false).emailRegistration(
            '${_firstNameController.text} ${_lastNameController.text}',
          _emailController.text,
          _passwordController.text
        );
        if(mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()
            ),
          );
        }
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                  Constants.kTimiely,
                fit: BoxFit.contain,
                height: MediaQuery.sizeOf(context).height * 0.3,
                width: MediaQuery.sizeOf(context).width * 0.3,
              ),
              Text.rich(
                TextSpan(
                  text: 'Create Profile\n',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w800
                  ),
                  children: [
                    TextSpan(
                      text: 'or ',
                        style: Theme.of(context).textTheme.bodyLarge
                    ),
                    TextSpan(
                        text: 'Sign in',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w800
                        ),
                        recognizer: TapGestureRecognizer()..onTap =() =>
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()))
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      validator: (value) =>
                      value!.isEmpty ? "First Name cannot be empty" : null,
                      decoration: const InputDecoration(
                        labelText: 'First name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      validator: (value) =>
                      value!.isEmpty ? "Last Name cannot be empty" : null,
                      decoration: const InputDecoration(
                        labelText: 'Last name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) =>
                      value!.isEmpty ? "Email cannot be empty" : null,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) =>
                      value!.isEmpty ? "Password cannot be empty" : null,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) =>
                      value!.isEmpty ? "Password cannot be empty" : null,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: registerWithEmail,
                      color: Constants.kPrimaryColor,
                      height: MediaQuery.sizeOf(context).height * 0.05,
                      minWidth: MediaQuery.sizeOf(context).width,
                      shape: const StadiumBorder(),
                      child: Text(
                          'Create Profile',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
