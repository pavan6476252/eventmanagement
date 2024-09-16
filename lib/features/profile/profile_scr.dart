import 'dart:developer';

import 'package:eventmanagement/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              log('$state');
              // if (state.profileStatus == ProfileStatus.initial) {
              //   log('initial');
              // }
            },
            builder: (context, state) {
              return Center(
                child: Text("$state"),
              );
            },
          ),
        ));
  }
}
