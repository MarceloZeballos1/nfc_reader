import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:nfc_reader/login.dart';
import 'variables.dart';

class RegistroScreen extends StatefulWidget {
  final String token;
  const RegistroScreen({Key? key, required this.token}) : super(key: key);

  @override
  _RegistroScreen createState() => _RegistroScreen();
}

class _RegistroScreen extends State<RegistroScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String nfcData = 'Acerque la tarjeta para leer la información';
  int decimalId = 0;
  dynamic _userData;
  String _nombre = '';
  dynamic _ci = 0;
  dynamic _fechaExpiracion = '';
  dynamic _email = '';
  dynamic _celular = 0;
  dynamic _tipo = '';
  dynamic _contador = 0;
  dynamic token;
  List<dynamic>? _allUserData;
  

  @override
  void initState() {
    super.initState();
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

        setState(() {
          nfcData = 'La info de la tarjeta es:\nDecimal: $decimalId';
          //nfcData = 'La info de la tarjeta es:\nDecimal: $decimalId \nHexadecimal: $hexId';
        });

        if (nfcData != null) {
          _usersData(decimalId);
        }

        // Your logic after reading the tag (optional)
        // ...
      }
    } catch (e) {
      setState(() {
        nfcData = 'La sesión expiró, vuelva a iniciar sesión por favor';
      });
    }
  }

  Future<void> _usersData(int decimalId) async {
    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${widget.token}';

      final response = await dio.post(
        'http://cardsapi.dev.dtt.tja.ucb.edu.bo/api/cards',
        data: {'cardId': decimalId},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final nombre = data['nombreCompleto'];
        final ci = data['ci'];
        final email = data['email'];
        final fechaExpiracion = data['fechaExpiracion'];
        final celular = data['celular'];
        final tipo = data['tipo'];
        final contador = data['contador'];
        final userData = data;
        setState(() {
          _userData = userData;
          _nombre = nombre;
          _ci = ci;
          _email = email;
          _fechaExpiracion = fechaExpiracion;
          _celular = celular;
          _tipo = tipo;
          _contador = contador;
        });
      }
    } catch (error) {
      print(error);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          color: Colors.white,
                          fontSize: 17,
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
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'CI: $_ci', // CI: $_ci
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$_email', //$_email
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Manillas Restantes: 0', // $_contador
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    /*    Text(
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
                          backgroundColor: const Color.fromARGB(255, 2, 156, 177),
                          // Adjust padding and text size as needed
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
