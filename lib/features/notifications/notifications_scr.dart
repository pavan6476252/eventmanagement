import 'package:eventmanagement/features/notifications/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   context.read<NotificationBloc>().add(FetchNotificationsEvent());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(
                child: Text('No notifications found!'),
              );
            }
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return ListTile(
                  title: Text(notification.message),
                  subtitle: Text(notification.createdAt.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context
                          .read<NotificationBloc>()
                          .add(DeleteNotificationEvent(notification.id));
                    },
                  ),
                  onTap: () {
                    context
                        .read<NotificationBloc>()
                        .add(ReadNotificationEvent(notification.id));
                  },
                );
              },
            );
          } else if (state is NotificationError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text("No notifications found."));
          }
        },
      ),
    );
  }
}
