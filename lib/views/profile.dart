import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_vp/services/medcine.dart';
import 'package:the_vp/services/user.dart';
import 'package:the_vp/utils/textstyles.dart';
import 'package:the_vp/utils/tools.dart';
import 'package:the_vp/views/editMedicine.dart';

import 'MedicineDetails.dart';

class Profile extends StatelessWidget {
  final medP = MedicineProvider();

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width;
    final sizeh = MediaQuery.of(context).size.height;
    final user = FirebaseAuth.instance.currentUser;
    TextEditingController _phonecnt = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final up = Provider.of<UserProvider>(context, listen: false);
    Query<Map<String, dynamic>> doc_ref = FirebaseFirestore.instance
        .collection("medicines")
        .where("meduid", isEqualTo: user.uid);
    Query<Map<String, dynamic>> phoneRef = FirebaseFirestore.instance
        .collection("usersphone")
        .where("username", isEqualTo: user.displayName);
    return Scaffold(
        backgroundColor: Tools.whiteColor,
        body: (user != null)
            ? Padding(
                padding: const EdgeInsets.only(top: 80),
                child: profile(
                  context,
                  sizew,
                  sizeh,
                  _phonecnt,
                  _formKey,
                  up,
                  user.displayName,
                  user.phoneNumber,
                  "5",
                  user.photoURL,
                  phoneRef,
                  doc_ref,
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget profile(
      context,
      double _width,
      double _height,
      TextEditingController phonecnt,
      _formKey,
      up,
      String username,
      String userphone,
      String mednbr,
      String userimg,
      phoneRef,
      Query<Map<String, dynamic>> doc) {
    return Container(
      width: _width,
      height: _height,
      child: SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new CircleAvatar(
              backgroundImage: new NetworkImage(userimg),
              radius: _height / 12,
            ),
            new SizedBox(
              height: 10,
            ),
            infoChild(
              _width,
              username,
            ),
            new SizedBox(
              height: 10,
            ),
            StreamBuilder(
                stream: phoneRef.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot == null) {
                    return infoChildphone(
                        context, _formKey, up, username, phonecnt, _width);
                  } else if (!streamSnapshot.hasData) {
                    return infoChildphone(
                        context, _formKey, up, username, phonecnt, _width);
                  } else if (streamSnapshot.hasError) {
                    return infoChildphone(
                        context, _formKey, up, username, phonecnt, _width);
                  } else {
                    return infoChild(
                        _width, streamSnapshot.data.docs[0]['phone']);
                  }
                }),
            SizedBox(
              height: 10,
            ),
            new Padding(
              padding: new EdgeInsets.only(top: _height / 20),
              child: new Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, bottom: 5),
                    child: Text(
                      "الأدوية التي أضفتها ( ${mednbr} )",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Cairo',
                        color: Tools.secondColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: _height * 0.3,
                      child: StreamBuilder(
                          stream: doc.snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot == null) {
                              return Center(child: Text("لم تضف أي أدوية "));
                            }
                            if (!streamSnapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (streamSnapshot.hasError) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: streamSnapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return medCard(
                                    context,
                                    streamSnapshot.data.docs[index].id,
                                    streamSnapshot.data.docs[index]['medname'],
                                    streamSnapshot.data.docs[index]
                                        ['categorie_id'],
                                    streamSnapshot.data.docs[index]['medqt'],
                                    streamSnapshot.data.docs[index]['medimage'],
                                    _width,
                                    _height,
                                  );
                                });
                          }),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget medCard(context, String medid, String medname, String categ, int medqt,
      String medimage, double sizew, double sizeh) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Tools.whiteColor.withOpacity(0.7),
          boxShadow: [
            BoxShadow(
              color: Tools.secondColor.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        height: sizeh * 0.3,
        width: sizew * 0.4,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                height: sizeh * 0.15,
                width: sizew,
                child: Image.network(
                  medimage,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                  child:
                      Text(medname, style: oneTS, textAlign: TextAlign.center)),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      color: Tools.secondColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditMedicine(
                              chosenValue: categ,
                              medid: medid,
                              medname: medname,
                              medimageUrl: medimage,
                              medqt: medqt.toString(),
                            ),
                          ),
                        );
                      },
                      icon: FaIcon(FontAwesomeIcons.edit),
                    ),
                    ElevatedButton.icon(
                      label: Text(''),
                      onPressed: () => {
                        _showDialog(context, medname, medid, medimage)
                        //_prss(medname, medid, medimage)
                      },
                      icon: FaIcon(FontAwesomeIcons.trash),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context, medname, medid, medimage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            buttonPadding: EdgeInsets.all(5),
            titleTextStyle: oneTS,
            title: Text("تحذير"),
            content: Text(
              " هل تريد بالفعل حذف  : " + medname,
              style: oneTS,
            ),
            actionsPadding: EdgeInsets.only(left: 90),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Tools.redColor)),
                  onPressed: () {
                    medP.removeMed(medid, medimage);
                  },
                  child: Text(
                    "نعم, حذف",
                    style: twoTS,
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget headerChild(String header, String value) => new Expanded(
          child: new Column(
        children: <Widget>[
          new Text(
            header,
            style: new TextStyle(
                fontSize: 14.0,
                fontFamily: "Cairo",
                color: Tools.secondColor,
                fontWeight: FontWeight.bold),
          ),
          new SizedBox(
            height: 8.0,
          ),
          new Text(
            value,
            style: new TextStyle(
                fontSize: 14.0,
                fontFamily: "Cairo",
                color: Tools.greenColor2,
                fontWeight: FontWeight.bold),
          )
        ],
      ));

  Widget infoChild(double width, data) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Tools.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Tools.secondColor.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        width: width * 0.6,
        height: 60,
        child: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: Center(
            child: new Text(
              data,
              style: threeTS,
            ),
          ),
        ),
      );

  Widget infoChildphone(context, _formKey, up, String useranme,
          TextEditingController phonecnt, double width) =>
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Tools.greenColor2,
            boxShadow: [
              BoxShadow(
                color: Tools.secondColor.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          width: width * 0.8,
          height: 60,
          child: new Padding(
              padding: new EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(oneTS),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Tools.greenColor2),
                      elevation: MaterialStateProperty.all<double>(0.0)),
                  onPressed: () {
                    return Alert(
                      context: context,
                      title: "إضافة رقم الهاتف",
                      content: Form(
                          key: _formKey,
                          child: customnbrextFiled(1, phonecnt, " رقم الهاتف")),
                      buttons: [
                        DialogButton(
                          child: Text(
                            "إضافة",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              up.addphone(context, useranme, phonecnt.text);
                            }
                          },
                          width: 120,
                        ),
                      ],
                    ).show();
                  },
                  icon: Icon(Icons.add),
                  label: Text("إضافة رقم الهاتف"))));

  Widget customnbrextFiled(
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
}
