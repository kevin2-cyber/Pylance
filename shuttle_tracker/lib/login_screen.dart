import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuttle_tracker/student_home_screen.dart';

import 'auth_provider.dart';
import 'driver_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      // Call the signIn method (even though it returns void)
                      await authProvider.signInWithEmail(
                         _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      // Once signed in, use FirebaseAuth to get the user
                      User? user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        // Fetch the user's role and navigate accordingly
                        await _fetchUserRoleAndNavigate(user);
                      } else {
                        throw Exception('No user found after sign in');
                      }
                    } catch (error) {
                      setState(() {
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login failed: $error')),
                      );
                    }
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchUserRoleAndNavigate(User user) async {
    try {
      // Fetch the user's document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Add a null check for userDoc and data
      if (userDoc.exists && userDoc.data() != null) {
        final userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          final String? role = userData['role'] as String?;

          // Check if role is not null and navigate accordingly
          if (role != null) {
            if (role == 'Driver') {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const DriverHome()),
              );
            } else if (role == 'Student') {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const StudentHome()),
              );
            } else {
              // Handle unknown or missing role
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Unknown role. Please contact support.')),
              );
            }
          } else {
            // Handle case where the role is missing or null
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Role not found. Please contact support.')),
            );
          }
        }
      } else {
        // Handle missing user data
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found. Please contact support.')),
        );
      }
    } catch (error) {
      // Handle Firestore errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user role: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
