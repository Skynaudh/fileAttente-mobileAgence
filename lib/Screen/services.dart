import 'package:ImpTicket/Model/serice_model.dart';
import 'package:ImpTicket/Model/ticket_model.dart';
import 'package:ImpTicket/Screen/alert.dart';
import 'package:ImpTicket/provider/service.dart';
import 'package:ImpTicket/provider/tickets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MesServices extends StatefulWidget {
  static const routeName = '/services';
  
  @override
  _MesServicesState createState() => _MesServicesState();
}

class _MesServicesState extends State<MesServices> {
  List<Service> service;
  bool _isInit = true;
  bool _isLoad = false;
  Map args;
  double sizeW;
  double sizeH;
  Color couleur = Colors.cyan[900];
  // String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  // TimeOfDay now = TimeOfDay.now();


  void _logout() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove("agence");
    sharedPrefs.remove("token");
    Navigator.of(context).pop();
    print('disconnect');
  }
  
  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoad = true;
      });
      args = ModalRoute.of(context).settings.arguments as Map;
      //print(args['type']);
      Provider.of<Services>(context).getAllServices(args['agence']).then((value){
        setState(() {
          _isLoad= false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
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
                child: Column(
                  children: [],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  children: <Widget>[
                    // FlatButton(
                    //   color: couleur,
                    //   textColor: Colors.white,
                    //   onPressed: (){
                    //     print(service.description);
                    //     Ticket.addTicket(service.description);
                    //   },
                    //  child: Text('Imprimer'),
                    //  ),
                    FlatButton(onPressed: (){
                      Ticket.efface();
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

  Alert message(BuildContext context,
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
                children: <Widget>[
                  Divider(),
                    Text('Service : '+leservice, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text('Numéro : '+numero, style: TextStyle(fontSize : 16),),
                    Text('Date : '+date, style: TextStyle(fontSize: 16),),
                    Text('Temps d\'attente : '+attente, style: TextStyle(fontSize: 16),)
                  ],
              ),
              buttons: [
                DialogButton(
                  onPressed: () {
                    //Ticket.efface();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]);
  }

  Widget lesServices(){
    sizeW = MediaQuery.of(context).size.width;
    sizeH = MediaQuery.of(context).size.height;
    //institution = Provider.of<Institutions>(context).items;
    return Padding(
    padding: const EdgeInsets.all(20.0),
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 0.2,
        mainAxisExtent: 120,
        //mainAxisSpacing: 0.5,
        ),
        itemCount: service.length,
        itemBuilder: (context, index){
      return GestureDetector(
        onTap: (){},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 5,
                    decoration: BoxDecoration(
                    border: Border.all(color: couleur, width: 1.0)
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(0.8),
                    child: GestureDetector(
                                onTap: () async {
                                  print(service[index].description);
                                  Ticket.addTicket(context, service[index].description);
                                },
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            Expanded(child: Center(child: Text(service[index].description, 
                            style: TextStyle(fontSize: 20, color: couleur, fontWeight: FontWeight.w400),))),
                            IconButton(
                              icon: Icon(Icons.print, color: couleur,),
                                tooltip: 'Imprimer',
                                onPressed: (){},
                              ),
                          ],
                      ),
                    ),
                  ),
                ),
              ),
      );
    },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    service = Provider.of<Services>(context).items;
    return Scaffold(appBar: AppBar(
      actions: <Widget>[
        PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                  if (value == 1) {
                    print(1);
                  }else if(value == 2) {
                    //print(2);
                    _logout();
                  }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Mon profil"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Se deconnecter"),
                ),
              ],
            )
        ],
        title: Text(
          args['institution'],
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _isLoad ? Center(child: CircularProgressIndicator()) : lesServices(),
      floatingActionButton: DialogButton(
        width: 150,
        child: Center(child: Text('Reservation', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),)),
        color: couleur,
        onPressed: (){
          lecode(context).show();
        },),
    );
  }
}