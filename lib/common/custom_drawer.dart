import 'package:eventmanagement/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
            if (state.profileStatus == ProfileStatus.loading ||
                state.profileStatus == ProfileStatus.loading) {}

            if (state.profileStatus == ProfileStatus.fetchSuccess ||
                state.profileStatus == ProfileStatus.updateSuccess) {
              return UserAccountsDrawerHeader(
                onDetailsPressed: () => context.goNamed('profile'),
                accountName: Text(
                  (state.user.data?.firstName == null &&
                          state.user.data?.lastName == null)
                      ? "Name not found"
                      : "${state.user.data?.firstName ?? ""} ${state.user.data?.firstName ?? ""}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.user.data?.email ?? "",
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Spacer(),
                    if (state.user.data?.emailVerified == true)
                      const Icon(
                        Icons.verified,
                        color: Colors.blueAccent,
                      )
                  ],
                ),
                currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        state.user.data!.photoUrlModel.secureUrl.isEmpty
                            ? const NetworkImage('https://via.placeholder.com/150')
                            : CachedNetworkImageProvider(
                                state.user.data!.photoUrlModel.secureUrl)),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              );
            }
            return Center(
              child: Text("$state"),
            );
          }),
          ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      topRight: Radius.circular(50))),
              leading: Icon(Icons.folder,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('My Files'),
              onTap: () {
                Navigator.pop(context);
              },
              selected: true,
              selectedColor: Theme.of(context).colorScheme.primaryContainer),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Shared with me'),
            onTap: () {
              // Handle navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Starred'),
            onTap: () {
              // Handle navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Recent'),
            onTap: () {
              // Handle navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Offline'),
            onTap: () {
              // Handle navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Uploads'),
            onTap: () {
              // Handle navigation
            },
          ),
        ],
      ),
    );
  }
}
