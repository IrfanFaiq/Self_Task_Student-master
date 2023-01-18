import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_task_student/Data/Database/Firebase/Repository/UserRepository.dart';
import 'package:self_task_student/Presentation/Manage%20Subject/AddSubject.dart';
import 'package:self_task_student/presentation/Account/Login.dart';
import 'package:self_task_student/presentation/Dashboard/Home.dart';

import '/Data/Database/Firebase/Repository/auth_repository.dart';
import 'Bloc/Authenticate/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //for notification initialize
  AwesomeNotifications().initialize(
    'resource://drawable/important',
    [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        defaultColor: Colors.blue,
        locked: true,
        importance: NotificationImportance.High,
        channelDescription: 'Notification',
      ),
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => AuthRepository(),
        child: BlocProvider(
          create: (context) => AuthBloc(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.green,
            ),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FutureBuilder(
                      future: internetCheck(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return const Home();
                          } else {
                            return Login();
                          }
                        } else {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.green,
                            ),
                          );
                        }
                      });
                }
                return Login();
              },
            ),
          ),
        ));

    // return RepositoryProvider(
    //   create: (context) => AuthRepository(),
    //   child: BlocProvider(
    //     create: (context) => AuthBloc(
    //       authRepository: RepositoryProvider.of<AuthRepository>(context),
    //     ),
    //     child: MaterialApp(
    //       debugShowCheckedModeBanner: false ,
    //       title: 'Self-Task Student',
    //       theme: ThemeData(
    //         primaryColor: Colors.green,
    //       ),
    //       home: Login(),
    //     ),
    //   ),
    // );
  }

  Future<bool?> internetCheck() async {
    final result = await InternetAddress.lookup('www.google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return null;
    }
  }
}
