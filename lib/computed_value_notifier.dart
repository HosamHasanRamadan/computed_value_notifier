library computed_value_notifier;

import 'package:flutter/foundation.dart';

/// A class that can be used to derive a value based on data from another
/// Listenable or Listenables.
///
/// The value will be recomputed when the provided [_listenable] notifies the
/// listeners that values have changed.
///
/// ### Simple Example
///
/// ```dart
/// final email = ValueNotifier<String>('a');
///
/// // Determine whether or not the email is valid using a (hacky) validator.
/// final emailValid = ComputedValueNotifier(
///   email,
///   () => email.value.contains('@'),
/// );
///
/// // The function provided to ComputedValueNotifier is immediately executed,
/// // and the computed value is available synchronously.
/// print(emailValid.value); // prints 'false'.
///
/// // When the email ValueNotifier is changed, the function will be run again!
/// email.value = 'a@b.com';
/// print(emailValid.value); // prints 'true'.
/// ```
///
/// ### Deriving data from multiple listenables
///
/// In this case, we can use the `Lisetenable.merge` function provided by
/// Flutter to merge several variables.
///
/// ```dart
/// final email = ValueNotifier<String>('');
/// final password = ValueNotifier<String>('');
///
/// // Determine whether the email is valid, and make that a Listenable!
/// final emailValid = ComputedValueNotifier<bool>(
///   email,
///   () => email.value.contains('@'),
/// );
///
/// // Determine whether the password is valid, and make that a Listenable!
/// final passwordValid = ComputedValueNotifier<bool>(
///   password,
///   () => password.value.length >= 6,
/// );
///
/// // Now, we will only enable the "Login Button" when the email and
/// // password are valid. To do so, we can listen to the emailValid and
/// // passwordValid ComputedValueNotifiers.
/// final loginButtonEnabled = ComputedValueNotifier<bool>(
///   Listenable.merge([emailValid, passwordValid]),
///   () => emailValid.value && passwordValid.value,
/// );
///
/// // Update the email
/// print(emailValid.value); // false
/// print(loginButtonEnabled.value); // false
/// email.value = 'a@b.com';
/// print(emailValid.value); // true
/// print(loginButtonEnabled.value); // false
///
/// // Update the password
/// print(passwordValid.value); // false
/// password.value = '123456';
/// print(passwordValid.value); // true
/// print(loginButtonEnabled.value); // true
/// ```

class ComputedValueNotifier<T> extends ChangeNotifier
    implements ValueListenable<T> {
  final Listenable _listenable;
  final T Function() _compute;

  T _value;

  /// The current value stored in this notifier.
  @override
  T get value => _value;

  /// Computed [value] based on another [listenable]
  ComputedValueNotifier({
    required Listenable listenable,
    required T Function() compute,
  })  : _listenable = listenable,
        _compute = compute,
        _value = compute() {
    _listenable.addListener(_updateValue);
  }

  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  void _updateValue() {
    final newValue = _compute();
    if (newValue == _value) return;
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($_value)';

  @override
  void dispose() {
    _listenable.removeListener(_updateValue);
    super.dispose();
  }
}
