import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
  (ref) {
    final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
    return RegisterFormNotifier(registerUserCallback: registerUserCallback);
  },
);

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String) registerUserCallback;

  RegisterFormNotifier({required this.registerUserCallback})
      : super(RegisterFormState());

  onFullNameChanged(String value) {
    final fullName = FullName.dirty(value);
    state = state.copyWith(
      fullName: fullName,
      isFormValid: Formz.validate(
          [fullName, state.email, state.password, state.confirmPassword]),
    );
  }

  onEmailChanged(String value) {
    final email = Email.dirty(value);
    state = state.copyWith(
      email: email,
      isFormValid: Formz.validate(
          [email, state.fullName, state.password, state.confirmPassword]),
    );
  }

  onPasswordChanged(String value) {
    final password = Password.dirty(value, true);
    state = state.copyWith(
      password: password,
      isFormValid: Formz.validate(
          [password, state.email, state.fullName, state.confirmPassword]),
    );
  }

  onConfirmPasswordChanged(String value) {
    final confirmPassword = Password.dirty(value, false);
    state = state.copyWith(
      confirmPassword: confirmPassword,
      isFormValid: Formz.validate(
          [confirmPassword, state.email, state.fullName, state.password]),
    );
  }

  onRegisterFormSubmit() async {
    _touchEveryField();

    if (!state.isFormValid) return;

    await registerUserCallback(
        state.fullName.value, state.email.value, state.password.value);
  }

  _touchEveryField() {
    final fullName = FullName.dirty(state.fullName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value, true);
    final confirmPassword = Password.dirty(state.confirmPassword.value, false);

    state = state.copyWith(
      isFormPosted: true,
      isFormValid: Formz.validate([fullName, email, password, confirmPassword]),
      fullName: fullName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isFormValid;
  final FullName fullName;
  final Email email;
  final Password password;
  final Password confirmPassword;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isFormValid = false,
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const Password.pure(checkFormat: false),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isFormValid,
    FullName? fullName,
    Email? email,
    Password? password,
    Password? confirmPassword,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isFormValid: isFormValid ?? this.isFormValid,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
      );

  @override
  String toString() {
    return '''
    RegisterFormState(
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isFormValid: $isFormValid,
      fullName: $fullName,
      email: $email,
      password: $password,
      confirmPassword: $confirmPassword,
    )
    ''';
  }
}
