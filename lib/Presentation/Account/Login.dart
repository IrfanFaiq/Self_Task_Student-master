import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_task_student/Bloc/Authenticate/auth_bloc.dart';

import '../Dashboard/Home.dart';
import '../Widgets/curveWidget.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const Register()));
            },
            child: const Text("Register"),
          )
        ],
        backgroundColor: Colors.transparent,

      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
            ));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is UnAuthenticated) {
            return Stack(
              children: [
                CurveWidget(
                  //call from widget

                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                      begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.blue,
                          Colors.green,
                        ],
                      ),
                    ),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.65,
                    // color: const Color.fromARGB(255, 4, 199, 199),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 170),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Container(
                            // padding: const EdgeInsets.only(bottom: 310),
                            height: 169,
                            width: 169,
                            // decoration: const BoxDecoration(
                            //     image: DecorationImage(
                            //         image:
                            //         AssetImage('assets/doctor.png'),
                            //         fit: BoxFit.fill)
                            // ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          Center(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _usernameField(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _passwordField(),
                                  const SizedBox(
                                    height: 100,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: Material(
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(25)),
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Colors.green,
                                              Colors.blue,
                                            ],
                                          ),
                                        ),
                                        child:ElevatedButton(
                                          onPressed: () {
                                            _authenticateWithEmailAndPassword(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              primary: Colors.transparent,
                                              fixedSize: const Size(300, 60),
                                              shape:
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                                          child: const Text('Sign In'),
                                        )
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                        ]),
                  ),
                ),
              ],
            );
          }
          return Container();
        }),
      ),
    );
  }

  Widget _usernameField() {
    return TextFormField(
      controller: _emailController,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: const InputDecoration(
        //hintText: 'Username',
        hintText: 'email',
        hintStyle: TextStyle(color: Colors.white),
        icon: Icon(Icons.person, color: Colors.white,),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return value != null && !EmailValidator.validate(value)
            ? 'Enter a valid email'
            : null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration:
          const InputDecoration(hintStyle: TextStyle(color: Colors.white),hintText: 'password', icon: Icon(Icons.security, color: Colors.white,)),
    );
  }

  Widget _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.green,
          fixedSize: const Size(300, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: const Text('Login'),
    );
  }

  void _authenticateWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
  }
}
