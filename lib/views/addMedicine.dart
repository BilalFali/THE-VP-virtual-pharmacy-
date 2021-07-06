import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_vp/services/medcine.dart';
import 'package:the_vp/utils/textstyles.dart';
import 'package:the_vp/utils/tools.dart';

class AddMedicine extends StatefulWidget {
  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final _formKey = GlobalKey<FormState>();
  String _chosenValue;
  final _medname = TextEditingController();
  final _meddes = TextEditingController();
  final _medqt = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  File medimage;
  String _medimageUrl;

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
    final mp = Provider.of<MedicineProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Tools.greenColor1,
          centerTitle: true,
          title: Text("إضافة دواء"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Container(
            decoration: BoxDecoration(
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
                          SizedBox(
                            height: 5,
                          ),
                          customNameTextFiled(1, _medname, "إسم الدواء"),
                          SizedBox(
                            height: 5,
                          ),
                          customTextFiled(3, _meddes, "وصف الدواء"),
                          SizedBox(
                            height: 5,
                          ),
                          customQTTextFiled(1, _medqt, "كمية الدواء"),
                          SizedBox(
                            height: 5,
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
                                          decoration: InputDecoration(
                                            focusColor: Tools.secondColor,
                                            hoverColor: Tools.secondColor,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Tools.secondColor,
                                              ),
                                            ),
                                            hintStyle: oneTS,
                                            hintText: 'إختر التصنيف',
                                          ),
                                          isEmpty: _chosenValue == null,
                                          child: new DropdownButton(
                                            value: _chosenValue,
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
                          SizedBox(
                            height: 8,
                          ),
                          InkWell(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    color: Tools.greenColor1.withOpacity(0.7),
                                  ),
                                  child: medimage != null
                                      ? Image.file(File(medimage.path))
                                      : Center(
                                          child: Text(
                                          "إضغط هنا لتحميل صورة الداوء",
                                          style: twoTS,
                                        )))),
                          SizedBox(
                            height: 40,
                          ),
                          ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(35, 8, 35, 8),
                              child: Text(
                                'إضافة الدواء',
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                mp.addMed(
                                    context,
                                    medimage,
                                    _medimageUrl,
                                    _medname.text,
                                    _meddes.text,
                                    _medqt.text,
                                    user.uid,
                                    user.phoneNumber,
                                    _chosenValue);
                              }
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(Size(
                                  MediaQuery.of(context).size.width * 0.6,
                                  MediaQuery.of(context).size.height * 0.06)),
                              textStyle:
                                  MaterialStateProperty.all<TextStyle>(twoTS),
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

  Widget customNameTextFiled(
      int maxline, TextEditingController controller, String hintName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
        ],
        cursorColor: Tools.greenColor2,
        style: oneTS,
        maxLines: maxline,
        controller: controller,
        decoration: InputDecoration(
            fillColor: Tools.whiteColor,
            filled: true,
            focusColor: Tools.secondColor,
            hoverColor: Tools.secondColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Tools.secondColor,
              ),
            ),
            labelText: hintName,
            labelStyle: oneTS),
      ),
    );
  }

  Widget customQTTextFiled(
      int maxline, TextEditingController controller, String hintName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        cursorColor: Tools.greenColor2,
        style: oneTS,
        maxLines: maxline,
        controller: controller,
        decoration: InputDecoration(
            fillColor: Tools.whiteColor,
            filled: true,
            focusColor: Tools.secondColor,
            hoverColor: Tools.secondColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Tools.secondColor,
              ),
            ),
            labelText: hintName,
            labelStyle: oneTS),
      ),
    );
  }

  Widget customTextFiled(
      int maxline, TextEditingController controller, String hintName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextField(
        cursorColor: Tools.greenColor2,
        style: oneTS,
        maxLines: maxline,
        controller: controller,
        decoration: InputDecoration(
            fillColor: Tools.whiteColor,
            filled: true,
            focusColor: Tools.secondColor,
            hoverColor: Tools.secondColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Tools.secondColor,
              ),
            ),
            labelText: hintName,
            labelStyle: oneTS),
      ),
    );
  }
}
