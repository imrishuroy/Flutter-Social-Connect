import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:social_connect/models/app_user.dart';
import 'package:social_connect/pages/edit_profile.dart';
import 'package:social_connect/pages/home.dart';
import 'package:social_connect/widgets/header.dart';

class Profile extends StatefulWidget {
  final String profileId;

  const Profile({Key key, this.profileId}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser?.id;

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
          margin: EdgeInsets.only(top: 4.0),
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

  editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(currentUserId: currentUserId),
      ),
    );
  }

  Container buildButton({String text, Function function}) {
    return Container(
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 200.0,
          height: 28.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }

  buildProfileButton() {
    // when viewing our own profile we should show edit profile button
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      // display edit profile button
      return buildButton(
        text: 'Edit Profile',
        function: editProfile,
      );
    }
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
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildCountColumn('posts', 0),
                            buildCountColumn('followers', 0),
                            buildCountColumn('following', 0),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildProfileButton(),
                          ],
                        ),
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
