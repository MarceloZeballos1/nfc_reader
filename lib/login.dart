import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http; // Use http for potential future usage
import 'package:nfc_reader/home.dart';
import 'package:nfc_reader/nfc.dart';
import 'variables.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  String userName = "";
  String password = "";
  dynamic _token;
  dynamic userList;
  List<dynamic>? _allUserData;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _passwordController.clear();
  }

  void navigateToHomeScreen(BuildContext context, String token) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen(token: token), // Pass token as argument
    ),
  );
}

  Future<void> _handleLogin() async {
    final _form = _formKey.currentState!; // Access FormState
    if (_form.validate()) {
      // Validate form before network call
      _form.save(); // Save form values after validation

      try {
        final Dio dio = Dio(); // Create a Dio instance

        final response = await dio.post(
          'https://clltzu4lo00aapmcgijm5df3y-keys-nfc.api.dev.404.codes/api/auth/login',
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
            navigateToHomeScreen(context, _token);
          }
        } else {
          if (response.statusCode == 401) {
            errorMessage = "Contraseña incorrectos";
          } else if (response.statusCode == 402) {
            errorMessage = "Usuario no encontrado";
          } else {
            errorMessage = "Error de conexión con el servidor";
          }
          print("Login error: ${response.statusCode}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
            ),
          );
        }
      } catch (error) {
        print("Unexpected error: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error de conexión con el servidor."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _fetchAndDisplayUsers() async {
    try {
      final Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $_token';

      final response = await dio.get(
          'https://clltzu4lo00aapmcgijm5df3y-keys-nfc.api.dev.404.codes/api/cards');

      if (response.statusCode == 200) {
        final List<dynamic> usersData = response.data as List<dynamic>;
        final List<String> users =
            usersData.map((users) => jsonEncode(users)).toList();

        // Update the UI to display the list of users
        setState(() {
          userList = users.join('\n'); // For debugging purposes
          _allUserData = users; // Store all user data as JSON strings
        });
      } else if (response.statusCode == 402) {
        errorMessage = "Usuario no encontrado";
      } else if (response.statusCode == 401) {
        errorMessage = "Contraseña incorrecta";
      } else {
        //
      }
    } catch (error) {
      // Handle network or other errors
    }
  }

  //////________________________________

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 2, 156, 177), // Allow background image to show through
      body: Stack(
        children: [
          /*Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('/assets/white.jpeg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),*/
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            const Text(
                              'UCB',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 33,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'CARDS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 33,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 35),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              controller: _userNameController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: 'Usuario',
                                hintStyle:
                                    const TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su usuario';
                                }
                                return null;
                              },
                              onChanged: (value) =>
                                  setState(() => userName = value),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              style: const TextStyle(),
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: 'Contraseña',
                                hintStyle:
                                    const TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su contraseña';
                                }
                                return null;
                              },
                              onChanged: (value) =>
                                  setState(() => password = value),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      const Color.fromARGB(255, 76, 76, 76),
                                  child: IconButton(
                                    color: Colors.white,
                                    onPressed: _handleLogin,
                                    icon: const Icon(Icons.arrow_forward),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
