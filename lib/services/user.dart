import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserProvider extends ChangeNotifier {
  final CollectionReference userDoc =
      FirebaseFirestore.instance.collection('usersphone');
  Future<void> addphone(
    context,
    String _username,
    String _phoneNumber,
  ) async {
    return userDoc
        .add({
          'username': _username,
          'phone': _phoneNumber,
        })
        .then((value) => _alertPressed(
            context, "تم إضافة رقم الهاتف بنجاح", "حسابي", AlertType.success))
        .catchError((error) => print("Failed to add Med: $error"));
  }

  Future<void> updatephone(
    context,
    String _username,
    String _phoneNumber,
  ) async {
    return userDoc
        .add({
          'username': _username,
          'phone': _phoneNumber,
        })
        .then((value) => _alertPressed(
            context, "تم إضافة رقم الهاتف بنجاح", "حسابي", AlertType.success))
        .catchError((error) => print("Failed to add Med: $error"));
  }

  _alertPressed(context, String title, String btntitle, AlertType alerttype) {
    Alert(
      context: context,
      type: alerttype,
      title: title,
      buttons: [
        DialogButton(
          child: Text(
            btntitle,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
}
