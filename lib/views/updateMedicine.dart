import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_vp/utils/textstyles.dart';
import 'package:the_vp/utils/tools.dart';

class UpdateMedicine extends StatefulWidget {
  @override
  _UpdateMedicineState createState() => _UpdateMedicineState();
}

class _UpdateMedicineState extends State<UpdateMedicine> {
  final _formKey = GlobalKey<FormState>();
  String _chosenValue;
  final _medname = TextEditingController();
  final _meddes = TextEditingController();
  final _medqt = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  File medimage;
  String _medimageUrl;

  CollectionReference doc_ref =
      FirebaseFirestore.instance.collection("medicines");
  Future<void> addMed() async {
    var storeImage = FirebaseStorage.instance.ref().child(medimage.path);
    var task = storeImage.putFile(medimage);
    _medimageUrl = await (await task).ref.getDownloadURL();
    return doc_ref
        .add({
          'medname': _medname.text,
          'meddescription': _meddes.text,
          'medqt': int.parse(_medqt.text),
          'medimage': _medimageUrl,
          'meduid': user.uid,
          'userphone': user.phoneNumber,
          'categorie_id': _chosenValue,
        })
        .then((value) => Alert(
              context: context,
              type: AlertType.success,
              title: "تم إضافة الدواء بنجاح",
              buttons: [
                DialogButton(
                  child: Text(
                    "Home",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                )
              ],
            ).show())
        .catchError((error) => print("Failed to add Med: $error"));
  }

  _pickedImagefromcamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => medimage = File(pickedFile.path));
    } else {
      return null;
    }
  }

  _pickedImagefromgallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => medimage = File(pickedFile.path));
    } else {
      return null;
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('المعرض'),
                      onTap: () {
                        _pickedImagefromgallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('الكاميرا'),
                    onTap: () {
                      _pickedImagefromcamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference medCategoryDoc =
        FirebaseFirestore.instance.collection('mcategories');

    return Scaffold(
        appBar: AppBar(
          title: Text("إضافة دواء"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Container(
            decoration: BoxDecoration(
                color: Tools.greenColor1.withOpacity(0.4),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[a-zA-Z0-9]')),
                            ],
                            controller: _medname,
                            decoration: InputDecoration(
                              labelText: "(بالاتينية) الإسم ",
                            ),
                            keyboardType: TextInputType.name,
                            validator: (val) {
                              if (val.isEmpty) {
                                return '  يرجى إدخال الإسم';
                              }
                              return null;
                            },
                            onSaved: (val) {},
                          ),
                          TextFormField(
                            controller: _meddes,
                            decoration: InputDecoration(labelText: "الوصف "),
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val.isEmpty) {
                                return '  يرجى إدخال الوصف';
                              }
                              return null;
                            },
                            onSaved: (val) {},
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _medqt,
                            decoration: InputDecoration(labelText: "الكمية "),
                            validator: (val) {
                              if (val.isEmpty) {
                                return '  يرجى إدخال الكمية';
                              }
                              return null;
                            },
                            onSaved: (val) {},
                          ),
                          new StreamBuilder<QuerySnapshot>(
                              stream: medCategoryDoc.snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return const Center(
                                    child: const CupertinoActivityIndicator(),
                                  );

                                return new Container(
                                  padding: EdgeInsets.only(bottom: 16.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: new Row(
                                    children: <Widget>[
                                      new Expanded(
                                        flex: 4,
                                        child: new InputDecorator(
                                          decoration: const InputDecoration(
                                            //labelText: 'Activity',
                                            hintText: 'إختر التصنيف',
                                          ),
                                          isEmpty: _chosenValue == null,
                                          child: new DropdownButton(
                                            value: _chosenValue,
                                            isDense: true,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                _chosenValue = newValue;
                                              });
                                            },
                                            items: snapshot.data.docs.map(
                                                (DocumentSnapshot document) {
                                              return new DropdownMenuItem<
                                                      String>(
                                                  value:
                                                      document.get('nameCateg'),
                                                  child: new Container(
                                                    child: new Text(
                                                        document
                                                            .get('nameCateg'),
                                                        style: oneTS),
                                                  ));
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          InkWell(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: Container(
                                  width: 100,
                                  height: 100,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(),
                                  child: medimage != null
                                      ? Image.file(File(medimage.path))
                                      : Text("Tap Here"))),
                          SizedBox(
                            height: 80,
                          ),
                          ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(35, 8, 35, 8),
                              child: Text(
                                'التـالي',
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                addMed();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Tools.greenColor1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
