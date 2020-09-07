import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laugh/screens/home/home.dart';
import 'package:laugh/screens/laugh/laugh.dart';
import 'package:laugh/screens/uploads/upload.dart';
import 'package:laugh/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:laugh/models/user.dart';
import 'package:laugh/screens/laugh/your_laugh.dart';

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
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 190.0,
                    height: 190.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/profile.png"),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 32),
                child: Center(
                  child: Text(
                    email,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.yellow[800],
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ProfileOptionsWidget(
                icon: Icons.music_video,
                title: "Your Laugh",
                index: 0,
              ),
              Divider(),
              ProfileOptionsWidget(
                icon: Icons.notifications,
                title: "Notifications",
                index: 1,
              ),
              Divider(),
              ProfileOptionsWidget(
                icon: Icons.settings,
                title: "Settings",
                index: 2,
              ),
              Divider(),
              ProfileOptionsWidget(
                icon: Icons.payment,
                title: "Cards",
                index: 3,
              ),
              Divider(),
              ProfileOptionsWidget(
                icon: Icons.help,
                title: "Help & Feedback",
                index: 4,
              ),
            ],
          ),
        ),
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

class ProfileOptionsWidget extends StatelessWidget {
  const ProfileOptionsWidget({Key key, this.icon, this.title, this.index})
      : super(key: key);
  final IconData icon;
  final String title;
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.yellow,
      onTap: () {
        switch (index) {
          case 0:
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => YourLaugh()));
            break;
          case 1:
            print(index);
            break;
          case 2:
            print(index);
            break;
          case 3:
            print(index);
            break;
          case 4:
            print(index);
            break;
          default:
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 30,
              color: Colors.black54,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
