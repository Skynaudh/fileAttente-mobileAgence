import 'dart:convert';
import 'package:ImpTicket/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Informations with ChangeNotifier{

  Map<String, dynamic> _items;
  
  Map<String, dynamic> get items {
    return _items;
  }

  Future<void> getAllInfo() async{
    const url = Api.urlInfo;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");

    try {
      final response = await http.get(url, headers: {
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'});
      print('info');
      if(response.statusCode==201 ){
        final data = json.decode(response.body) as Map;
        //print(data);
         Map<String, dynamic> tmp;
        final listdata = data['data'] as Map;
        //print(listdata);
          _items = {'id': listdata['id'], 'name': listdata['name'], 'email': listdata['email'], 'number': listdata['number'],
          'agence': listdata['agence'], 'institution': listdata['institution'], 'agentId': listdata['agentId']};
        //print(tmp);
      }
      else {
        print(token);
      }
    }catch(error) {throw error;}
  }
}