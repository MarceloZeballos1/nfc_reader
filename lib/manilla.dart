import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_reader/login.dart';

class ManillaScreen extends StatefulWidget {
  final String token;
  const ManillaScreen({Key? key, required this.token}) : super(key: key);

  @override
  _ManillaScreen createState() => _ManillaScreen();
}

class _ManillaScreen extends State<ManillaScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _ciController = TextEditingController();

  String _nombre = '';
  String _ci = '';
  String _email = '';
  int _contador = 0;
  String _mensajeError = '';
  bool _userFound = false;

  Future<void> _buscarUsuario(String ci) async {
    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${widget.token}';

      final response = await dio.post(
        'http://cardsapi.dev.dtt.tja.ucb.edu.bo/api/cards',
        data: {'cardId': ci},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        setState(() {
          _nombre = data['nombreCompleto'];
          _ci = data['ci'].toString();
          _email = data['email'];
          _contador = data['contador'];
          _userFound = true;
          _mensajeError = '';
        });
      } else {
        setState(() {
          _mensajeError = 'Usuario no encontrado';
          _userFound = false;
        });
      }
    } catch (error) {
      setState(() {
        _mensajeError = 'Error al buscar el usuario: $error';
        _userFound = false;
      });
    }
  }

  Future<void> _entregarManilla() async {
    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${widget.token}';

      final response = await dio.post(
        'http://cardsapi.dev.dtt.tja.ucb.edu.bo/api/estudiante/registrar',
        data: {
          'idPersona': _ci,
          'fullname': _nombre,
          'idUser': '1', // Puedes cambiar esto si es dinámico
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final int status = data['status'];

        if (status == 0) {
          setState(() {
            _mensajeError = 'Manilla entregada correctamente';
          });
        } else {
          setState(() {
            _mensajeError = 'El estudiante ya tiene una manilla';
          });
        }
      }
    } catch (error) {
      setState(() {
        _mensajeError = 'Error al entregar la manilla: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 156, 177),
      body: Stack(
        children: [
          Center(
            child: Card(
              margin: const EdgeInsets.all(30),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'UCB \nCARDS',
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 156, 177),
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 35),
                    TextFormField(
                      controller: _ciController,
                      decoration: const InputDecoration(
                        hintText: 'Introduce tu CI',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          await _buscarUsuario(_ciController.text);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 2, 156, 177),
                        ),
                        child: const Text(
                          'Buscar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    if (_mensajeError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          _mensajeError,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    if (_userFound) ...[
                      const SizedBox(height: 35),
                      Text(
                        'Nombre: $_nombre',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'CI: $_ci',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email: $_email',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Manillas Restantes: $_contador',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            await _entregarManilla();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 2, 156, 177),
                          ),
                          child: const Text(
                            'Entregar Manilla',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          _auth.signOut();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 2, 156, 177),
                        ),
                        child: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

