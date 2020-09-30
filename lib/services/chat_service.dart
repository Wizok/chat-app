import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/models/usuarios.dart';
import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/global/environment.dart';

class ChatService with ChangeNotifier {
// Para quien van los mensajes
  Usuario usuarioPara;

// Petición de mensajes
  Future<List<Mensaje>> getChat(String usuarioID) async {
    final resp = await http.get('${Environment.apiUrl}/mensajes/$usuarioID',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });

    final mensajesResp = mensajesResponseFromJson(resp.body);
    return mensajesResp.mensajes;
  }
}
