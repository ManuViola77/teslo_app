import 'package:teslo_shop/features/shared/shared.dart';

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isFormValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isFormValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });
}
