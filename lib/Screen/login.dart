import 'dart:convert';
import 'dart:developer';

import 'package:ImpTicket/Screen/services.dart';
import 'package:ImpTicket/api.dart';
import 'package:ImpTicket/provider/informations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ImpTicket/Screen/alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isInit = true;
  bool _isLoad = false;
  bool isAuth = false;
  String login='';

  String password='';

  Map<String, dynamic> mesInfos;

  final _keyForm = GlobalKey<FormState>();
  
  
void _login(BuildContext context,String login, String password) async {
    const url = Api.login;
    Map data = {'name': login, 'password': password};
    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
    var response = await http.post(url, body: data);
    print("response");
    print(response);
    if(response.statusCode == 201) {
      jsonData = json.decode(response.body);
        sharedPreferences.setString("token", jsonData['data']['token']);
      final listdata =  jsonData['data']['information'] as Map;

      mesInfos = {'id': listdata['id'], 'name': listdata['name'], 'email': listdata['email'], 'number': listdata['number'],
          'agence': listdata['agence'], 'institution': listdata['institution'], 'agentId': listdata['agentId']};
      //print(mesInfos['institution']);
      sharedPreferences.setString("agence", listdata['agence']);
      Navigator.of(context).pushNamed(MesServices.routeName, arguments: 
        {'agence' : mesInfos['agence'], 'institution' : mesInfos['institution'], 'number': mesInfos['number']});
    }
    else {
      print(response.body);
      errorMessage(context).show();
    }
  }

Widget _dialogBuilder(BuildContext context){
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Text('Vous êtes non authentifiée'),
              ),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  children: <Widget>[
                    FlatButton(onPressed: (){
                      print('OKi');
                      Navigator.of(context).pop();
                    },
                     child: Text('OK'),
                     ),
                  ],),
              ),
            ],
          ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
        child: Form(
          key: _keyForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset('assets/leLogo.jpg', height: 200.0, width: 200.0),
                        ),
                  ),
                 SizedBox(height: 10.0),
                TextFormField(
                  //initialValue: 'believe',
                  decoration: InputDecoration(
                    labelText: 'Identifiant',
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    ),
                  ),
                  validator: (val) => val.isEmpty ? 'Entrez un identifiant' : null,
                  onChanged: (val) => login = val,
                ),
                 SizedBox(height: 10.0),
                TextFormField(
                  //initialValue: 'believe',
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),)
                  ),
                  obscureText: true,
                  validator: (val) => val.length < 0 ? 'Mot de passe incorrect' : null,
                  onChanged: (val) => password = val,
                ),
                SizedBox(height: 10.0),
                FlatButton(
                  onPressed: () async{
                    if(_keyForm.currentState.validate()){
                      //_login(context, 'believe', 'believe');
                      _login(context, login, password);
                    }
                  },
                  color: Colors.lightGreen,
                  child: Text('Se connecter', style: TextStyle(color: Colors.white),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
              ],

          ),
        ),
      ),
    );
  }
}