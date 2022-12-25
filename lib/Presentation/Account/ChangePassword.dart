import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:self_task_student/Presentation/Dashboard/Home.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _reNewPasswordController = TextEditingController();
  bool checkCurrentPassword = true;
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: <Color>[Colors.blue, Colors.green]),
                ),
              ),
              title: const Text('Change Password'),
              centerTitle: true,
            ),
            body: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _oldPassword(),
                        const SizedBox(height: 10),
                        _password(),
                        const SizedBox(height: 10),
                        _rePassword(),
                        const SizedBox(height: 100),
                        _confirmButton(context),
                      ],
                    )))));
  }

  Widget _oldPassword() {
    return TextFormField(
      controller: _oldPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Old Password',
      ),
      validator: (value) {
        return value != null && value.length < 6
            ? "Please enter a valid password"
            : null;
      },
    );
  }

  Widget _password() {
    return TextFormField(
      controller: _newPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
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
      controller: _reNewPasswordController,
      validator: (value){
        return _newPasswordController.text == value ? null : "The password is not the same";
      },
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Re-Password',
      ),
    );
  }

  Widget _confirmButton(context) {
    return Material(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child:  Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.greenAccent,
              Colors.lightBlue
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: user.email!,
                  password: _oldPasswordController.text,
                );

                user.updatePassword(_reNewPasswordController.text).then((_){
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Successfully changed password'),
                        backgroundColor: Colors.green,
                      )
                  );

                  Navigator.pop(context);

                }).catchError((error){
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Something went wrong please try again later'),
                        backgroundColor: Colors.red,
                      )
                  );

                  print("Password can't be changed" + error.toString());
                  //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No user found'),
                        backgroundColor: Colors.red,
                      )
                  );
                } else if (e.code == 'wrong-password') {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wrong password provided'),
                        backgroundColor: Colors.red,
                      )
                  );
                }
              }


            }

          },
          style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              fixedSize: const Size(300, 60),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
          child: const Text("Confirm"),
        ),
      ),
    );
  }
}
