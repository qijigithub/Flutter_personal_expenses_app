import 'dart:convert';
// import '../models/password.dart';
// import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';
// import 'package:gates_flutter/data/database/network/payload_builder.dart';
// import 'package:gates_flutter/data/database/network/response_decoder.dart';
// import 'package:gates_flutter/models/country.dart';
// import 'package:gates_flutter/models/crimper.dart';
// import 'package:gates_flutter/models/favorite.dart';
// import 'package:gates_flutter/models/specifications.dart';
// import 'package:gates_flutter/models/user.dart';
// import 'package:gates_flutter/utils/password.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';

// import '../../const.dart';

class ODataService {
  String basicAuth;
  String host;
  String pswd;

  ODataService({
    @required String host,
    @required String user,
    @required String pswd, //pswd is encrypted
  }) {
    this.basicAuth =
        // 'Basic ' + base64Encode(utf8.encode('$user:${Password.decrypt(pswd)}'));
        'Basic ' + base64Encode(utf8.encode('$user:$pswd'));
    this.host = host;
  }

  String _buildUrl({
    String endpoint,
    bool format = true,
    bool filterOn = false,
    String filters = '',
  }) {
    return '$host/$endpoint' +
        ((format) ? '?\$format=json' : '') +
        ((filterOn) ? '&\$filter=$filters' : '');
  }

  //Transaction

  List<Transaction> toTransList(List transData) {
    // print(crimpersData);
    List<Transaction> trans = [];
    transData.forEach((element) {
      final dbnewTx = Transaction(
        title: element['title'],
        amount: double.parse(element['amount']),
        date: DateTime.fromMillisecondsSinceEpoch(
            int.parse(element['date'].substring(6, 19)),
            isUtc: true),
        id: element['id'].toString(),
      );
      trans.add(dbnewTx);
    });

    return trans;
  }

  Future<List<Transaction>> fetchData() async {
    var url = _buildUrl(
      endpoint: 'Transactions',
      format: true,
    );

    try {
      Response response = await http.get(url, headers: {
        'authorization': basicAuth,
      });
      print('response received');

      if (response.statusCode != 200) {
        return null;
      }

      List crimpersData = json.decode(response.body)['d']['results'];
      List<Transaction> trans = toTransList(crimpersData);
      return trans;
    } catch (error) {
      return null;
    }
  }

  Future addTransaction(
      String txTitle, double txAmount, DateTime chosenDate,String id) async {
    var body = json.encode({
      'title': txTitle,
      'amount': txAmount.toDouble().toStringAsFixed(2),
      'date':
          '/Date(${DateTime.parse(chosenDate.toIso8601String()).millisecondsSinceEpoch})/',
      //  chosenDate.toIso8601String(),
      'id':id
      // DateTime.now().toString(),
    });

    var url = _buildUrl(endpoint: 'Transactions', format: false);
    Response response = await http.post(url, body: body, headers: {
      'authorization': basicAuth,
      'content-type': 'application/json'
    });
    print(url);
    print(response.body);
    return response.statusCode;
  }


  Future deleteTrans(String id) async {
    var url = _buildUrl(
        endpoint: 'Transactions(\'$id\')',
        format: false);
    print(url);
    Response response =
        await http.delete(url, headers: {'authorization': basicAuth});

    return response.statusCode;
  }


}



