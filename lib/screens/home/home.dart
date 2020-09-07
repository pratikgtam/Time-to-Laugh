import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laugh/screens/laugh/laugh.dart';
import 'package:laugh/screens/profile/profile.dart';
import 'package:laugh/screens/uploads/upload.dart';
import 'package:laugh/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laugh/models/user.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  AudioPlayer audioPlayer = AudioPlayer();

  int _selectedIndex = 0;
  List iconDataRadio = [];
  String playingLaughName = "";
  List url = [];
  List name = [];

  QuerySnapshot _dataSnapshot;
  double _sliderPosition = 2;
  double _sliderMaximum = 4;
  IconData _iconPlayPause = Icons.pause;
  int _currentLaughIndex;

  bool _laughPlayVisible = false;

  bool videoPaused = false;

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
  void initState() {
    _setAudioStates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    final String id = user.uid;
    final String email = user.email;
    final db = Firestore.instance;

    for (int i = 0; i < 200; i++) {
      iconDataRadio.add(Icons.radio_button_unchecked);
    }

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Ringtoness'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Visibility(
              visible: _laughPlayVisible,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Text(playingLaughName),
                    // Slider(
                    //   value: _sliderPosition,
                    //   min: 0.0,
                    //   max: _sliderMaximum,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _sliderPosition = value;
                    //     });
                    //   },
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        InkWell(
                          onTap: () => _playLaugh(_currentLaughIndex + 1),
                          child: Icon(
                            Icons.arrow_left,
                            size: 50,
                          ),
                        ),
                        InkWell(
                          onTap: _playOrPause,
                          child: Icon(
                            _iconPlayPause,
                            size: 50,
                          ),
                        ),
                        InkWell(
                          onTap: () => _playLaugh(_currentLaughIndex - 1),
                          child: Icon(
                            Icons.arrow_right,
                            size: 50,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(id)
                    .collection('BoughtRingtone')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      return new ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            url.add(snapshot.data.documents[index]['url']);
                            name.add(snapshot.data.documents[index]['name']);

                            return new ListTile(
                                onTap: () => _playLaugh(index),
                                leading: Icon(iconDataRadio[index]),
                                title: new Text(name[index]),
                                subtitle: new Text(url[index]));
                          });
                  }
                }),
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

  Future<void> _playLaugh(index) async {
    if (index < url.length) {
      for (int i = 0; i < iconDataRadio.length; i++) {
        iconDataRadio[i] = Icons.radio_button_unchecked;
      }
      setState(() {
        iconDataRadio[index] = Icons.radio_button_checked;
        _currentLaughIndex = index;
        _laughPlayVisible = true;
        videoPaused = true;
      });
      // await assetsAudioPlayer.open(Audio.network(url[_currentLaughIndex]));
      audioPlayer.play(url[_currentLaughIndex]);
      audioPlayer.seek(Duration(microseconds: 0));

      _playOrPause();
    }
  }

  Future<void> _playOrPause() async {
    _setAudioStates();
    if (videoPaused) {
      await audioPlayer.resume();
      _iconPlayPause = Icons.pause_circle_outline;
    } else {
      await audioPlayer.pause();
      _iconPlayPause = Icons.play_circle_outline;
    }

    setState(() {
      _iconPlayPause = _iconPlayPause;
    });
  }

  _setAudioStates() {
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      print('Current player state: $s');
      if (s == AudioPlayerState.COMPLETED) {
        videoPaused = true;
      }
      if (s == AudioPlayerState.PAUSED) {
        videoPaused = true;
      }
      if (s == AudioPlayerState.PLAYING) {
        videoPaused = false;
      }
      if (s == AudioPlayerState.STOPPED) {
        videoPaused = true;
      }
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      print('COmpleted');
    });
  }
}
