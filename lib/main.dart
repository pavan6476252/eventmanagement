import 'package:eventmanagement/api/api_handler.dart';
import 'package:eventmanagement/features/auth/bloc/authentication_bloc.dart';
import 'package:eventmanagement/features/business/bloc/bills/business_bills_management_bloc.dart';
import 'package:eventmanagement/features/business/bloc/business_bloc.dart';
import 'package:eventmanagement/features/business/bloc/template/business_template_management_bloc.dart';
import 'package:eventmanagement/features/notifications/bloc/notification_bloc.dart';
import 'package:eventmanagement/features/profile/bloc/profile_bloc.dart';
import 'package:eventmanagement/firebase_options.dart';
import 'package:eventmanagement/router.dart';
import 'package:eventmanagement/services/authentication_ser.dart';
import 'package:eventmanagement/services/business_bills_services.dart';
import 'package:eventmanagement/services/business_services.dart';
import 'package:eventmanagement/services/business_template_service.dart';
import 'package:eventmanagement/services/notification_services.dart';
import 'package:eventmanagement/services/user_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';

const baseUrl = 'https://rental-app-backend.onrender.com';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
            context, AuthenticationService(ApiHandler(baseUrl, null))),
      ),
      BlocProvider<NotificationBloc>(
        create: (context) => NotificationBloc(
            context, NotificationService(ApiHandler(baseUrl, context))),
      ),
      BlocProvider<ProfileBloc>(
        create: (context) =>
            ProfileBloc(context, UserService(ApiHandler(baseUrl, context))),
      ),
      BlocProvider<BusinessBloc>(
        create: (context) => BusinessBloc(
            context, BusinessService(ApiHandler(baseUrl, context))),
      ),
      BlocProvider<BusinessTemplateManagementBloc>(
        create: (context) => BusinessTemplateManagementBloc(
            context, BusinessTemplateService(ApiHandler(baseUrl, context))),
      ),
      BlocProvider<BusinessBillsManagementBloc>(
        create: (context) => BusinessBillsManagementBloc(
            context, BusinessBillsService(ApiHandler(baseUrl, context))),
      )
    ], child: const App());
  }
}

// GlobalKey<ScaffoldMessengerState> key;

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<AuthenticationBloc, AuthenticationState>(
    // builder: (context, state) {
    return MaterialApp.router(
      // scaffoldMessengerKey: key,
      routerConfig: appRouter(context.read<AuthenticationBloc>()),
      // );
      // },
    );
  }
}
