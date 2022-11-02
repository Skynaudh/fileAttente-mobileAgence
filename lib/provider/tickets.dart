import 'dart:convert';

import 'package:ImpTicket/Screen/alert.dart';
import 'package:ImpTicket/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ticket {
  static void addTicket(BuildContext context, String service) async{
    const url = Api.urlAddTicket;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    String agence = sharedPreferences.getString("agence");
    try{
      print(agence);
      final response = await http.post(url, body: json.encode({'agence' : agence, 'service' : service}), headers: {
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'});
      if(response.statusCode == 201){
        final data = json.decode(response.body) as Map;
        final listdata = data['data'] as Map;
        sharedPreferences.setString("number", listdata['number'].toString());
        sharedPreferences.setString("agence", listdata['agence']);
        sharedPreferences.setString("service", listdata['service']);        
        sharedPreferences.setString("date", listdata['date']);
        // sharedPreferences.setString("date", listdata['date'].toString().split(' ')[0]);
        sharedPreferences.setString("file", listdata['file'].toString());
        sharedPreferences.setString("temps", listdata['temps']);

          print('Enregistrement');
          //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

          String leservice = sharedPreferences.getString("service");
          String numero = sharedPreferences.getString("number");
          String file = sharedPreferences.getString("file");
          String date = sharedPreferences.getString("date");
          String attente = sharedPreferences.getString("temps");
                                  
          messageUp(context, leservice, numero, date, attente, file).show();
      }
      else print(response.body);
    }catch(error) {throw error;}
  }

  static void valideCode(BuildContext context, String nom, String code) async{
    const url = Api.urlValideCode;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    try{

      final response = await http.post(url, body: json.encode({'nomClient' : nom, 'code' : code}), headers: {
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'});
      if(response.statusCode == 201){
       
        const urlPrint = Api.urlPrintTicket;
        final resp = await http.post(urlPrint, body: json.encode({'code' : code}), headers: {
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'});
        if(resp.statusCode == 201){
          print('etape3');
          final data = json.decode(resp.body) as Map<String, dynamic>;
          final listdata = data['data'];
          print(listdata);
          // print('service'+listdata['service'].runtimeType.toString());
          // print('number'+listdata['number'].runtimeType.toString());
          // print('date'+listdata['date'].runtimeType.toString());
          // print('temps'+listdata['temps'].runtimeType.toString());
          // print('file'+listdata['file'].runtimeType.toString());
          messageUp(context, listdata['service'], listdata['number'].toString(), listdata['date'], listdata['temps'], listdata['file'].toString()).show();
        }
        else print(resp.body);
      }
      else {
        print(response.body);
        errorMessage(context).show();
      }
    }catch(error) {throw error;}
  }

  static void efface() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove("number");
    sharedPrefs.remove("agence");
    sharedPrefs.remove("service");
    sharedPrefs.remove("date");
    sharedPrefs.remove("file");
    sharedPrefs.remove("temps");
  }
}