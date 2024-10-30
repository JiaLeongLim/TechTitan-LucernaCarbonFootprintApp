import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testfirebase/dashboard.dart';
import 'dart:ui_web' as ui;
import 'dart:html';
import 'package:testfirebase/main.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage; // Variable to store error message

  Future<void> _login() async {
    setState(() {
      _errorMessage = null; // Reset error message on each login attempt
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to dashboard on successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => dashboard()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = "Wrong Email or Password"; // Set error message from Firebase exception
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Wrong Email or Password"; // Set general error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(80, 80, 80, 50),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _3d_model(),
                            SizedBox(height: 30),
                            Text(
                              'Lucerna',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Eco-Friendly Living Starts Here.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                            ),
                            const SizedBox(height: 50),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildTextField(_emailController, 'Email'),
                                  const SizedBox(height: 20),
                                  _buildTextField(
                                      _passwordController, 'Password',
                                      hide: true),
                                  const SizedBox(height: 20),
                                  if (_errorMessage != null)
                                    Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  const SizedBox(height: 20),
                                  _buildButtonRow(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _3d_model() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        'hello-world-html',
        (int viewId) => IFrameElement()
          ..width = '100%'
          ..height = '100%'
          ..src =
              'https://my.spline.design/cabinwoodscopy-b6bf6e8498ac797fa2b801392b03c330/'
          ..style.border = 'none');

    return (Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).width * 0.3,
        child: HtmlElementView(viewType: 'hello-world-html'),
      ),
    ));
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool hide = false}) {
    return TextFormField(
      controller: controller,
      obscureText: hide,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: Theme.of(context).textTheme.labelSmall,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surface, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surface, width: 1.5),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label cannot be empty. Please enter a valid value.';
        }
        if (label == 'Email' && !_isValidEmail(value.trim())) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Widget _buildLoginButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _login();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          'Login',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()), // Assuming RegisterPage() is the registration screen
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          'Register',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      children: [
        _buildLoginButton(),
        const SizedBox(width: 10), // Space between buttons
        _buildRegisterButton(),
      ],
    );
  }
}
