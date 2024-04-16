import 'package:client/screens/AtribuirNota.dart';
import 'package:client/screens/CadastrarAtividade.dart';
import 'package:client/screens/CadastrarUsuario.dart';
import 'package:client/screens/ListagemAtividades.dart';
import 'package:client/screens/ListagemUsuarios.dart';
import 'package:flutter/material.dart';

void main() {
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationBarApp();
  }
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blue.shade200,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(IconData(0xe491, fontFamily: 'MaterialIcons')),
            icon: Icon(IconData(0xe491, fontFamily: 'MaterialIcons')),
            label: 'Usuario',
          ),
          NavigationDestination(
            label: 'Lista Usuarios',
            icon: Icon(IconData(0xe491, fontFamily: 'MaterialIcons')),
          ),
          NavigationDestination(
            icon: Icon(IconData(0xe645, fontFamily: 'MaterialIcons')),
            label: 'Atividade',
          ),
          NavigationDestination(
            icon: Icon(IconData(0xe645, fontFamily: 'MaterialIcons')),
            label: 'Lista Atividades',
          ),
          NavigationDestination(
            selectedIcon: Icon(IconData(0xe491, fontFamily: 'MaterialIcons')),
            icon: Icon(IconData(0xe645, fontFamily: 'MaterialIcons')),
            label: 'Atribuir Nota',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        const CadastrarUsuario(),
        const ListagemUsuarios(),
        const CadastrarAtividade(),
        const ListagemAtividades(),
        const AtribuirNota(),

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),
      ][currentPageIndex],
    );
  }
}
