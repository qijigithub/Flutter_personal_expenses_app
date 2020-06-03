import 'package:flutter/services.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix1;
// import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';

import 'database/odata_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      //personal global style setting
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          // errorColor: Colors.red,
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransaction = [
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
  ];
  bool _showChart = false;
  final url =
      'https://bugtrackerdbp1942687815trial.hanatrial.ondemand.com/flutter/services.xsodata';

    List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }



  Future<List<Transaction>> fetchAndSetTrans() async {
    List<Transaction> trans = await ODataService(
      host: url,
      user: '',
      pswd: '',
    ).fetchData();
    return trans;
  }


  addDataToHana(String txTitle, double txAmount, DateTime chosenDate, String id) {
    return ODataService(
      host: url,
      user: '',
      pswd: '',
    ).addTransaction(txTitle, txAmount, chosenDate,id);
  }

  void initState() {
    //SAP data base initialize
    // Future<List<Transaction>> trans = fetchAndSetTrans();
    // trans.then((element) {
    //   element.forEach((element) {
    //     final dbnewTx = Transaction(
    //       id: element.id.toString(),
    //       title: element.title,
    //       amount: element.amount,
    //       date: element.date,
    //     );
    //     setState(() {
    //       _userTransaction.add(dbnewTx);
    //     });
    //   });
    //   print("initstate");
    //   print(_userTransaction);
    // });
////////////////////////////////////////////////////////
    // http.post(url,body: json.encode({
    //   'title':'newtesttohana',
    //   'id': 'Transactions2',
    //   'date': DateTime.now().toString(),
    //   'amount':23,
    // }),);

    prefix1.Firestore.instance
        .collection('users/MvRj6kzu3KHf3G2RovX3/trans')
        .snapshots()
        .listen((event) {
      // print(event.documents[0]['title']);
      event.documents.forEach((element) {
        final dbnewTx = Transaction(
          title: element['title'],
          amount: element['amount'],
          date: element['date'].toDate(),
          //DateFormat.yMMMEd().format(DateTime.parse(element['date'])) ,
          id: element['id'].toString(),
        );
        setState(() {
          _userTransaction.removeWhere((tx) => tx.id == dbnewTx.id);
          _userTransaction.add(dbnewTx);

          
        });
    print('run initialize');
    print(_userTransaction);
      });
    });

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }



//update  input transaction to state
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final id =  'Date${DateTime.parse(DateTime.now().toIso8601String()).millisecondsSinceEpoch}';
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: id);
    //google database
    prefix1.Firestore.instance
        .collection('users/MvRj6kzu3KHf3G2RovX3/trans')
        .add({
      'title': txTitle,
      'amount': txAmount,
      'date': chosenDate,
      'id': DateTime.now().toString(),
    });
    //SAP databasae
    // addDataToHana(txTitle, txAmount, chosenDate,id);
    //uncomment when use SAP database
    // setState(() {
    //   _userTransaction.add(newTx);
    // });
    print('add new transaciton');
    print(_userTransaction);
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return
              // NewTransaction(_addNewTransaction);
              GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  deleteFromHana(String id) {
    const url =
        'https://bugtrackerdbp1942687815trial.hanatrial.ondemand.com/flutter/services.xsodata';
    return ODataService(
      host: url,
      user: '',
      pswd: '',
    ).deleteTrans(id);
  }

  deletefromFirebase(String id) {
  }

  void _deleteTransaction(String id) {
    // showAlertDialog(context);
    // setState(() {
    //   _userTransaction.removeWhere((tx) => tx.id == id);
    // });
    Widget remindButton = FlatButton(
        child: Text("Confirm"),
        onPressed: () {
          Navigator.of(context).pop();
          //SAP database
          // deleteFromHana(id);
          setState(() {
            _userTransaction.removeWhere((tx) => tx.id == id);
          });
          
        });
    Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });

    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("please confirm to delete this transcaction"),
      actions: [
        remindButton,
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
        // Navigator.of(context).pop();
      },
    );
  }

  List<Widget> _buildLanscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Show Chart', style: Theme.of(context).textTheme.headline6),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    // _addDataFromFireBase();
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
            ),
            // actions:
            // Platform.isAndroid
            //     ? null
            //     : <Widget>[
            //         IconButton(
            //           icon: Icon(Icons.add),
            //           onPressed: () => _startAddNewTransaction(context),
            //         )
            // ],
          );

    final txListWidget =
        // user input widget and a list of transaction widget
        Container(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.7,

            //userTransction is state can be replaced by database
            child: TransactionList(_userTransaction, _deleteTransaction));

    final pageBody =
        // Center(
        //   child: Text('Widget Playground')
        // ),
        SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLanscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),

//chart area

            // Container(
            //   width: double.infinity,
            //   child: Card(
            //     // color: Colors.blue,
            //     child:
            //     Chart(_userTransaction),
            //     // Text('CHART!'),

            //     elevation: 5,
            //   ),
            // ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body:
                // StreamBuilder(stream:
                //  prefix1.Firestore.instance.collection('users/MvRj6kzu3KHf3G2RovX3/trans').snapshots()
                // ,builder: (ctx,streamSnapshot){
                //     return
                // },)
                pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
