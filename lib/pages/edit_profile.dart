import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:social_connect/models/app_user.dart';
import 'package:social_connect/pages/home.dart';
import 'package:social_connect/widgets/progress.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  const EditProfile({Key key, this.currentUserId}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  AppUser user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    // getting current user document
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();
    user = AppUser.fromDocument(doc);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Display Name',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: 'Update display name',
          ),
        )
      ],
    );
  }

  Column buidBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Bio',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: 'Update Bio',
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: CachedNetworkImageProvider(
                            user.photoUrl,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            buildDisplayNameField(),
                            buidBioField(),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        child: Text(
                          'Update Profile',
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            label: Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18.0,
                              ),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
