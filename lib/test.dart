import 'dart:io' as io;
import 'dart:math';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

class TestApp extends StatefulWidget {
  @override
  _TestAppState createState() => new _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin audio recorder'),
        ),
        body: new AppBody(),
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AppBody({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new AppBodyState();
}

class AppBodyState extends State<AppBody> {
  Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  TextEditingController _controller = new TextEditingController();
  bool playButtonVisible = false;

  File file;

  @override
  initState() {
    askPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new FlatButton(
                onPressed: _isRecording ? null : _start,
                child: new Text("Start"),
                color: Colors.green,
              ),
              new FlatButton(
                onPressed: _isRecording ? _stop : null,
                child: new Text("Stop"),
                color: Colors.red,
              ),
              Visibility(
                visible: playButtonVisible,
                child: new FlatButton(
                  onPressed: _saveFile,
//                  _play,
                  child: new Text("Play"),
                  color: Colors.red,
                ),
              ),
//              new Text("File path of the record: ${_recording.path}"),
//              new Text("Format: ${_recording.audioOutputFormat}"),
//              new Text("Extension : ${_recording.extension}"),
//              new Text(
//                  "Audio recording duration : ${_recording.duration.toString()}")
            ]),
      ),
    );
  }

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        if (_controller.text != null && _controller.text != "") {
          String path = _controller.text;
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
          _isRecording = isRecording;
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
      _isRecording = isRecording;
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

    StorageUploadTask storageUploadTask = ref.child("image1.jpg").putFile(file);

    if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
      final String url = await ref.getDownloadURL();
      print("The download URL is " + url);
    } else if (storageUploadTask.isInProgress) {

      storageUploadTask.events.listen((event) {
        double percentage = 100 *(event.snapshot.bytesTransferred.toDouble()
            / event.snapshot.totalByteCount.toDouble());
        print("THe percentage " + percentage.toString());
      });

      StorageTaskSnapshot storageTaskSnapshot =await storageUploadTask.onComplete;
      String downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();

      //Here you can get the download URL when the task has been completed.
      print("Download URL " + downloadUrl1.toString());

    } else{
      //Catch any cases here that might come up like canceled, interrupted
    }
  }


}
