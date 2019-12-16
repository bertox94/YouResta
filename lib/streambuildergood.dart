import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youresta/models/custom_user.dart';
import 'package:youresta/models/user.dart';
import 'package:youresta/screens/authenticate/authenticate.dart';
import 'package:youresta/screens/home/home_business.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youresta/services/custom_user_manager.dart';
import 'package:youresta/shared/loading.dart';

class streambuildergood extends StatelessWidget {
  final FirebaseUser user;

  streambuildergood({this.user});

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document['isBusiness'].toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("StreamBuilder with FireStore")),
      body: StreamBuilder(
        stream: Firestore.instance.collection('custom_users').snapshots(),
        //print an integer every 2secs, 10 times
        builder: (context, snapshot) {
          var documents = snapshot.data.documents;
          var selected;

          if (!snapshot.hasData) {
            return Text("Loading..");
          } else {
            for (int i = 0; i < documents.length; i++) {
              print(documents[i]['uid']);
              if (documents[i]['uid'] == user.uid) {
                print(documents[i]['uid']);
                selected = documents[i];
              }
            }
          }

          return Text(selected['isBusiness'].toString());
        },
      ),
    );
  }
}
