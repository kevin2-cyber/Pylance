import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timily/app/presentation/register_screen.dart';
import 'package:timily/core/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset(Constants.kTimiely),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
                Constants.kLoginImage,
              height: MediaQuery.sizeOf(context).height * 0.4,
              width: MediaQuery.sizeOf(context).width,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
                'Success guaranteed',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const RegisterScreen()));
                },
              color: Constants.kPrimaryColor,
              height: MediaQuery.sizeOf(context).height * 0.05,
              minWidth: MediaQuery.sizeOf(context).width,
              shape: const StadiumBorder(),
              child: Text(
                  'Agree & Join',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
                onPressed: () {},
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
    );
  }
}
