import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:nfc_reader/nfc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userName = "";
  String password = "";
  dynamic _token;
  dynamic userListWidget; // For debugging purposes
  List<dynamic>? _allUserData;
  
  Future<void> _handleLogin() async {
    try {
      final Dio dio = Dio(); // Create a Dio instance

      final response = await dio.post(
        'http://172.22.35.78:3000/api/auth',
        data: {'userName': userName, 'password': password},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final token = data['token']['token'];
        setState(() {
          _token = token;
        });

        if (_token != null) {
        _fetchAndDisplayUsers();
        }
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NFCScreen()),
        );

      } else {
        // Handle login error gracefully
        print("Login error: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Credenciales incorrectas"),
          ),
        );
      }
    } catch (error) {
      // Handle unexpected errors
      print("Unexpected error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An unexpected error occurred."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
/////////////////////////////////////////////////////////////////////////

  Future<void> _fetchAndDisplayUsers() async {
    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $_token';

      final response = await dio.get('http://172.22.35.78:3000/api/cards');

      if (response.statusCode == 200) {
        final List<dynamic> usersData = response.data as List<dynamic>;
        final List<String> users = usersData.map((users) => jsonEncode(users)).toList();

        // Update the UI to display the list of users
        setState(() {
          userListWidget = users.join('\n'); // For debugging purposes
          _allUserData = users; // Store all user data as JSON strings
        });
      } else {
        // Handle error fetching users
      }
    } catch (error) {
      // Handle network or other errors
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesión"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Usuario",
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese su Usuario";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      userName = value;
                    });
                  },
                ),

                const SizedBox(height: 20),
                TextFormField(
                
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Contraseña",
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese su Contraseña";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),

                const SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text("Iniciar Sesión"),
                ),
                const SizedBox(height: 20),

                Text(
                  "El token es: $_token",
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 20),
                
                Text(
                  "Lista: $_allUserData",
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
