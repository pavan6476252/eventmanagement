import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventmanagement/features/auth/bloc/authentication_bloc.dart';
import 'package:eventmanagement/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({super.key});

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async =>
            {context.read<ProfileBloc>().add(FetchProfileEvent())},
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            _buildProfile(context),
            const SizedBox(height: 15),
            _buildUserRoutes(context),
            const SizedBox(height: 15),
            _buildAppInfoRoutes(context),
            const SizedBox(height: 15),
            _buildLogoutButton(context)
          ],
        ),
      ),
    );
  }

  _buildProfile(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: color.secondaryContainer, blurRadius: 2, spreadRadius: 2)
          ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 0.2)),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.profileStatus == ProfileStatus.fetchSuccess ||
              state.profileStatus == ProfileStatus.updateSuccess ||
              state.user.data != null) {
            return ListTile(
                title: Text(
                  (state.user.data?.firstName == null &&
                          state.user.data?.lastName == null)
                      ? "Name not found"
                      : "${state.user.data?.firstName ?? ""} ${state.user.data?.firstName ?? ""}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
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
                trailing: (state.profileStatus == ProfileStatus.loading)
                    ? const SizedBox(
                        width: 5, height: 5, child: CircularProgressIndicator())
                    : null,
                leading: CircleAvatar(
                    backgroundImage: state
                            .user.data!.photoUrlModel.secureUrl.isEmpty
                        ? const NetworkImage('https://via.placeholder.com/50')
                        : CachedNetworkImageProvider(
                            state.user.data!.photoUrlModel.secureUrl)));
          }
          if (state.profileStatus == ProfileStatus.fetchFailed ||
              state.profileStatus == ProfileStatus.updateFailed) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text("Some thin went wrong retry ?"),
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        },
        listener: (context, state) {},
      ),
    );
  }

  _buildUserRoutes(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 0.2)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _routeListTile(context, Icons.person_2_sharp, "Personal Details",
                'personal-details',
                onClick: () => {context.goNamed('personalDetails')}),
            _routeListTile(
                context, Icons.business_outlined, "My Business", 'my-business',
                onClick: () => {context.goNamed('myBusiness')}),
            const SizedBox(height: 5),
            _routeListTile(context, Icons.favorite_border, "My Favorites", ''),
            const SizedBox(height: 5),
            _routeListTile(context, Icons.notifications_outlined,
                "Notifications Details", ''),
            const SizedBox(height: 5),
            _routeListTile(context, Icons.settings_outlined, "Settings", ''),
          ],
        ));
  }

  _buildAppInfoRoutes(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 0.2)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _routeListTile(context, Icons.fact_check_outlined, "FAQs ", ''),
            const SizedBox(height: 5),
            _routeListTile(
                context, Icons.privacy_tip_outlined, "Privacy Policy", ''),
            const SizedBox(height: 5),
            _routeListTile(context, Icons.android_outlined, "About App", ''),
            const SizedBox(height: 5),
            _routeListTile(context, Icons.details_outlined, "About Us", ''),
          ],
        ));
  }

  _routeListTile(
      BuildContext context, IconData icon, String routeName, String? route,
      {VoidCallback? onClick, Color? iconBgColor}) {
    final style = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: iconBgColor ?? color.primaryContainer,
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(
                    icon,
                    size: 25,
                    color: color.primary,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  routeName,
                  style: style.titleMedium,
                )
              ],
            ),
            const Icon(Icons.arrow_forward_ios_sharp)
          ],
        ),
      ),
    );
  }

  _buildLogoutButton(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          splashColor: color.primaryContainer,
          onTap: () => {
            if (state is AuthenticationAuthenticated)
              context
                  .read<AuthenticationBloc>()
                  .add(LogoutEvent(state.tokenModel.accessToken))
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: color.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 0.2)),
              child: _routeListTile(context, Icons.logout, 'Logout', null,
                  iconBgColor: color.errorContainer)),
        );
      },
    );
  }
}
