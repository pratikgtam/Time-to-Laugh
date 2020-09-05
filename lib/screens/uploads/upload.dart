import 'package:audio_recorder/audio_recorder.dart';
import 'package:laugh/screens/home/home.dart';
import 'package:laugh/screens/laugh/laugh.dart';
import 'package:laugh/screens/profile/profile.dart';
import 'package:laugh/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laugh/models/user.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  // Check permissions before starting
  Future<bool> hasPermissions = AudioRecorder.hasPermissions;

// Get the state of the recorder
  Future<bool> isRecording = AudioRecorder.isRecording;

  final AuthService _auth = AuthService();
  int _selectedIndex = 1;

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
        break;
      case 2:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) => Laugh()));
        break;
      case 3:
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => Profile()));
        break;
      default:
    }
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) => Home()));
        break;
      case 1:
        break;
      case 2:
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) => Laugh()));
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
        title: Text('Upload'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 50, 32, 100),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.cloud_upload,
                    color: Colors.black,
                    size: 100,
                  ),
                  Text(
                    '     Upload Your Laugh',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.keyboard_voice,
                    size: 200,
                    color: Colors.yellow[800],
                  ),
                ),
                Text(
                  '00:00',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Stop recording',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
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
