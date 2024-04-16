import 'dart:convert';

import 'package:client/types/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListagemUsuarios extends StatefulWidget {
  const ListagemUsuarios({super.key});

  @override
  _ListagemUsuariosState createState() => _ListagemUsuariosState();
}

class _ListagemUsuariosState extends State<ListagemUsuarios> {
  late Future<List<Usuario>> _userListFuture;
  String _responseMessage = '';
  bool _success = false;

  @override
  void initState() {
    super.initState();
    _userListFuture = _fetchUserList();
  }

  Future<List<Usuario>> _fetchUserList() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/usuarios'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        List<Usuario> userList =
            data.map((item) => Usuario.fromJson(item)).toList();
        setState(() {
          _responseMessage = jsonData['message'];
          _success = true;
        });
        return userList;
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
            duration: const Duration(milliseconds: 1500)),
      );
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Usuários'),
        ),
        body: FutureBuilder<List<Usuario>>(
          future: _userListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Usuario> userList = snapshot.data!;
              return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = userList[index];
                  return Card(
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.white, // Cor de fundo mais clara
                    child: ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.person, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              user.nome,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ]),
                          const SizedBox(height: 10),
                          Row(children: [
                            const Icon(Icons.email, size: 20),
                            const SizedBox(width: 10),
                            Text(user.email)
                          ])
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
