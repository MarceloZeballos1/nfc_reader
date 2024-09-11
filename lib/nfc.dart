import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:nfc_reader/login.dart';
import 'variables.dart';

class NFCScreen extends StatefulWidget {
  final String token;
  final int idUser;

  const NFCScreen({Key? key, required this.token, required this.idUser})
      : super(key: key);

  @override
  _NFCScreenState createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String nfcData = 'Acerque la tarjeta para leer la información';
  int decimalId = 0;
  dynamic idUser;
  int idParty = 1;
  dynamic contador = 0;
  //Primer request
  dynamic _userData;
  String _nombre = '';
  dynamic _ci = 0;
  dynamic _fechaExpiracion = '';
  dynamic _email = '';
  dynamic _celular = 0;
  dynamic _tipo = '';
  //Segundo request
  dynamic _idUser = 0;
  dynamic _idParty = 0;
  dynamic _available = 0;
  dynamic _createdAt = '';
  dynamic _updatedAt = '';
  //BOTON request manilla
  dynamic _status;
  String _comprobacion = '';

  dynamic _error = '';
  dynamic token;
  List<dynamic>? _allUserData;

  @override
  void initState() {
    super.initState();
    _counter(widget.idUser);
    _readNFCData();
  }

  Future<void> _readNFCData() async {
    try {
      // Check NFC availability first

      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        setState(() {
          nfcData = 'Dispositivo no compatible con NFC';
        });
        return;
      }

      // Continuously poll for NFC tags
      while (mounted) {
        NFCTag? tag =
            await FlutterNfcKit.poll(timeout: const Duration(hours: 168));

        if (tag == null) {
          setState(() {
            nfcData = 'No se encontró ninguna tarjeta NFC';
          });
        }

        String hexId = tag.id;
        int decimalId = int.parse(hexId, radix: 16);

        /*setState(() {
          nfcData = 'La info de la tarjeta es:\nID: $decimalId';
          //nfcData = 'La info de la tarjeta es:\nDecimal: $decimalId \nHexadecimal: $hexId';
        });
        */

        if (nfcData != null) {
          _usersData(decimalId);
          
        }

        // Your logic after reading the tag (optional)
        // ...
      }
    } catch (e) {
      setState(() {
        nfcData = 'La sesión expiró, inicie sesión nuevamente';
      });
    }
  }

  Future<void> _counter(idUser) async {
    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${widget.token}';

      final response = await dio.get(
        'http://cardsapi.dev.dtt.tja.ucb.edu.bo/${widget.idUser}',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final idUser = data['idUser'];
        final idParty = data['idParty'];
        final available = data['available'];
        final createdAt = data['createdAt'];
        final updateAt = data['updateAt'];
        setState(() {
          _idUser = idUser;
          _idParty = idParty;
          _available = available;
          _createdAt = createdAt;
          _updatedAt = updateAt;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          nfcData = 'Usuario no encontrado';
        });
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> data = response.data;
        final error = data['error'];
        setState(() {
          _error = error;
          nfcData = _error;
        });
      } else if (response.statusCode == 500) {
        final Map<String, dynamic> data = response.data;
        final error = data['error'];
        setState(() {
          _error = error;
          nfcData = _error;
        });
      }

      print(response.data);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _usersData(int decimalId) async {
    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${widget.token}';

      final response = await dio.post(
        'http://cardsapi.dev.dtt.tja.ucb.edu.bo/api/cards',
        data: {
          'cardId': decimalId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final nombre = data['nombreCompleto'];
        final ci = data['ci'];
        final email = data['email'];
        final fechaExpiracion = data['fechaExpiracion'];
        final celular = data['celular'];
        final tipo = data['tipo'];
        final userData = data;
        setState(() {
          _userData = userData;
          _nombre = nombre;
          _ci = ci;
          _email = email;
          _fechaExpiracion = fechaExpiracion;
          _celular = celular;
          _tipo = tipo;
        });
        print('1primero $_ci*********************');
      } else if (response.statusCode == 500) {
        final Map<String, dynamic> data = response.data;
        final error = data['error'];
        setState(() {
          _error = error;
          nfcData = _error;
        });
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> data = response.data;
        final error = data['error'];
        setState(() {
          _error = error;
          nfcData = _error;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _userRegister(
      dynamic idPersona, dynamic nombre, int idUser, int idParty) async {
    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${widget.token}';
      print(_nombre);
      final response = await dio.post(
        'http://cardsapi.dev.dtt.tja.ucb.edu.bo/api/cards/add',
        data: {
          'idPersona': _ci, // Usamos la información de _userData
          'nombre': _nombre,
          'idUser': widget.idUser,
          'idParty': idParty
        },
      );

      await _usersData(decimalId);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final int status = data['status'];

        print('widget.idUser: ${widget.idUser}');
        print('_ci: $_ci');
        print('_nombre: $_nombre');
        print('idParty: $idParty');
        
        if (status == 0) {
          _comprobacion = 'Se registró correctamente al estudiante';
        } else if (status == 1) {
          _comprobacion = 'El estudiante ya cuenta con una manilla';
        }

        setState(() {
          _status = status;
          _available = _available;
        });
      } else {
        // Maneja la recuperación fallida de datos del usuario (por ejemplo, muestra un mensaje de error)
        print('Error al recuperar datos del usuario');
      }
    } catch (_status) {
      print('ERORRRRRRRRRRRRRRRRRRRRRRRRR $_status');
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
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: Text(
                        'Manillas Catolicazo', //Grupo: $_tipo
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Center(
                      child: Image.asset(
                        "assets/iconCard.png",
                        height: 90,
                      ),
                    ),
                    /*
                    const Text(
                      'UCB \nCARDS',
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 156, 177),
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    */
                    const SizedBox(height: 35),
                    Text(
                      '$_nombre', // $_nombre
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'CI: $_ci', // CI: $_ci
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$_tipo', //Grupo: $_tipo
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      nfcData, //Mostrar error o estado
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () async {
                              await _userRegister(
                                  _ci, _nombre, widget.idUser, idParty);
                              _counter(widget.idUser);
                              setState(() {
                                
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 2, 156, 177),
                            ),
                            child: const Text(
                              'Registrar Entrega',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
                          backgroundColor: Color.fromARGB(255, 2, 156, 177),
                          // Adjust padding and text size as needed
                        ),
                        child: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      
                    ),
                    const SizedBox(height: 10),
                      Text(
                        'Manillas Disponibles: $_available', //Contador
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                    Text(
                      _comprobacion, //Mostrar error o estado
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    /*const SizedBox(height: 10),
                        Text(
                          '65250236', //$_celular
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Grupo: Estudiante', //$_tipo
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Fecha de Expiración: $_fechaExpiracion', // Replace with your variable
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        */
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
