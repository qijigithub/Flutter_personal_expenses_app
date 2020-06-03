// import 'dart:io';

import 'package:expense_app/models/transaction.dart';
import 'package:expense_app/widgets/transaction_item.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransation;
  TransactionList(this.transactions, this.deleteTransation);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty ?
      //if no transaction ,showing message and image
      LayoutBuilder(builder:(ctx,constraints){
        return Column(children: <Widget>[
        Text('No Transactions added yet!', style: Theme.of(context).textTheme.headline6,),
        const SizedBox(height:10),
        Container(
          height: constraints.maxHeight * 0.6,
          child: Image.asset('assets/images/waiting.png',fit:BoxFit.cover))
      ],);
      }) 
      //if have transaction, showing transaction
      : ListView.builder(
        itemBuilder: (ctx, index) {
          // return Card(
          //   child: Row(
          //     children: <Widget>[
          //       Container(
          //         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          //         decoration: BoxDecoration(
          //             border: Border.all(
          //                 color: Theme.of(context).primaryColor, width: 2)),
          //         padding: EdgeInsets.all(10),
          //         child: Text(
          //           '\$${transactions[index].amount.toStringAsFixed(2)}',
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 20,
          //               color: Theme.of(context).primaryColor),
          //         ),
          //       ),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: <Widget>[
          //           Text(transactions[index].title,
          //               style: Theme.of(context).textTheme.title),
          //           Text(
          //             DateFormat.yMMMEd().format(transactions[index].date),
          //             style: TextStyle(
          //               color: Colors.grey,
          //             ),
          //           )
          //         ],
          //       )
          //     ],
          //   ),
          // );
          return TransactionItem(transaction: transactions[index], deleteTransation: deleteTransation);
        },
        itemCount: transactions.length,
      );
  }
}
