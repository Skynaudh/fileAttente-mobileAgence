import 'package:ImpTicket/Screen/login.dart';
import 'package:ImpTicket/Screen/services.dart';
import 'package:ImpTicket/provider/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: Services()),
    ], 
          child: MaterialApp(
        title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.grey[800],
          primaryColor: Colors.cyan[900],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //home: Accueil(),
        home: Login(),
        routes: {
          MesServices.routeName: (context) => MesServices(),
        },
      ),
    );
  }
}