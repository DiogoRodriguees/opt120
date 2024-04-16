import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CadastrarAtividade extends StatefulWidget {
  const CadastrarAtividade({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<CadastrarAtividade> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _userData = [];
  final List<Map<String, dynamic>> _atividadeData = [];
  String _responseMessage = '';

  DateTime _selectedDate = DateTime.now();
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void startHammering(String titulo, String description, DateTime date) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/atividades'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'titulo': titulo,
            'descricao': description,
            'data': date.toIso8601String(),
          },
        ),
      );
      final responseData = jsonDecode(response.body);
      setState(() {
        _responseMessage = responseData['message'];
        _selectedDate = DateTime.now();
      });
      titleCtrl.text = '';
      descriptionCtrl.text = '';
      dateCtrl.text = '';
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
                    const Icon(Icons.check,
                        color: Colors.green), // Green check icon
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

  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final dateCtrl = TextEditingController();

  String? confirmValue(String? value) {
    bool validated = value == null || value.isEmpty;
    if (validated) return "PLease enter some text";
    return null;
  }

  void submitForm(GlobalKey<FormState> formkey) {
    if (_formKey.currentState!.validate()) {
      startHammering(titleCtrl.text, descriptionCtrl.text, _selectedDate);
    }
  }

  static const IconData calendar =
      IconData(0xe122, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Atividade'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        // padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Insira um Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => confirmValue(value),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: descriptionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Insira uma descrição',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => confirmValue(value),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Selecione uma Data',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => submitForm(_formKey),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Borda arredondada
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
