import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youresta/models/custom_user.dart';
import 'package:youresta/models/user.dart';
import 'package:youresta/screens/authenticate/authenticate.dart';
import 'package:youresta/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youresta/services/custom_user_manager.dart';
import 'package:youresta/shared/loading.dart';

class Wrapper2 extends StatelessWidget {
  final User user;

  Wrapper2({this.user});

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
            print('\n');
            print(snapshot
                .toString()); //AsyncSnapshot<QuerySnapshot>(ConnectionState.active, Instance of 'QuerySnapshot', null)
            print(snapshot.data.toString()); //Instance of 'QuerySnapshot'
            print(snapshot.data.documents
                .toString()); //[Instance of 'DocumentSnapshot']
            print(snapshot.data.documents[0]
                .toString()); //Instance of 'DocumentSnapshot'
            print('\n');

            for (int i = 0; i < documents.length; i++) {
              print(documents[i]['uid']);
              if (documents[i]['uid'] == user.uid) {
                print(documents[i]['uid']);
                selected = documents[i];
              }
            }
          }

          return Text(selected['isBusiness'].toString());
          //return Text(selected['isBusiness'].toString());
        },
      ),
    );
  }
}
