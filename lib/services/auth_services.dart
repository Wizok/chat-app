import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/usuarios.dart';

class AuthService with ChangeNotifier {
  Usuario usuario;

  // Propiedad para saber cuando estamos autenticando y deshabilitar el boton de Login
  bool _autenticando = false;

  // Utilizar el package flutter_secure_storage para guardar el token
  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    // Notificar para redibujar el widget
    notifyListeners();
  }

  // Getters del token de forma estáticapara poder mandar llamarlos de dónde queramos
  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    // Se habilita el bool para indicar que se está autenticando el usuario
    this.autenticando = true;

    final data = {
      'email': email,
      'password': password,
    };

    final resp = await http.post(
      '${Environment.apiUrl}/login',
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    print(resp.body);
    this.autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      // Se manda guardar el Token
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    this.autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
    };

    final resp = await http.post(
      '${Environment.apiUrl}/login/new',
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    print(resp.body);
    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      // Se manda guardar el Token
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  // Validación de Token al abrir la App y revisar si ya se había logueado
  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');

    final resp = await http.get(
      '${Environment.apiUrl}/login/renew',
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    print(resp.body);

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      // Se manda guardar el Token
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      // En caso de que el token no sea valido se debe borrar y que el usuario intente el login de nuevo
      this.logout();
      return false;
    }
  }

  // Metodo para guardar el Token
  Future _guardarToken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  // Metodo para borrar el token al hacer logout
  Future logout() async {
    // Delete value
    await _storage.delete(key: 'token');
  }
}
