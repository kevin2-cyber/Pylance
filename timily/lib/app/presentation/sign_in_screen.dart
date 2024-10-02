import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:timily/app/presentation/register_screen.dart';

import '../../../core/constants.dart';
import '../provider/auth_provider.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool obscureText = false;

  bool validate() {
    if(_key.currentState!.validate()) {
      _key.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> loginWithEmail() async {
    try {
      if(validate()) {
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .emailSignIn(_emailController.text, _passwordController.text);
        if(mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString()))
      );
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      await Provider.of<AuthenticationProvider>(context, listen: false)
          .loginWithGoogle();
      if(mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const HomeScreen()
            )
        );
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString()))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                    text: 'Sign In\n',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w800
                    ),
                    children: [
                      TextSpan(
                        text: 'or',
                        style: Theme.of(context).textTheme.bodyLarge
                      ),
                      TextSpan(
                        text: ' Join Timiely',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Constants.kPrimaryColor,
                            fontWeight: FontWeight.w800
                        ),
                        recognizer: TapGestureRecognizer()..onTap =() =>
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()))
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) =>
                        value!.isEmpty ? "Email cannot be empty" : null,
                        decoration: const InputDecoration(
                          labelText: 'Enter Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: obscureText,
                        validator: (value) =>
                        value!.isEmpty ? "Password cannot be empty" : null,
                        decoration: InputDecoration(
                          labelText: 'Enter Password',
                          suffixIcon: obscureText ? const Icon(Icons.remove_red_eye_rounded) : Text(
                            'Hide',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Constants.kPrimaryColor
                            ),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      Text(
                          'Forgot Password?',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Constants.kPrimaryColor
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: loginWithEmail,
                        color: Constants.kPrimaryColor,
                        height: MediaQuery.sizeOf(context).height * 0.05,
                        minWidth: MediaQuery.sizeOf(context).width,
                        shape: const StadiumBorder(),
                        child: Text(
                            'Sign In',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
              const SizedBox(
                height: 20,
              ),
             Row(
                  children: <Widget>[
                    const Expanded(
                        child: Divider(
                          thickness: 3,
                          color: Colors.black87,
                        )
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        "or",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Expanded(
                        child: Divider(
                          thickness: 3,
                          color: Colors.black87,
                        )
                    ),
                  ]
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()
                        )
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Constants.kGoogle),
                      const SizedBox(width: 10,),
                      Text(
                          'Sign in with Google',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
