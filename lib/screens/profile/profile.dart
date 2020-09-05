import 'package:flutter/material.dart';
import 'package:laugh/screens/home/home.dart';
import 'package:laugh/screens/laugh/laugh.dart';
import 'package:laugh/screens/uploads/upload.dart';
import 'package:laugh/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:laugh/models/user.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        print(index);
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) => Home()));

        break;
      case 1:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) => Upload()));
        break;
      case 2:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) => Laugh()));
        break;
      case 3:
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
        title: Text('Profile'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: Container(child: Text('ID:' + user.uid + 'email:' + user.email)),
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
}
