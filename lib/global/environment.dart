// Clase con metodos estaticos para poder acceder la clase sin instanciarla

import 'dart:io';

class Environment {
  // Servicios rest
  static final String apiUrl = Platform.isAndroid
      ? 'http://192.168.0.4:3000/api'
      : 'http://localhost:3000/api';

  // Sockets
  static final String socketUrl =
      Platform.isAndroid ? 'http://192.168.0.4:3000' : 'http://localhost:3000';
}
