import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_connect/models/user.dart';
import 'package:social_connect/pages/home.dart';
import 'package:social_connect/widgets/header.dart';

class Profile extends StatefulWidget {
  final String profileId;

  const Profile({Key key, this.profileId}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 4.0,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  buildProfileButton() {
    return Text('Profile Button');
  }

  Widget buildProfileHeader() {
    return FutureBuilder(
      future: usersRef.doc(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        AppUser user = AppUser.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(
            16.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(
                      user.photoUrl,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildCountColumn('posts', 0),
                            buildCountColumn('followers', 0),
                            buildCountColumn('following', 0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildProfileButton(),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  user.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  user.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 2.0),
                child: Text(
                  user.bio,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context: context,
        title: 'Profile',
      ),
      body: ListView(
        children: [
          buildProfileHeader(),
        ],
      ),
    );
  }
}
