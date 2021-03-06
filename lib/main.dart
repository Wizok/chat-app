import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/chat_service.dart';

import 'package:chat_app/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Provider - Esto provoca que todas nuestras rutas tengan en su context los Providers
    return MultiProvider(
      // Lista de Providers
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              AuthService(), // Instancia Global - Notifica cuando quiere redibujar
        ),
        ChangeNotifierProvider(
          create: (_) =>
              SocketService(), // Instancia Global - Notifica cuando quiere redibujar
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ChatService(), // Instancia Global - Notifica cuando quiere redibujar
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
