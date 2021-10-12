import 'package:flutter/foundation.dart';

import 'package:computed_value_notifier/computed_value_notifier.dart';

class FormViewModel {
  final ValueNotifier<String> email;
  final ValueNotifier<String> password;

  late final ComputedValueNotifier<bool> isEmailValid;
  late final ComputedValueNotifier<bool> isPasswordValid;

  late final ComputedValueNotifier<bool> canLogin;

  FormViewModel({
    String email = '',
    String password = '',
  })  : this.email = ValueNotifier(email),
        this.password = ValueNotifier(password) {
    isEmailValid = ComputedValueNotifier(
      listenable: this.email,
      compute: () => this.email.value.contains('@'),
    );

    isPasswordValid = ComputedValueNotifier(
      listenable: this.password,
      compute: () => this.password.value.length > 8,
    );

    canLogin = ComputedValueNotifier(
      listenable: Listenable.merge([isEmailValid, isPasswordValid]),
      compute: () => isEmailValid.value && isPasswordValid.value,
    );
  }

  void dispose() {
    /// order of disposing is important
    /// dispose derived values first
    canLogin.dispose();
    isEmailValid.dispose();
    isPasswordValid.dispose();

    email.dispose();
    password.dispose();
  }
}
