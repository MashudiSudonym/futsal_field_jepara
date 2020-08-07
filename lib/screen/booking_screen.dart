import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:futsal_field_jepara/model/user_order.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/currency_formatter.dart';
import 'package:lottie/lottie.dart';
import 'package:futsal_field_jepara/model/data.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String _userUID = "";

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  Future<void> _getUserData() async {
    final _user = await _auth.currentUser();
    setState(() {
      _userUID = _user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking List"),
        elevation: 0.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: loadUserOrderByUserId(_userUID),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Lottie.asset(
                "assets/nodata.json",
                height: MediaQuery.of(context).size.height / 100 * 25,
              ),
            );
          if (snapshot.hasError)
            return Center(
              child: Lottie.asset(
                "assets/error.json",
                height: MediaQuery.of(context).size.height / 100 * 25,
              ),
            );
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Lottie.asset(
                  "assets/loading.json",
                  height: MediaQuery.of(context).size.height / 100 * 25,
                ),
              );
            default:
              return Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width / 100 * 14,
                ),
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final userOrder = UserOrder.fromMap(
                          snapshot.data.documents[index].data);
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 375),
                        child: SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.width / 100 * 2,
                                horizontal:
                                    MediaQuery.of(context).size.width / 100 * 2,
                              ),
                              child: Card(
                                elevation: 2.0,
                                child: ListTile(
                                  onTap: () {},
                                  title: Text(
                                    userOrder.futsalFieldName,
                                    style: TextStyle(
                                      color: kTitleTextColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              100 *
                                              5,
                                    ),
                                  ),
                                  subtitle: Text(
                                    (userOrder.orderStatus != 0)
                                        ? "Tanggal Pesan : ${userOrder.orderDate.replaceAll("-", "/")}\nJam Pesan : ${userOrder.orderTime}\nJenis Lapangan : ${userOrder.fieldType}\nHarga : ${currencyFormatter(userOrder.price)}\nStatus Pesanan : Pesanan Diterima"
                                        : "Tanggal Pesan : ${userOrder.orderDate.replaceAll("-", "/")}\nJam Pesan : ${userOrder.orderTime}\nJenis Lapangan : ${userOrder.fieldType}\nHarga : ${currencyFormatter(userOrder.price)}\nStatus Pesanan : Menunggu",
                                    style: TextStyle(
                                        color: kBodyTextColor,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                100 *
                                                3),
                                  ),
                                  isThreeLine: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 100 * 2,
                    )),
              );
          }
        },
      ),
    );
  }
}
