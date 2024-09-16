part of 'user_posts_bloc.dart';

sealed class UserPostsState extends Equatable {
  const UserPostsState();
  
  @override
  List<Object> get props => [];
}

final class UserPostsInitial extends UserPostsState {}
