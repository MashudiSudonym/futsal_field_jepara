import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/currency_formatter.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart';

class InvoiceScreen extends StatefulWidget {
  final String uid;
  final String userUID;
  final String fieldTypeSelected;
  final String timeOrderSelected;
  final String dateOrderSelected;
  final String fieldName;
  final int fieldPrice;

  const InvoiceScreen({
    @required this.uid,
    @required this.userUID,
    @required this.fieldTypeSelected,
    @required this.timeOrderSelected,
    @required this.dateOrderSelected,
    @required this.fieldName,
    @required this.fieldPrice,
  });

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black26,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Detail Pesanan Lapangan",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 100 * 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width / 100 * 4,
                    ),
                    child: Table(
                      defaultColumnWidth: IntrinsicColumnWidth(),
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Text(
                                "Nama",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width /
                                      100 *
                                      3.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Text(widget.uid),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Text(
                                "Alamat",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width /
                                      100 *
                                      3.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Text(widget.uid),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Text(
                                "Telepon",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width /
                                      100 *
                                      3.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Text(widget.uid),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Text(
                                "Tempat",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width /
                                      100 *
                                      3.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Text(widget.fieldName),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Text(
                                "Tanggal Pesan",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width /
                                      100 *
                                      3.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Text(widget.dateOrderSelected),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Text(
                                "Jam Pesan",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width /
                                      100 *
                                      3.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Text(widget.timeOrderSelected),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Text(
                                "Jenis Lapangan",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width /
                                      100 *
                                      3.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Text(widget.fieldTypeSelected),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Text(
                                "Harga",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width /
                                      100 *
                                      3.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Text(
                                currencyFormatter(widget.fieldPrice),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 100 * 4,
                      0,
                      MediaQuery.of(context).size.width / 100 * 4,
                      MediaQuery.of(context).size.width / 100 * 4,
                    ),
                    child: Text(
                      "*pastikan data pesanan sudah benar. \n**pesanan anda akan diproses oleh admin, tunggu pemberitahuan selanjutnya dari admin lapangan futsal.",
                      style: TextStyle(
                        color: kRedColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 100 * 30),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 100 * 7,
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height / 100 * 1),
              child: RaisedButton(
                child: Text(
                  "Pesan Lapangan",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.greenAccent[400],
                onPressed: () {},
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 100 * 7,
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height / 100 * 1),
              child: FlatButton(
                child: Text(
                  "Batal Pesan",
                  style: TextStyle(
                    color: Colors.redAccent[400],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  ExtendedNavigator.ofRouter<Router>().pushNamedAndRemoveUntil(
                      Routes.mainScreen, (Route<dynamic> route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
