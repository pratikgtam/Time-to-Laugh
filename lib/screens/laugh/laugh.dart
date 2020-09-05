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
  final AuthService _auth = AuthService();
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        print(index);

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
