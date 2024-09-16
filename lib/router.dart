import 'package:eventmanagement/features/auth/bloc/authentication_bloc.dart';
import 'package:eventmanagement/features/auth/screens/login_scr.dart';
import 'package:eventmanagement/features/auth/screens/signup_scr.dart';
import 'package:eventmanagement/common/splash_scr.dart';
import 'package:eventmanagement/features/business/screens/create_new_business_bill_scr.dart';
import 'package:eventmanagement/features/business/screens/create_new_business_screen.dart';
import 'package:eventmanagement/features/business/screens/create_new_business_template_scr.dart';
import 'package:eventmanagement/features/business/screens/my_businesses_screen.dart';
import 'package:eventmanagement/features/feeds/screens/create_post_scr.dart';
import 'package:eventmanagement/features/home/home_scr.dart';
import 'package:eventmanagement/features/notifications/notifications_scr.dart';
import 'package:eventmanagement/features/profile/personal_details_scr.dart';
import 'package:eventmanagement/features/profile/profile_scr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter appRouter(AuthenticationBloc bloc) => GoRouter(
      debugLogDiagnostics: true,
      redirect: (BuildContext context, GoRouterState state) async {
        final isAuthenticated = bloc.state is AuthenticationAuthenticated;
        if (!isAuthenticated) {
          if (state.fullPath!.startsWith('/login') ||
              state.fullPath!.startsWith('/signup')) {
            return null;
          } else {
            return '/login';
          }
        } else {
          if (state.fullPath!.startsWith('/signup') ||
              state.fullPath!.startsWith('/login')) {
            return '/home';
          } else if (state.fullPath!.startsWith('/spash')) {
            // await Future.delayed(Duration(seconds: 3));
            return '/home';
          } else {
            return null;
          }
        }
      },
      // initialLocation: '/home/create-post',
      // initialLocation: '/home',
      // initialLocation:
      // '/home/my-business/create-new-business-template/6658d28f866ed5a914db71f7',
      // initialLocation:
      // '/home/my-business/create-new-business-bill?templateId=665a363f9c879670ed84dca2',
      initialLocation: '/splash',
      refreshListenable: BlocListenable(bloc),
      routes: [
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: 'signup',
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          name: 'splash',
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
            name: 'home',
            path: '/home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                name: 'notifications',
                path: 'notifications',
                builder: (context, state) => const NotificationScreen(),
              ),
              GoRoute(
                name: 'profile',
                path: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
              GoRoute(
                name: 'personalDetails',
                path: 'personal-details',
                builder: (context, state) => const PersonalDetailsScreen(),
              ),
              GoRoute(
                name: 'createPost',
                path: 'create-post',
                builder: (context, state) => const CreatePostScreen(),
              ),
              GoRoute(
                  name: 'myBusiness',
                  path: 'my-business',
                  builder: (context, state) => const MyBusinessesScreen(),
                  routes: [
                    GoRoute(
                      name: 'createNewBusiness',
                      path: 'create-new-business',
                      builder: (context, state) =>
                          const CreateNewBusinessScreen(),
                    ),
                    GoRoute(
                      name: 'createNewBusinessTemplate',
                      path: 'create-new-business-template/:businessId',
                      builder: (context, state) => CreateNewBusinessTemplate(
                        businessId: state.pathParameters['businessId'],
                      ),
                    ),
                    GoRoute(
                      name: 'createNewBusinessBill',
                      path: 'create-new-business-bill',
                      builder: (context, GoRouterState state) =>
                          CreateNewBusinessBillScreen(
                              templateId:
                                  (state.uri.queryParameters)['templateId']),
                    ),
                  ]),
            ]),
      ],
      errorPageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(state.error.toString()),
          ),
        ),
      ),
    );

class BlocListenable<T> extends ChangeNotifier implements Listenable {
  final BlocBase<T> bloc;

  BlocListenable(this.bloc) {
    bloc.stream.listen((state) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
