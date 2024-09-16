import 'package:eventmanagement/common/custom_drawer.dart';
import 'package:eventmanagement/features/business/bloc/bills/business_bills_management_bloc.dart';
import 'package:eventmanagement/features/business/bloc/business_bloc.dart';
import 'package:eventmanagement/features/business/bloc/template/business_template_management_bloc.dart';
import 'package:eventmanagement/features/business/business_home_scr.dart';
import 'package:eventmanagement/features/feeds/feeds_home_scr.dart';
import 'package:eventmanagement/features/notifications/bloc/notification_bloc.dart';
import 'package:eventmanagement/features/profile/bloc/profile_bloc.dart';
import 'package:eventmanagement/features/profile/profile_home_scr.dart';
import 'package:eventmanagement/features/store/store_home_scr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final profileBloc = context.read<ProfileBloc>();
    final businessBloc = context.read<BusinessBloc>();
    if (mounted &&
        profileBloc.state.profileStatus == ProfileStatus.initial &&
        profileBloc.state.user.data == null) {
      profileBloc.add(FetchProfileEvent());
    }
    if (mounted &&
        businessBloc.state.businessStatus == BusinessStatus.initial &&
        businessBloc.state.businesses.data.isEmpty) {
      print('called');
      businessBloc.add(FetchMyBusinessesEvent());
    }

    if (mounted) {
      context.read<NotificationBloc>().add(FetchNotificationsEvent());
    }

    // if (businessBloc.state.businesses.data.isNotEmpty) {
    //   final businessId = businessBloc.state.businesses.data[0].id;

    //   if (businessId != null) {
    //     context
    //         .read<BusinessTemplateManagementBloc>()
    //         .add(FetchBusinessTemplateEvent(businessId));
    //   }
    // }
  }

  int selectedIdx = 2;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessBloc, BusinessState>(
      listener: (context, state) {
        if (state.businessStatus == BusinessStatus.fetchSuccess &&
            state.selectedBusinessId.isNotEmpty) {
          context
              .read<BusinessTemplateManagementBloc>()
              .add(FetchBusinessTemplateEvent(state.selectedBusinessId));
          context
              .read<BusinessBillsManagementBloc>()
              .add(FetchBusinessBillsEvent(state.selectedBusinessId));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Events Management",
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              IconButton(
                  onPressed: () {
                    context.goNamed('notifications');
                  },
                  icon: const Icon(Icons.notifications_active))
            ],
          ),
          drawer: const CustomDrawer(),
          body: [
            const FeedsHomeScreen(),
            const StoreHomeScreen(),
            // if (state.selectedBusinessId.isNotEmpty) const BusinessHomeScreen(),
            const ProfileHomeScreen(),
          ].elementAt(selectedIdx),
          bottomNavigationBar: NavigationBar(
            // selectedIndex: (state.selectedBusinessId.isNotEmpty)
            //     ? selectedIdx
            //     : selectedIdx - 1,
            selectedIndex: selectedIdx,
            onDestinationSelected: (idx) {
              setState(() {
                selectedIdx = idx;
              });
            },
            destinations: const [
              const NavigationDestination(
                icon: Icon(Icons.feed_outlined),
                label: 'Feed',
                selectedIcon: Icon(Icons.feed),
              ),
              const NavigationDestination(
                icon: Icon(Icons.store_outlined),
                label: 'Store',
                selectedIcon: Icon(Icons.store),
              ),
              // if (state.selectedBusinessId.isNotEmpty)
              //   const NavigationDestination(
              //     icon: Icon(Icons.receipt_outlined),
              //     label: 'Business',
              //     selectedIcon: Icon(Icons.receipt),
              //   ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
                selectedIcon: Icon(Icons.person),
              ),
            ],
          ),
        );
      },
    );
  }
}
