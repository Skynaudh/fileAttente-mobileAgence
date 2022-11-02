import 'dart:convert';

import 'package:ImpTicket/Model/serice_model.dart';
import 'package:ImpTicket/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Services with ChangeNotifier{
  List <Service> _items = [];

  List<Service> get items {
    return [..._items];
  }
  Future<void> getAllServices(String agence) async{
    const url = Api.urlService;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    try{
      final response = await http.post(url, body: json.encode({'agence' : agence}), headers: {
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'});
        print(response.statusCode);
      if(response.statusCode == 201){
        final data = json.decode(response.body) as Map<String, dynamic>;
        List<Service> tmp = [];
        final listdata = data['data'] as List;
        listdata.forEach((element) { 
          tmp.add(Service(id: element['id'], description: element['service']));
        });
        _items = tmp;
      }
    }catch(error) {
      print(error);
      throw error;}
  }
}