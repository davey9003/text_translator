import 'package:equatable/equatable.dart';

sealed class Result<T> extends Equatable {
  const Result();
  
  @override
  List<Object?> get props => [];
}

final class Success<T> extends Result<T> {
  final T data;
  
  const Success(this.data);
  
  @override
  List<Object?> get props => [data];
}

final class Failure<T> extends Result<T> {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}


