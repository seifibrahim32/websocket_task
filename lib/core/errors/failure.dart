import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final int responseCode;

  const Failure(this.responseCode, this.message);

  @override
  List<Object> get props => [responseCode, message];
}
