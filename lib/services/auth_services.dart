import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/usuarios.dart';

class AuthService with ChangeNotifier {
  Usuario usuario;

  // Propiedad para saber cuando estamos autenticando y deshabilitar el boton de Login
  bool _autenticando = false;

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    // Notificar para redibujar el widget
    notifyListeners();
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
      return true;
    } else {
      return false;
    }
  }
}
