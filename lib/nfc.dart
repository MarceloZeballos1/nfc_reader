import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:nfc_reader/login.dart';

class NFCScreen extends StatefulWidget {
  @override
  _NFCScreenState createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String nfcData = 'Acerque la tarjeta para leer la información';
  int decimalId = 0;

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
        NFCTag? tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10));
        
        if (tag == null) {
          setState(() {
            nfcData = 'No se encontró ninguna tarjeta NFC';
          });
        }

        String hexId = tag.id;
        int decimalId = int.parse(hexId, radix: 16);

        setState(() {
          nfcData = 'La info de la maldita tarjeta es:\nDecimal: $decimalId \nHexadecimal: $hexId';
        });

        // Your logic after reading the tag (optional)
        // ...

      }
    } catch (e) {
      setState(() {
        nfcData = 'Error al leer la tarjeta NFC: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? _email = _auth.currentUser?.email;

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
            Text('Logeado con: $_email'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _auth.signOut();
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
              },
              child: Text("Cerrar Sesión"),
            ),
          ],
        ),
      ),
    );
  }
}
