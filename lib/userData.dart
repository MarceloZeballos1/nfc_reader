import 'package:flutter/material.dart';

class UserData extends StatefulWidget {
  @override
  _UserData createState() => _UserData();
}

class _UserData extends State<UserData> {
  
  
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Usuario'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Estudiante: '),
            Card(),
            SizedBox(height: 10),
            Text('CI: '),
            SizedBox(height: 10),
            Text('Celular: '),
            SizedBox(height: 10),
            Text('Correo: '),
            SizedBox(height: 10),
            Text('Inscrito: '),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

}