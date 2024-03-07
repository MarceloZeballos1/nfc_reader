import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreen();
}

class _SingUpScreen extends State<SingUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  String _email = "";
  String _password = "";
  void _handleSingUp() async{
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print("Usuario Registrado: ${userCredential.user!.email}");
    } catch(e){
      print("Error durante el Registro $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),

      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Correo"
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Ingrese su Correo";
                    }
                    return null;
                  },
                  onChanged: (value){
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Contraseña"
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Ingrese su Contraseña";
                    }
                    return null;
                  },
                  onChanged: (value){
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      _handleSingUp();                      
                    }
                  },
                  child: Text("Registrarse"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}