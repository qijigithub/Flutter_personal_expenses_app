import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();

}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();
  DateTime _selectedDate;

    showAlertDialog(BuildContext context) {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    
    // final snackBar = SnackBar(
    //   elevation: 8,
    //   duration: new Duration(seconds:4),
    //   backgroundColor: Theme.of(context).primaryColor,
    //   content: Text("hello world"),
    // );

    Function toast(
      String msg, Toast toast, ToastGravity toastGravity, Color colors) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toast,
        gravity: toastGravity,
        backgroundColor: colors,
        textColor: Colors.white,
        fontSize: 16.0);
  }

    if (enteredTitle.isEmpty ||enteredAmount.isNaN|| enteredAmount < 0||_selectedDate ==null) {
      // Fluttertoast.showToast(
      //   msg: "this is a tost", 
      //   gravity: ToastGravity.CENTER,

      //   );
      toast(
                    "This is Demo 2 Toast at top",
                    Toast.LENGTH_SHORT,
                    ToastGravity.CENTER,
                    Theme.of(context).primaryColor); 
      return
      ;
    }
    Widget remindButton = FlatButton(
      child: Text("Confirm") ,
      onPressed:  () {
        Navigator.of(context).pop();
        _submitData();
      }
    );
        Widget cancelButton = FlatButton(
      child: Text("Cancel") ,
      onPressed:  () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    );
    


  AlertDialog alert =AlertDialog(
    title:Text("Notice"),
    content: Text("please confirm this transcaction"),
    actions:[
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

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    
    if (enteredTitle.isEmpty || enteredAmount < 0||_selectedDate ==null) {

      return;
    }
    widget.addTx(enteredTitle, enteredAmount,_selectedDate);
    //  print(amountInput);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
       initialDate: DateTime.now(),
        firstDate: DateTime(2020),
         lastDate:DateTime.now()).then((pickedDate) {
           if(pickedDate == null) {
             return;
           }
           setState(() {
              _selectedDate = pickedDate;
           });
         });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(top:10,left:10,right:10, bottom:MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // CupertinoTextField(placeholder: ,)
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val){
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                // onChanged: (val)=> amountInput =val,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                   Expanded(child: Text(_selectedDate ==null? 'No Date Chosen!': 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',)),
                   
                   Platform.isIOS? CupertinoButton(
                      child: Text('Choose Date',style: TextStyle(fontWeight: FontWeight.bold),),
                      onPressed: _presentDatePicker,
                   ):
                   FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text('Choose Date',style: TextStyle(fontWeight: FontWeight.bold),),
                      onPressed: _presentDatePicker,
                    )
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: 
                    ()=>showAlertDialog(context),
                // _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
