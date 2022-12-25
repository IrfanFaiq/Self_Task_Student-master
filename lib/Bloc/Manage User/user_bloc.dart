import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:self_task_student/Bloc/Manage%20Assignment/assignment_bloc.dart';
import 'package:self_task_student/Data/Database/Firebase/Model/UserModel.dart';
import 'package:self_task_student/Data/Database/Firebase/Repository/UserRepository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    final UserRepository  userRepository = UserRepository();

    on<CreateUser>((event, emit) async {
      await userRepository.addUser(event.userModel, event.email);
    });

    on<UpdateUser>((event, emit) async {
      await userRepository.updateUser(event.userModel, event.email);
    });

    on<GetUser>((event, emit) async {
      emit(UserLoading());
      final userdata = await userRepository.getSpecificUser(event.email);
      emit(UserLoaded(userdata));
    });
  }
}
