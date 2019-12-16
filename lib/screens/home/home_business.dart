import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youresta/screens/home/insert_dish.dart';
import 'package:youresta/services/auth.dart';

class HomeBusiness extends StatefulWidget {
  @override
  HomeBusinessState createState() {
    return HomeBusinessState();
  }
}

class HomeBusinessState extends State<HomeBusiness> {
  final AuthService _auth = AuthService();
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  int randomNumber = -1;

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'name: ${doc.data['name']}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'todo: ${doc.data['todo']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => updateData(doc),
                  child: Text('Update todo',
                      style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: (value) => name = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
        title: Container(
          child: Row(
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                scale: 40,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.deepOrange,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            label: Text('Add'),
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InsertDish()));
            },
            icon: Icon(Icons.restaurant_menu),
          ),
          FlatButton.icon(
            label: Text('Log Out'),
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: buildTextFormField(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createData,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
              RaisedButton(
                onPressed: id != null ? readData : null,
                child: Text('Read', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('CRUD').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: snapshot.data.documents
                        .map((doc) => buildItem(doc))
                        .toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db
          .collection('CRUD')
          .add({'name': '$name 😎', 'todo': randomTodo()});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();
    print(snapshot.data['name']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db
        .collection('CRUD')
        .document(doc.documentID)
        .updateData({'todo': 'please 🤫'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('CRUD').document(doc.documentID).delete();
    setState(() => id = null);
  }

  String randomTodo() {
    randomNumber++;
    randomNumber %= 4;
    String todo;
    switch (randomNumber) {
      case 0:
        todo = 'Like and subscribe 💩';
        break;
      case 1:
        todo = 'Twitter @robertbrunhage 🤣';
        break;
      case 2:
        todo = 'Patreon in the description 🤗';
        break;
      case 3:
        todo = 'Leave a comment 🤓';
        break;
    }
    return todo;
  }
}
