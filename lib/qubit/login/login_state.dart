part of 'login_cubit.dart';

@immutable
class LoginState {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  const LoginState({
    required this.isLoading,
    required this.hasError,
    this.errorMessage,
  });

  LoginState copyWith({isLoading, hasError, errorMessage = ""}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
