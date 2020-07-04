import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/widget/futsal_field_search_delegate.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Location"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FutsalFieldSearchDelegate(),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Text("Searching"),
      ),
    );
  }
}
