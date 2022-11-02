import 'package:ImpTicket/provider/tickets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Alert lecode(BuildContext context) {

  String code='';
  String nom ='';

  final _keyForm = GlobalKey<FormState>();
    return Alert(
              context: context,
              title: "Entrez les infos de la reservation",
              content: Form(
              key: _keyForm,
                  child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Identifiant du client',
                      ),
                      validator: (val) => val.length < 0 ? 'nom incorrect' : null,
                      onChanged: (val) => nom = val,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Code',
                      ),
                      validator: (val) => val.length < 0 ? 'Code incorrect' : null,
                      onChanged: (val) => code = val,
                    ),
                  ],
                ),
              ),
              buttons: [
                DialogButton(
                  onPressed: () {
                    if(_keyForm.currentState.validate()){
                      print('imprimer');
                      Ticket.valideCode(context, nom, code);
                    }
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]);
  }
  
Alert errorMessage(BuildContext context) {
    return Alert(
              context: context,
              type: AlertType.error,
              title: "Error",
              content: Column(
                children: <Widget>[
                  Text('Identifiant ou mot de passe incorrect', style: TextStyle(fontSize: 16),),
                ],
              ),
              buttons: [
                DialogButton(
                  color: Colors.red,
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Ressayez",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]);
  }

Alert messageUp(BuildContext context,
  String leservice,
  String numero,
  String date,
  String attente,
  String file,
) {
    return Alert(
              context: context,
              title: "Message",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(),
                    Text('Service : '+leservice, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Divider(),
                    Text('Numéro : '+numero, style: TextStyle(fontSize : 16),),
                    Divider(),
                    Text('Date : '+date, style: TextStyle(fontSize: 16),),
                    // Text('Temps d\'attente : '+file, style: TextStyle(fontSize: 16),)
                  ],
              ),
              buttons: [
                DialogButton(
                  onPressed: () {
                    // print("liste: "+file);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]);
  }