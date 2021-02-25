import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_connect/models/user.dart';
import 'package:social_connect/pages/activity_feed.dart';
import 'package:social_connect/pages/create_account.dart';
import 'package:social_connect/pages/profile.dart';
import 'package:social_connect/pages/search.dart';

import 'package:social_connect/pages/upload.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final DateTime timeStamp = DateTime.now();
AppUser currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
        // initialPage: 2
        );
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (error) {
      print('Error Signing in $error');
    });
    //Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError(
      (error) {
        print('Error Signing in $error');
      },
    );
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print('$account');
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(
        () {
          isAuth = false;
        },
      );
    }
  }

  //########### Adding User Data in Firestore ##############//

  createUserInFirestore() async {
    /*
    1. check if user exist in users collection in database according to their id
    2. if user doesnot exist, then we want to take them to the create acccount page
    3. get username from create account, use it to make new users document in users collection 
    */
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user.id).get();
    if (!doc.exists) {
      final username = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccount(),
        ),
      );
      usersRef.doc(user.id).set({
        'id': user.id,
        'username': username,
        'photoUrl': user.photoUrl,
        'displayName': user.displayName,
        'email': user.email,
        'bio': '',
        'timeStamp': timeStamp,
      });
      // getting the updated document of current user
      doc = await usersRef.doc(user.id).get();
    }
    // creating our own app user class and instantiating via factory constrctor
    currentUser = AppUser.fromDocument(doc);
    print(currentUser);
    print(currentUser.username);
  }

  login() async {
    await googleSignIn.signIn();
  }

  logout() async {
    await googleSignIn.signOut();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  void onTap(int pageIndex) {
    // pageController.jumpToPage(pageIndex);
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  Widget buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: [
          // Timeline(),
          RaisedButton(
            onPressed: logout,
            child: Text('Authenticated'),
          ),
          ActivityFeed(),
          Upload(currentUser: currentUser),
          Search(),
          Profile(profileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.whatshot,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_active,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 35.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
          ),
        ],
      ),
    );
    // return RaisedButton(
    //   onPressed: logout,
    //   child: Text('Authenticated'),
    // );
  }

  Widget buildUnAuthScreeen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Flutter Connect',
              style: TextStyle(
                fontSize: 80.0,
                fontFamily: 'Signatra',
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/google_signin_button.png'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreeen();
  }
}
