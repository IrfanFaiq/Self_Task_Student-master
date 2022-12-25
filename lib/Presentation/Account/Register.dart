import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_task_student/Bloc/Manage%20User/user_bloc.dart';
import 'package:self_task_student/Data/Database/Firebase/Model/UserModel.dart';
import 'package:self_task_student/Data/Database/Firebase/Repository/UserRepository.dart';
import 'package:self_task_student/Presentation/Dashboard/Home.dart';

import '../../Bloc/Authenticate/auth_bloc.dart';
import 'Login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Register();
}

class _Register extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _matrixNumberController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _matrixNumberController.dispose();
    _rePasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[Colors.blue, Colors.green]),
          ),
        ),
        title: Text('Register'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: const Text("Login"),
          )
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          }
          if (state is AuthError) {
            // Displaying the error message if the user is not authenticated
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            // Displaying the loading indicator while the user is signing up
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UnAuthenticated) {
            // Displaying the sign up form if the user is not authenticated
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Center(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _email(),
                              const SizedBox(
                                height: 10,
                              ),
                              _password(),
                              const SizedBox(
                                height: 10,
                              ),
                              _rePassword(),
                              const SizedBox(
                                height: 10,
                              ),
                              _fullName(),
                              const SizedBox(
                                height: 10,
                              ),
                              _phoneNumber(),
                              const SizedBox(
                                height: 100,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: ElevatedButton(
                                  onPressed: () {
                                    UserRepository userRepository = UserRepository();
                                    UserModel userModel = UserModel(
                                      fullName: _fullNameController.text,
                                      email: "${_emailController.text.toLowerCase()}@student.ump.edu.my",
                                      pNumber: _phoneNumberController.text,
                                      matrixId: _emailController.text.toUpperCase(),
                                    );
                                    userRepository.addUser(userModel, "${_emailController.text.toLowerCase()}@student.ump.edu.my");
                                    _createAccountWithEmailAndPassword(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      fixedSize: const Size(300, 60),
                                      shape:
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                                  child: const Text('Sign Up'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 40),
      //   key: _formKey,
      //   child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //     _fullName(),
      //     SizedBox(height: 10),
      //     _email(),
      //     SizedBox(height: 10),
      //     _phoneNumber(),
      //     SizedBox(height: 10),
      //     _matrixNumber(),
      //     SizedBox(height: 10),
      //     _password(),
      //     SizedBox(height: 10),
      //     _rePassword(),
      //     SizedBox(height: 40),
      //     _registerButton(context),
      //   ]),
      // ),
    );
  }

  Widget _fullName() {
    return TextFormField(
      controller: _fullNameController,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Enter your Full Name";
        }
      },
      decoration: InputDecoration(
        hintText: 'Full Name',
      ),
    );
  }

  Widget _email() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        suffixText: '@student.ump.edu.my',
        hintText: "Email / Student ID"
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your Student ID';
        }

        return null;
      },
    );
  }

  Widget _phoneNumber() {
    return TextFormField(
      controller: _phoneNumberController,
      validator: (value){
        String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
        RegExp regExp = RegExp(patttern);
        if(value == null || value.isEmpty){
          return "Enter your phone number";
        }
        else if (!regExp.hasMatch(value)) {
          return 'Please enter valid phone number';
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Phone number',
      ),
    );
  }

  Widget _matrixNumber() {
    return TextFormField(
      controller: _matrixNumberController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Matrix ID',
      ),
    );
  }

  Widget _password() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return value != null && value.length < 6
            ? "Enter min. of 6 characters"
            : null;
      },
    );
  }

  Widget _rePassword() {
    return TextFormField(
      controller: _rePasswordController,
      validator: (value){
        if(value == null || value.isEmpty){
          return "Enter your password";
        }
        return _passwordController.text == value ? null : "The password is not the same";
      },
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Re-Password',
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Register()));
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.green,
          fixedSize: const Size(300, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: Text('Register'),
    );
  }

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(
          "${_emailController.text}@student.ump.edu.my",
          _passwordController.text,
        ),
      );

    }
  }
}
