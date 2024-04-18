import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../types/Usuario.dart';

class ListagemUsuarios extends StatefulWidget {
  const ListagemUsuarios({super.key});

  @override
  _ListagemUsuariosState createState() => _ListagemUsuariosState();
}

class _ListagemUsuariosState extends State<ListagemUsuarios> {
  late Future<List<Usuario>> _userListFuture;
  String _responseMessage = '';
  String _responseMessageDelete = '';
  bool _success = false;
  bool _sucessOnDelete = false;

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

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

  Future<void> _deleteUser(int userId) async {
    try {
      final response = await http
          .delete(Uri.parse('http://localhost:3000/usuarios/$userId'));

      final jsonData = jsonDecode(response.body);

      setState(() {
        _sucessOnDelete = response.statusCode == 200;
        _responseMessageDelete = jsonData["message"];
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
                  _sucessOnDelete
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.clear, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(_responseMessageDelete),
                ],
              ),
            ),
          ),
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
    setState(() {
      _userListFuture = _fetchUserList();
    });
  }

  Future<void> _editUser(Usuario user) async {
    _nomeController.text = user.nome;
    _emailController.text = user.email;
    _senhaController.text = user.senha;
    bool isUpdateSuccess = false;
    String responseMessageUpdate = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Usuário'),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
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
                final editedUser = Usuario(
                  id: user.id,
                  nome: _nomeController.text,
                  email: _emailController.text,
                  senha: _senhaController.text,
                );
                try {
                  // Send PATCH request to update user
                  final response = await http.put(
                    Uri.parse('http://localhost:3000/usuarios'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'id': editedUser.id,
                      'nome': editedUser.nome,
                      'email': editedUser.email,
                      'senha': editedUser.senha,
                    }),
                  );
                  final responseData = jsonDecode(response.body);
                  if (response.statusCode == 200) {
                    setState(() {
                      _userListFuture = _fetchUserList();
                      isUpdateSuccess = true;
                      responseMessageUpdate = responseData["message"];
                    });
                  } else {
                    setState(() {
                      _userListFuture = _fetchUserList();
                      responseMessageUpdate = responseData["message"];
                      isUpdateSuccess = false;
                    });
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
                              isUpdateSuccess
                                  ? const Icon(Icons.check,
                                      color: Colors.green) // Green check icon
                                  : const Icon(Icons.clear,
                                      color: Colors.red), // Green check icon
                              const SizedBox(width: 8),
                              Text(responseMessageUpdate),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                  _userListFuture = _fetchUserList();
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
                  color: Colors.white,
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              user.nome,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editUser(user);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmar exclusão'),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    content: Text(
                                        'Tem certeza de que deseja excluir ${user.nome}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _deleteUser(user.id);
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 20),
                            const SizedBox(width: 10),
                            Text(user.email),
                          ],
                        ),
                        const SizedBox(height: 10),
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
