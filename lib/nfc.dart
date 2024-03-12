import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:nfc_reader/login.dart';
import 'package:nfc_reader/userData.dart';
import 'variables.dart';


class NFCScreen extends StatefulWidget {
  final String token;
  const NFCScreen({Key? key, required this.token}) : super(key: key);

  @override
  _NFCScreenState createState() => _NFCScreenState();

}

class _NFCScreenState extends State<NFCScreen> {
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
          nfcData = 'NFC no disponible';
        });
        return;
      }
   
      // Continuously poll for NFC tags
      while (mounted) {
        NFCTag? tag = await FlutterNfcKit.poll(timeout: Duration(hours: 168));
        
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

      final response = await dio.post('https://clltzu4lo00aapmcgijm5df3y-keys-nfc.api.dev.404.codes/api/cards',
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
      }
    } catch (error) {
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lector NFC'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Acerque la tarjeta para leer la información'),
            SizedBox(height: 20),
            Text(nfcData),
            SizedBox(height: 20),
            /*ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => UserData(),
                ));
              },
              child: Text("Pantalla Usuarios"),
            ),*/
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                _auth.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
                
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
              },
              child: Text("Cerrar Sesión"),
            ),
            SizedBox(height: 20),
            Text(_nombre),
            SizedBox(height: 20),
            Text('CI: $_ci'),
            SizedBox(height: 20),
            Text('Correo: $_email'),
            SizedBox(height: 20),
            Text('Celular: $_celular'),
            SizedBox(height: 20),
            Text('Fecha de Expiración: $_fechaExpiracion'),
            SizedBox(height: 20),
            Text('Grupo: $_tipo'),
          ],
        ),
      ),
    ); 
  }
}
