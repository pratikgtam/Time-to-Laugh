import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laugh/screens/home/home.dart';
import 'package:laugh/screens/profile/profile.dart';
import 'package:laugh/screens/uploads/upload.dart';
import 'package:laugh/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laugh/models/user.dart';

class Laugh extends StatefulWidget {
  @override
  _LaughState createState() => _LaughState();
}

class _LaughState extends State<Laugh> {
  List url = [];
  List name = [];
  final AuthService _auth = AuthService();
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) => Home()));

        break;
      case 1:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) => Upload()));
        break;
      case 2:
        break;
      case 3:
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => Profile()));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    final String id = user.uid;
    final String email = user.email;
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Laugh'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('AllRingtones').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              // return new Text('Loading...');
              default:
                if (url.length < 1) {
                  for (int i = 0; i < snapshot.data.documents.length; i++) {
                    url.add(snapshot.data.documents[i]['url']);
                    name.add(snapshot.data.documents[i]['name']);
                  }
                }
                return new ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.black,
                        ),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return new ListTile(
                        onTap: () => _buyLaugh(index),
                        trailing: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            onPressed: () {},
                            color: Colors.yellow[800],
                            child: Text(
                              'Buy',
                              style: TextStyle(color: Colors.white),
                            )),
                        title: new Text(name[index]),
                      );
                    });
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        backgroundColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.play_arrow,
            ),
            title: new Text('Ringtones'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.cloud_upload,
            ),
            title: new Text('Upoad'),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.music_video,
              ),
              title: Text('Laugh')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              title: Text('Profile'))
        ],
      ),
    );
  }

  _buyLaugh(int index) {}
}
