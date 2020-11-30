import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tentang Futsal Field Jepara"),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height / 100 * 5,
                right: MediaQuery.of(context).size.height / 100 * 5,
              ),
              child: Center(
                child: Text(
                  'Futsal Field Jepara merupakan aplikasi untuk memberikan informasi tentang lokasi lapangan futsal yang ada di kabupaten jepara.\nInformasi yang diberikan berupa lokasi lapangan futsal, ketersediaan lapangan yang dapat disewa, jam buka/tutup lapangan futsal, harga sewa lapangan futsal.',
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
