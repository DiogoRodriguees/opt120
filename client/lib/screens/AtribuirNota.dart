import 'dart:convert';

import 'package:client/types/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Atividade {
  final int id;
  final String titulo;
  final String descricao;

  Atividade({
    required this.id,
    this.titulo = "",
    this.descricao = "",
  });

  factory Atividade.fromJson(Map<String, dynamic> json) {
    return Atividade(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
    );
  }
}

class AtribuirNota extends StatefulWidget {
  const AtribuirNota({super.key});

  @override
  _AtribuirNotaState createState() => _AtribuirNotaState();
}

class _AtribuirNotaState extends State<AtribuirNota> {
  final _formKey = GlobalKey<FormState>();
  List<String> _titulos = [];
  List<String> _nomes = [];
  List<Atividade> _atividades = [];
  List<Usuario> _usuarios = [];
  String _selectedTituloId = 'Selecione'; // Armazena o ID do título selecionado
  String _selectedNomeId = 'Selecione'; // Armazena o ID do nome selecionado
  DateTime _selectedDate = DateTime.now(); // Armazena a data selecionada
  String _responseMessage = '';
  bool _success = false;
  int _nota = 0; // Armazena a nota

  Future<void> _fetchData() async {
    final urlAtividades = Uri.parse('http://localhost:3000/atividades');
    final urlUsuarios = Uri.parse('http://localhost:3000/usuarios');

    final responseAtividades = await http.get(urlAtividades);
    final responseUsuarios = await http.get(urlUsuarios);

    if (responseAtividades.statusCode == 200 &&
        responseUsuarios.statusCode == 200) {
      final jsonDataAtividades = jsonDecode(responseAtividades.body);
      final jsonDataUsuarios = jsonDecode(responseUsuarios.body);

      final List<dynamic> dataAtividades = jsonDataAtividades['data'];
      final List<dynamic> dataUsuarios = jsonDataUsuarios['data'];

      List<Usuario> usuarios = dataUsuarios
          .map<Usuario>((item) => Usuario(id: item['id'], nome: item['nome']))
          .toList();
      List<Atividade> atividades = dataAtividades
          .map<Atividade>(
              (item) => Atividade(id: item['id'], titulo: item['titulo']))
          .toList();

      final List<String> titulos =
          dataAtividades.map<String>((item) => item['titulo']).toList();
      final List<String> nomes =
          dataUsuarios.map<String>((item) => item['nome']).toList();

      setState(() {
        _atividades = atividades;
        _usuarios = usuarios;
        _titulos = ['Selecione', ...titulos];
        if (!_titulos.contains(_selectedTituloId)) {
          // Check if initial value exists
          _selectedTituloId = 'Selecione'; // Set initial value to 'Selecione'
        }
        _nomes = ['Selecione', ...nomes];
        if (!_nomes.contains(_selectedNomeId)) {
          // Check if initial value exists
          _selectedNomeId = 'Selecione'; // Set initial value to 'Selecione'
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _onTituloChanged(String? newValue) {
    setState(() {
      _selectedTituloId = newValue ?? '';
    });
  }

  void _onNomeChanged(String? newValue) {
    setState(() {
      _selectedNomeId = newValue ?? '';
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Atividade? atividadeEncontrada = _atividades.firstWhere(
        (atividade) => atividade.titulo == _selectedTituloId,
      );
      Usuario? usuarioEncontrado = _usuarios.firstWhere(
        (usuario) => usuario.nome == _selectedNomeId,
      );

      // Example of sending data to backend (replace with actual implementation)
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/avaliacao'),
          body: jsonEncode({
            'atividade_id': atividadeEncontrada.id,
            'usuario_id': usuarioEncontrado.id,
            'data': _selectedDate.toIso8601String(),
            'nota': _nota
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          setState(() {
            _success = true;
          });
        }
        final responseData = jsonDecode(response.body);
        setState(() {
          _responseMessage = responseData['message'];
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
                    _success
                        ? const Icon(Icons.check,
                            color: Colors.green) // Green check icon
                        : const Icon(Icons.clear,
                            color: Colors.red), // Green check icon
                    const SizedBox(width: 8),
                    Text(_responseMessage),
                  ],
                ),
              ),
            ),
          ),
        );

        setState(() {
          _success = false;
          _selectedTituloId = 'Selecione';
          _selectedNomeId = 'Selecione';
          _nota = 0;
          _selectedDate = DateTime.now();
        });
      }
    }
  }

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

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atribuir Nota'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Selecione um Título',
                  border: OutlineInputBorder(),
                ),
                value: _selectedTituloId,
                onChanged: _onTituloChanged,
                items: _titulos.map<DropdownMenuItem<String>>((String titulo) {
                  return DropdownMenuItem<String>(
                    value: titulo,
                    child: Text(titulo),
                  );
                }).toList(),
                validator: (value) {
                  if (value == 'Selecione') {
                    return 'Por favor, selecione um Título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Selecione um Nome',
                  border: OutlineInputBorder(),
                ),
                value: _selectedNomeId,
                onChanged: _onNomeChanged,
                items: _nomes.map<DropdownMenuItem<String>>((String nome) {
                  return DropdownMenuItem<String>(
                    value: nome,
                    child: Text(nome),
                  );
                }).toList(),
                validator: (value) {
                  if (value == 'Selecione') {
                    return 'Por favor, selecione um Nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nota',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number, // Teclado numérico
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma nota';
                  }
                  final nota = int.tryParse(value);
                  if (nota == null || nota < 0 || nota > 10) {
                    return 'Por favor, insira uma nota válida entre 0 e 10';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _nota = int.parse(value!);
                  });
                },
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
                onPressed: _submitForm,
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
                child: const Text('Atribuir Nota'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
