import 'dart:convert';
import 'package:dio/dio.dart';

class UserService {
  static const _baseUrl = 'https://172.22.5.2/api/'; // Define la URL base
  final Dio _dio = Dio(); // Crea una instancia de Dio
  dynamic _token; // Almacena el token

  // Constructor para establecer el token de autenticación
  UserService(this._token);

  // Función para obtener los datos del usuario
  Future<dynamic> getUsers() async {
    try {
      _dio.options.baseUrl = _baseUrl;
      _dio.interceptors.clear();
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['Authorization'] = 'Bearer $_token';
            return handler.next(options);
          },
        ),
      );

      final response = await _dio.get('users');

      if (response.statusCode == 200) {
        return jsonDecode(response.data); // Decodifica la respuesta JSON
      } else {
        throw Exception('Error al obtener datos: ${response.statusCode}');
      }
    } on DioError catch (dioError) {
      // Maneja errores específicos de Dio
      throw Exception(dioError.message);
    } catch (error) {
      // Maneja otros errores
      throw Exception(error.toString());
    }
  }
}

