import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastrarUsuario extends StatefulWidget {
  const CadastrarUsuario({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<CadastrarUsuario> {
  final _formKey = GlobalKey<FormState>();
  String _responseMessage = '';
  bool _isSuccess = false;

  void startHammering(String nome, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/usuarios'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'nome': nome,
            'email': email,
            'senha': password,
          },
        ),
      );
      // print(usuarios);
      final responseData = jsonDecode(response.body);
      final status = responseData["status"];
      print(status);
      setState(() {
        _responseMessage = responseData['message'];
        _isSuccess = status == 200;
      });
    } catch (err) {
      print(err);
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Card(
              color: Colors.white,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _isSuccess
                        ? const Icon(Icons.check,
                            color: Colors.green) // Green check icon
                        : const Icon(Icons.clear,
                            color: Colors.red), // Green check icon
                    const SizedBox(width: 8),
                    Text(_responseMessage),
                  ],
                ),
              ),
            )),
      );
    }
    return null;
    // return usuarios;
  }

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nomeCtrl = TextEditingController();

  String? confirmValue(String? value) {
    bool validated = value == null || value.isEmpty;
    if (validated) return "PLease enter some text";
    return null;
  }

  void submitForm(GlobalKey<FormState> formkey) {
    if (_formKey.currentState!.validate()) {
      startHammering(nomeCtrl.text, emailCtrl.text, passwordCtrl.text);
      nomeCtrl.text = '';
      emailCtrl.text = '';
      passwordCtrl.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        // paddi
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nomeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => confirmValue(value),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => confirmValue(value),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                controller: passwordCtrl,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => submitForm(_formKey),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4.0), // Borda arredondada
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(
                          double.infinity, 58), // Tamanho mínimo do botão
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue, // Cor de fundo do botão
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white, // Cor do texto do botão
                    )),
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
