import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.serverError({
    int? statusCode,
    String? message,
  }) = _ServerError;
  const factory Failure.unexpectedError() = _UnexpectedError;
}
