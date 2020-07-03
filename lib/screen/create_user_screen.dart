import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futsal_field_jepara/utils/constants.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:futsal_field_jepara/widget/text_field_custom.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _fireStore = Firestore.instance;
final FirebaseStorage _fireStorage = FirebaseStorage.instance;

enum TypeOperation {
  upload,
  download,
}

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  bool _isLoading = true;
  bool _isSuccess = true;
  String _userPhone = "";
  String _userUid;
  File _image;
  TypeOperation _typeOperation = TypeOperation.download;
  final _picker = ImagePicker();
  final _fullNameInputController = TextEditingController();
  final _emailInputController = TextEditingController();
  final _addressInputController = TextEditingController();

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _fullNameInputController.dispose();
    _emailInputController.dispose();
    _addressInputController.dispose();
    super.dispose();
  }

  Future<void> _getUserData() async {
    final user = await _auth.currentUser();

    setState(() {
      _userUid = user.uid;
      _userPhone = user.phoneNumber;
    });
  }

  Future<void> _getImageFromCamera() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.camera);

      setState(() {
        _image = File(pickedFile.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getImageFromGallery() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);

      setState(() {
        _image = File(pickedFile.path);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Complete your profile"),
          elevation: 0.0,
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildImageProfile(context),
                      TextFieldCustom(
                        title: "Full Name",
                        textEditingController: _fullNameInputController,
                      ),
                      TextFieldCustom(
                        title: "E-mail",
                        textEditingController: _emailInputController,
                      ),
                      TextFieldCustom(
                        title: "Address",
                        textEditingController: _addressInputController,
                      ),
                      _buildPhoneNumberUser(context),
                    ],
                  ),
                ),
              ],
            ),
            (_isLoading && _typeOperation == TypeOperation.upload)
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[900].withOpacity(0.8),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Container _buildPhoneNumberUser(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 100 * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Phone Number",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 100 * 5,
              fontWeight: FontWeight.bold,
              color: kTitleTextColor,
            ),
          ),
          Text(
            _userPhone,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 100 * 5,
              fontWeight: FontWeight.bold,
              color: kTitleTextColor,
            ),
          ),
          Text(
            "*phone number cannot be change.",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 100 * 3,
              fontWeight: FontWeight.bold,
              color: kRedColor,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 100 * 3,
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 100 * 7,
            padding:
                EdgeInsets.all(MediaQuery.of(context).size.height / 100 * 1),
            child: RaisedButton(
              onPressed: () {},
              color: kLogoLightGreenColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Simpan",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack _buildImageProfile(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            _showDialogTakePicture(context);
          },
          child: Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width / 100 * 5),
            width: MediaQuery.of(context).size.width / 100 * 40,
            height: MediaQuery.of(context).size.width / 100 * 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                image: _image == null
                    ? AssetImage("assets/ben-sweet-2LowviVHZ-E-unsplash.jpg")
                    : FileImage(_image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(90),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 7,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 100 * 25,
          bottom: MediaQuery.of(context).size.width / 100 * 5,
          child: FlatButton(
            onPressed: () {
              _showDialogTakePicture(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 100 * 12,
              height: MediaQuery.of(context).size.width / 100 * 12,
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: AssetImage("assets/camera-icon-55.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(90),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 7,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _showDialogTakePicture(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Ambil Gambar ?",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 100 * 5,
              color: kTitleTextColor,
            ),
          ),
          content: Container(
            child: Text("Pilih gambar dari galeri atau kamera."),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width / 100 * 3),
              child: FlatButton(
                onPressed: () {
                  _getImageFromCamera();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Pilih dari Kamera",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 100 * 5,
                    fontWeight: FontWeight.w600,
                    color: kBodyTextColor,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width / 100 * 3),
              child: FlatButton(
                onPressed: () {
                  _getImageFromGallery();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Pilih dari Galeri",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 100 * 5,
                    fontWeight: FontWeight.w600,
                    color: kBodyTextColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _uploadData(BuildContext context) async {
    if (_image == null) {
      Navigator.of(context).pop();
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Peringatan",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 5,
                color: kTitleTextColor,
              ),
            ),
            content: Container(
              child: Text("Anda belum mengambil gambar profil."),
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width / 100 * 3),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "ok",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 100 * 5,
                      fontWeight: FontWeight.w600,
                      color: kRedColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else if (_fullNameInputController.text.isEmpty) {
      Navigator.of(context).pop();
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Peringatan",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 5,
                color: kTitleTextColor,
              ),
            ),
            content: Container(
              child: Text("Anda belum mengisi nama lengkap."),
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width / 100 * 3),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "ok",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 100 * 5,
                      fontWeight: FontWeight.w600,
                      color: kRedColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else if (_emailInputController.text.isEmpty) {
      Navigator.of(context).pop();
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Peringatan",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 5,
                color: kTitleTextColor,
              ),
            ),
            content: Container(
              child: Text("Anda belum mengisi alamat email."),
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width / 100 * 3),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "ok",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 100 * 5,
                      fontWeight: FontWeight.w600,
                      color: kRedColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else if (_addressInputController.text.isEmpty) {
      Navigator.of(context).pop();
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Peringatan",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 5,
                color: kTitleTextColor,
              ),
            ),
            content: Container(
              child: Text("Anda belum mengisi alamat lengkap."),
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width / 100 * 3),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "ok",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 100 * 5,
                      fontWeight: FontWeight.w600,
                      color: kRedColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
    Navigator.of(context).pop();
    StorageReference _ref = _fireStorage
        .ref()
        .child("user-profile-$_userUid")
        .child("user-photo-$_userUid");
    StorageUploadTask _uploadTask = _ref.putFile(_image);
    StreamSubscription _streamSubscription =
        _uploadTask.events.listen((event) async {
      var eventType = event.type;
      if (eventType == StorageTaskEventType.progress) {
        setState(() {
          _typeOperation = TypeOperation.upload;
          _isLoading = true;
        });
      } else if (eventType == StorageTaskEventType.failure) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Photo failed to upload"),
          ),
        );
        setState(() {
          _isLoading = false;
          _isSuccess = false;
          _typeOperation = null;
        });
      } else if (eventType == StorageTaskEventType.success) {
        try {
          var downloadUrl = await event.snapshot.ref.getDownloadURL();
          var userData =
              await _fireStore.collection("users").document(_userUid).setData({
            'uid': _userUid,
            'name': _fullNameInputController.text,
            'email': _emailInputController.text,
            'phone': _userPhone,
            'address': _addressInputController.text,
            'imageProfile': downloadUrl.toString(),
          });
          ExtendedNavigator.ofRouter<Router>()
              .pushReplacementNamed(Routes.mainScreen);
          setState(() {
            _isLoading = false;
            _isSuccess = true;
            _typeOperation = null;
          });
        } catch (e) {
          print(e);
        }
      }
    });
    await _uploadTask.onComplete;
    _streamSubscription.cancel();
  }
}
