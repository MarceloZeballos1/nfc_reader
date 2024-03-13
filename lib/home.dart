import 'package:flutter/material.dart';
import 'package:nfc_reader/nfc.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

dynamic _token;

void navigateToNFCScreen(BuildContext context, String token) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => NFCScreen(token: token), // Pass token as argument
    ),
  );
}

void navigateToRegistroScreen(BuildContext context, String token) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => NFCScreen(token: token), // Pass token as argument
    ),
  );
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 156, 177),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'UCB',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'CARDS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to LECTURA TARJETA screen
                      Navigator.pushNamed(context, '/nfc');
                      navigateToNFCScreen(context, widget.token);
                    },
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: const Column(
                          children: [
                            Icon(
                              Icons.credit_card,
                              size: 50.0,
                              color: Colors.teal,
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'LECTURA TARJETA',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to REGISTRO TARJETAS screen
                      Navigator.pushNamed(context, '/register');
                      navigateToNFCScreen(context, widget.token);
                    },
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: const Column(
                          children: [
                            Icon(
                              Icons.add_card,
                              size: 50.0,
                              color: Colors.teal,
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'REGISTRO TARJETA',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Text('Token: ${widget.token}'),
            ],
          ),
        ),
      ),
    );
  }
}
