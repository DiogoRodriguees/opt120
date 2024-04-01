import 'package:client/form.dart';
import 'package:flutter/material.dart';

void main() {
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const formTitle = "Register user";

    return MaterialApp(
      title: formTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(formTitle)),
        body: const UserForm(),
      ),
    );
  }
}
