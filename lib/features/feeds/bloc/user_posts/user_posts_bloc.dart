import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_posts_event.dart';
part 'user_posts_state.dart';

class UserPostsBloc extends Bloc<UserPostsEvent, UserPostsState> {
  UserPostsBloc() : super(UserPostsInitial()) {
    on<UserPostsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
