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
  bool _success = false;
  @override
  void initState() {
    super.initState();
    _activityListFuture = _fetchActivityList();
  }

  Future<List<Atividade>> _fetchActivityList() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/atividades'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        List<Atividade> activityList =
            data.map((item) => Atividade.fromJson(item)).toList();
        setState(() {
          _responseMessage = jsonData['message'];
          _success = true;
        });
        return activityList;
      } else {
        throw Exception('Failed to load activity list');
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
            duration: const Duration(milliseconds: 1500)),
      );
    }
    return [];
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
                  color: Colors.grey[200], // Cor de fundo mais clara
                  child: ListTile(
                    title: Text(
                      activity.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(activity.descricao),
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
