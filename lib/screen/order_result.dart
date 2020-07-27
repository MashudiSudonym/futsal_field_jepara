import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/utils/constants.dart';

class OrderResult extends StatefulWidget {
  final String uid;
  final String userUID;
  final String fieldTypeSelected;
  final String timeOrderSelected;
  final String dateOrderSelected;
  final String fieldName;
  final int fieldPrice;

  const OrderResult({
    @required this.uid,
    @required this.userUID,
    @required this.fieldTypeSelected,
    @required this.timeOrderSelected,
    @required this.dateOrderSelected,
    @required this.fieldName,
    @required this.fieldPrice,
  });

  @override
  _OrderResultState createState() => _OrderResultState();
}

class _OrderResultState extends State<OrderResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Konfirmasi Pesanan"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(
                MediaQuery.of(context).size.width / 100 * 4,
              ),
              width: MediaQuery.of(context).size.width,
              color: kRedColor,
              child: Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width / 100 * 4,
                ),
                child: Column(
                  children: <Widget>[
                    Text(widget.uid),
                    Text(widget.userUID),
                    Text(widget.fieldTypeSelected),
                    Text(widget.fieldName),
                    Text(widget.fieldPrice.toString()),
                    Text(widget.fieldTypeSelected),
                    Text(widget.timeOrderSelected),
                    Text(widget.dateOrderSelected),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
