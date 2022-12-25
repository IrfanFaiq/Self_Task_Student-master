import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_task_student/Bloc/Manage%20User/user_bloc.dart';
import 'package:self_task_student/Presentation/Dashboard/Home.dart';

import '../../Data/Database/Firebase/Model/UserModel.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileEdit();
}

class _ProfileEdit extends State<ProfileEdit> {
  final user = FirebaseAuth.instance.currentUser!;
  final UserBloc userBloc = UserBloc();
  final _formKey = GlobalKey<FormState>();
  final _fullNamelController = TextEditingController();
  final _pNumberController = TextEditingController();
  final _matrixIDController = TextEditingController();

  @override
  void initState() {
    userBloc.add(GetUser(user.email!));
    super.initState();
  }

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
              title: const Text('Update Profile'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: BlocProvider(
                create: ((context) {
                  return userBloc;
                }),
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state){
                    if(state is UserLoaded){
                      Map<String, dynamic> data = state.userdata.data() as Map<String, dynamic>;
                      _fullNamelController.text = data['fullName'] ?? '';
                      _pNumberController.text = data['pNumber'] ?? '';
                      _matrixIDController.text = data['matrixId'] ?? '';
                      return Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _fullName(),
                              const SizedBox(height: 20),
                              _phoneNumber(),
                              const SizedBox(height: 20),
                              _matrixNumber(),
                              const SizedBox(height: 100),
                              Material(
                                elevation: 8,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  child: Container(
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
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.transparent,
                                          fixedSize: const Size(300, 60),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          UserModel userModel = UserModel(
                                            fullName: _fullNamelController.text,
                                            email: user.email!,
                                            pNumber: _pNumberController.text,
                                            matrixId: _matrixIDController.text.toUpperCase(),
                                          );
                                          userBloc.add(UpdateUser(userModel, user.email!));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Profile Edit Success'),
                                                backgroundColor: Colors.green,
                                              )
                                          );
                                          Navigator.pop(context);
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Something went wrong'),
                                                backgroundColor: Colors.red,
                                              )
                                          );
                                        }
                                      },
                                      child: const Text('Confirm Update'),
                                    ),
                                  ),
                              )
                              ,
                            ],
                          ));
                    }else{
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),
              )

            ),
        ));
  }

  Widget _fullName() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your Name';
        }
        return null;
      },
      controller: _fullNamelController,
      decoration: const InputDecoration(
        hintText: 'Full Name',
      ),
    );
  }


  Widget _phoneNumber() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your phone number';
        }
        return null;
      },
      controller: _pNumberController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Phone number',
      ),
    );
  }

  Widget _matrixNumber() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your Student ID';
        }
        return null;
      },
      controller: _matrixIDController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Student ID',
      ),
    );
  }


}
