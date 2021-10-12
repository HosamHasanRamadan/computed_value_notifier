import 'package:flutter/material.dart';

import 'form_view_model.dart';

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
