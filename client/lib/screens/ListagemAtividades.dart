import 'dart:convert';

import 'package:client/screens/AtribuirNota.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListagemAtividades extends StatefulWidget {
  const ListagemAtividades({super.key});

  @override
  _ListagemAtividadesState createState() => _ListagemAtividadesState();
}

class _ListagemAtividadesState extends State<ListagemAtividades> {
  late Future<List<Atividade>> _activityListFuture;
  String _responseMessage = '';
  String _responseMessageDelete = '';
  String _responseMessageUpdate = '';
  bool _success = false;
  bool sucessOnDelete = false;
  bool sucessOnUpdate = false;

  @override
  void initState() {
    super.initState();
    _activityListFuture = _fetchActivityList();
  }

  Future<List<Atividade>> _fetchActivityList() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/atividades'));

      _success = response.statusCode == 200;
      final jsonData = jsonDecode(response.body);
      setState(() {
        _responseMessage = jsonData['message'];
      });

      if (_success) {
        final List<dynamic> data = jsonData['data'];
        List<Atividade> activityList =
            data.map((item) => Atividade.fromJson(item)).toList();
        return activityList;
      }
    } catch (err) {
      print(err);
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Card(
            color: Colors.white,
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _success
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.clear, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(_responseMessage),
                ],
              ),
            ),
          ),
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
    return [];
  }

  Future<void> _editActivity(Atividade activity) async {
    TextEditingController tituloController = TextEditingController();
    TextEditingController descricaoController = TextEditingController();

    tituloController.text = activity.titulo;
    descricaoController.text = activity.descricao;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Atividade'),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final editedActivity = Atividade(
                  id: activity.id,
                  titulo: tituloController.text,
                  descricao: descricaoController.text,
                );

                // Send PATCH request to update activity
                try {
                  final response = await http.put(
                    Uri.parse(
                        'http://localhost:3000/atividades/${editedActivity.id}'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'titulo': editedActivity.titulo,
                      'descricao': editedActivity.descricao,
                    }),
                  );

                  final responseData = jsonDecode(response.body);

                  setState(() {
                    _responseMessageUpdate = responseData["message"];
                    sucessOnUpdate = response.statusCode == 200;
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
                              sucessOnUpdate
                                  ? const Icon(Icons.check,
                                      color: Colors.green) // Green check icon
                                  : const Icon(Icons.clear,
                                      color: Colors.red), // Green check icon
                              const SizedBox(width: 8),
                              Text(_responseMessageUpdate),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                  setState(() {
                    _activityListFuture = _fetchActivityList();
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteActivity(int activityId) async {
    try {
      final response = await http
          .delete(Uri.parse('http://localhost:3000/atividades/$activityId'));

      final responseData = jsonDecode(response.body);
      _responseMessageDelete = responseData["message"];

      setState(() {
        sucessOnDelete = response.statusCode == 200;
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
                  sucessOnDelete
                      ? const Icon(Icons.check,
                          color: Colors.green) // Green check icon
                      : const Icon(Icons.clear,
                          color: Colors.red), // Green check icon
                  const SizedBox(width: 8),
                  Text(_responseMessageDelete),
                ],
              ),
            ),
          ),
        ),
      );
      setState(() {
        _activityListFuture = _fetchActivityList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Atividades'),
      ),
      body: FutureBuilder<List<Atividade>>(
        future: _activityListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Atividade> activityList = snapshot.data!;
            return ListView.builder(
              itemCount: activityList.length,
              itemBuilder: (BuildContext context, int index) {
                final activity = activityList[index];
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.grey[200],
                  child: ListTile(
                    title: Text(
                      activity.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(activity.descricao),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editActivity(activity);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: Text(
                                    'Tem certeza de que deseja excluir ${activity.titulo}?'),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _deleteActivity(activity.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Excluir'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
