import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_connect/models/app_user.dart';
import 'package:social_connect/pages/home.dart';
import 'package:social_connect/widgets/progress.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:geocoding/geocoding.dart';

class Upload extends StatefulWidget {
  final AppUser currentUser;

  const Upload({Key key, this.currentUser}) : super(key: key);
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File _image;
  final picker = ImagePicker();
  bool isUploading = false;
  String postId = Uuid().v4(); // by usinf uuid package
  // final Reference storageRef = FirebaseStorage.instance.ref();
  final Reference storageRef = FirebaseStorage.instance.ref();
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  // by using image_picker package
  handelTakePhoto() async {
    Navigator.of(context).pop();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(
      () {
        if (pickedImage != null) {
          _image = File(pickedImage.path);
        } else {
          print('Error picking image');
        }
      },
    );
  }

  handleChooseFromGallery() async {
    Navigator.of(context).pop();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(
      () {
        if (pickedImage != null) {
          _image = File(pickedImage.path);
        } else {
          print('Error picking image');
        }
      },
    );
  }

  selectImage(context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          'Pick an image',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              color: Colors.white,
              onPressed: handelTakePhoto,
              child: Text('Take a photo'),
            ),
            SizedBox(height: 10.0),
            RaisedButton(
              color: Colors.white,
              onPressed: handleChooseFromGallery,
              child: Text('Pick image from gallery'),
            ),
            SizedBox(height: 10.0),
            RaisedButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSplashScreen(context) {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/upload.svg',
            height: 260.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              color: Colors.deepOrange,
              //  onPressed: selectImage(context),
              onPressed: () {
                selectImage(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Upload Image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      _image = null;
    });
  }

// by using path provider package
  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(_image.readAsBytesSync());
    final compressedImage = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(
          imageFile,
          quality: 85,
        ),
      );
    setState(() {
      _image = compressedImage;
    });
  }

  Future<String> uploadImage(imageFile) async {
    final ref = storageRef.child('post').child('$postId.jpg');
    await ref.putFile(imageFile);
    final downloadUrl = await ref.getDownloadURL();
    return downloadUrl;

    // final uploadTask = storageRef.child('post_$postId.jpg').putFile(imageFile);
    // final storageSnap = await uploadTask.whenComplete;
    // await storageSnap.ge
    // await uploadTask.getDo
  }

  createPostInFirestore(
      {String mediaUrl, String location, String description}) async {
    postsRef
        .doc(widget.currentUser.id)
        .collection('usersPosts')
        .doc(postId)
        .set({
      'postId': postId,
      'ownerId': widget.currentUser.id,
      'username': widget.currentUser.username,
      'mediaUrl': mediaUrl,
      'description': description,
      'location': location,
      'timestamp': timeStamp,
      'likes': {}
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(_image);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text,
    );
    captionController.clear();
    locationController.clear();
    setState(() {
      _image = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

// getting location by using geolocator package
  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final placemarks = await GeocodingPlatform.instance
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
    print(completeAddress);
  }

  Widget buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white70,
        leading: IconButton(
          onPressed: clearImage,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Caption Post',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              'Post',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          isUploading ? linearProgress() : Text(''),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(_image),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                widget.currentUser.photoUrl,
              ),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: 'Write a caption',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Where was this photo taken?',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              color: Colors.blue,
              onPressed: () => getUserLocation(),
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
              label: Text(
                'User current location',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _image == null ? buildSplashScreen(context) : buildUploadForm();
  }
}
