import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/cupertino.dart';
import 'package:laugh/screens/home/home.dart';
import 'package:laugh/screens/laugh/laugh.dart';
import 'package:laugh/screens/profile/profile.dart';
import 'package:laugh/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laugh/models/user.dart';

import 'dart:io' as io;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

class Upload extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  Upload({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  bool _isRecoding = false;

  Recording _recording = new Recording();

  Random random = new Random();
  TextEditingController _controller = new TextEditingController();
  bool playButtonVisible = false;

  File file;

  // Check permissions before starting
  Future<bool> hasPermissions = AudioRecorder.hasPermissions;

// Get the state of the recorder
  Future<bool> isRecording = AudioRecorder.isRecording;

  final AuthService _auth = AuthService();
  int _selectedIndex = 1;

  bool first = true;

  String email = "";

  String id = "";

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
    id = user.uid;
    email = user.email;
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
            child: Visibility(
              visible: true,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (playButtonVisible || first) {
                        first = false;
                        _isRecoding ? null : _start();
                      }
                    },
                    child: Icon(
                      Icons.keyboard_voice,
                      size: 200,
                      color: Colors.yellow[800],
                    ),
                  ),
                  Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0,

                    children: <Widget>[
                      Visibility(
                        visible: _isRecoding,
                        child: Text(
                          'Recording',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isRecoding,
                        child: RaisedButton(
                            padding: EdgeInsets.only(left: 50, right: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: Colors.yellow[400],
                            child: Text(
                              'Stop Recording',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: _isRecoding ? _stop : null),
                      ),
                      Visibility(
                        visible: !_isRecoding && playButtonVisible,
                        child: new FlatButton(
                          onPressed: _play,
//                  _play,
                          child: new Text("Play"),
                          color: Colors.yellowAccent,
                        ),
                      ),
                      Visibility(
                        visible: !_isRecoding && playButtonVisible,
                        child: new FlatButton(
                          onPressed: _saveFile,
//                  _play,
                          child: new Text("Upload"),
                          color: Colors.red[200],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        if (_controller.text != null && _controller.text != "") {
          String path = "/storage/emulated/0/" +
              DateTime.now().millisecondsSinceEpoch.toString();
          if (!_controller.text.contains('/')) {
            io.Directory appDocDirectory =
                await getApplicationDocumentsDirectory();
            path = appDocDirectory.path + '/' + _controller.text;
          }
          print("Start recording: $path");
          await AudioRecorder.start(
              path: path, audioOutputFormat: AudioOutputFormat.AAC);
        } else {
          await AudioRecorder.start();
        }
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecoding = isRecording;
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
        askPermissions();
      }
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();

    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    file = widget.localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _isRecoding = isRecording;
      playButtonVisible = true;
    });
    _controller.text = recording.path;
  }

  Future<void> askPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.speech,
      Permission.storage,
    ].request();
    print(statuses[Permission.location]);
  }

  Future<void> _play() async {
    AudioPlayer audioPlayer = AudioPlayer();
    setState(() {
      playButtonVisible = false;
    });
    int result = await audioPlayer.play(_recording.path, isLocal: true);
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        playButtonVisible = true;
      });
    });
  }

  _saveFile() async {
    StorageReference storageReference = FirebaseStorage.instance.ref();
    File _image;

    //CreateRefernce to path.
    StorageReference ref = storageReference.child("yourstorageLocation/");

    //StorageUpload task is used to put the data you want in storage
    //Make sure to get the image first before calling this method otherwise _image will be null.

    StorageUploadTask storageUploadTask = ref
        .child(id+_recording.path)
        .putFile(file);

    if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
      final String url = await ref.getDownloadURL();
      print("The download URL is " + url);
    } else if (storageUploadTask.isInProgress) {
      storageUploadTask.events.listen((event) {
        double percentage = 100 *
            (event.snapshot.bytesTransferred.toDouble() /
                event.snapshot.totalByteCount.toDouble());
        print("THe percentage " + percentage.toString());
      });

      StorageTaskSnapshot storageTaskSnapshot =
          await storageUploadTask.onComplete;
      String downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();

      //Here you can get the download URL when the task has been completed.
      print("Download URL " + downloadUrl1.toString());
    } else {
      //Catch any cases here that might come up like canceled, interrupted
    }
  }
}
