import 'package:flutter/material.dart';

// class UserForm extends StatelessWidget {
//   const UserForm({super.key});

//   static const sizeBox = SizedBox(
//     // color: Colors.blue[600],
//     height: 300,
//     width: 275,
//     child: FormContainer(),
//   );

//   @override
//   Widget build(BuildContext context) => const FormContainer();
// }

class UserForm extends StatelessWidget {
  const UserForm({super.key});

  static const column = Column(
    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Wrap(
        runSpacing: 20,
        children: [
          InputEmail(key: Key('Enter your email')),
          InputPassword(),
          FormButton()
        ],
      )
    ],
  );

  static const sizeBox = SizedBox(
    // color: Colors.blue[600],
    height: 300,
    width: 275,
    child: column,
  );

  @override
  Widget build(BuildContext context) => const Center(child: sizeBox);
}

class InputEmail extends StatelessWidget {
  const InputEmail({super.key});
  static const inputDecoration = InputDecoration(hintText: "Enter your email");
  static const placeHolder = TextField(decoration: inputDecoration);

  @override
  Widget build(BuildContext context) {
    return const Row(children: [Expanded(child: placeHolder)]);
  }
}

class InputPassword extends StatelessWidget {
  const InputPassword({super.key});
  static const decoration = InputDecoration(hintText: "Enter your password");
  static const textField = TextField(decoration: decoration);

  @override
  Widget build(BuildContext context) {
    return const Row(children: [Expanded(child: textField)]);
  }
}

class FormButton extends StatelessWidget {
  const FormButton({super.key});

  @override
  Widget build(BuildContext context) {
    const materialProperties = MaterialStatePropertyAll<Color>(Colors.blue);
    const style = ButtonStyle(backgroundColor: materialProperties);

    const onPressed = null;
    const text = Text("Register", style: TextStyle(color: Colors.white));

    return const TextButton(style: style, onPressed: onPressed, child: text);
  }
}
