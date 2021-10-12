### Form View Models that contains Form Fields State

```dart
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

```
### Simple Form UI

<details><summary>UI Code</summary>

```dart
void main(List<String> args) {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final FormViewModel formViewModel;

  @override
  void initState() {
    super.initState();
    formViewModel = FormViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Computed Value Notifier Example')),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Email'),
                onChanged: (newValue) => formViewModel.email.value = newValue,
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
                onChanged: (newValue) =>
                    formViewModel.password.value = newValue,
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<bool>(
                  valueListenable: formViewModel.canLogin,
                  child: const Text('Log In'),
                  builder: (context, canLogin, child) {
                    return ElevatedButton(
                      onPressed: canLogin ? () {} : null,
                      child: child,
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    formViewModel.dispose();
    super.dispose();
  }
}
```
</details>
