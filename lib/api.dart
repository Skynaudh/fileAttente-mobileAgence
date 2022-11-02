class Api{
  static const String url = 'http://192.168.137.1:8000/api'; 
  // static const String url = 'http://vue.xaed4360.odns.fr/public/api'; 
  static const String login = '$url/login';
  static const String urlInfo = '$url/informationAgent';
  static const String urlService = '$url/listeServiceToAgence';
  static const String urlAddTicket = '$url/addTickets';
  static const String urlValideCode = '$url/ValiderCodeSecret';
  static const String urlPrintTicket = '$url/PrintTicketReservation';
}