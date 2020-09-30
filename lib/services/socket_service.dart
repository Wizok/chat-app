import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

// Estatus del Servidor
enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  // Propiedad para revisar si el servidor está conectado o desconectado
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  // Opcional si quieres hacer algo mas corto para el "emit"
  Function get emit => this._socket.emit;

// Este metodo se llamara cuando se genere una instancia de la clase ServerStatus
  void connect() async {
    // Obtener el Token para verificarlo en el server
    final token = await AuthService.getToken();

    // Dart client
    // localhost se puede sustituir por la ip del equipo o servidor en caso de que no funcione
    this._socket = IO.io(
      Environment.socketUrl,
      {
        'transports': ['websocket'],
        'autoConnect': true,
        // Consume mas recursos del backend ya que cuando se desconecta y conecta crea una nueva instancia
        // cuando está en false intenta utilizar la misma conexión
        'forceNew': true,
        // Para poder mandar el Token al server necesitamos el "extraHeaders"
        'extraHeaders': {
          'x-token': token,
        }
      },
    );

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  // Metodo para desconectar del socket y servidor
  void disconnect() {
    this._socket.disconnect();
  }
}
