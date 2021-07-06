import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_vp/models/medicine.dart';

class MedicineProvider extends ChangeNotifier {
  List<Medicine> finalMedicinesList = [];

  final CollectionReference medeicinsDoc =
      FirebaseFirestore.instance.collection('medicines');

  Stream<QuerySnapshot> fetchnewMedicines() {
    return medeicinsDoc
        .orderBy('medname', descending: true)
        .limit(8)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchMedicines() {
    return medeicinsDoc.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return medeicinsDoc.doc(id).get();
  }

  Future<Medicine> getProductById(String id) async {
    var doc = await getDocumentById(id);
    return Medicine.fromMap(doc.data(), doc.id);
  }

  Future<void> addMed(
      context,
      File medimage,
      String _medimageUrl,
      String _medname,
      String _meddes,
      String _medqt,
      String _uid,
      String _phoneNumber,
      String _categorie_id) async {
    var storeImage = FirebaseStorage.instance.ref().child(medimage.path);
    var task = storeImage.putFile(medimage);
    _medimageUrl = await (await task).ref.getDownloadURL();
    return medeicinsDoc
        .add({
          'medname': _medname,
          'meddescription': _meddes,
          'medqt': int.parse(_medqt.toString()),
          'medimage': _medimageUrl,
          'meduid': _uid,
          'userphone': _phoneNumber,
          'categorie_id': _categorie_id,
        })
        .then((value) => _alertPressed(
            context, "تم إضافة الدواء بنجاح", "الرئيسية", AlertType.success))
        .catchError((error) => print("Failed to add Med: $error"));
  }

  Future<void> updateMed(
      context,
      File medimage,
      String _medimageUrl,
      String _medname,
      String _meddes,
      String _medqt,
      String _medid,
      String _categorie_id) async {
    var storeImage = FirebaseStorage.instance.ref().child(medimage.path);
    var task = storeImage.putFile(medimage);
    _medimageUrl = await (await task).ref.getDownloadURL();
    return medeicinsDoc
        .doc(_medid)
        .update({
          'medname': _medname,
          'meddescription': _meddes,
          'medqt': int.parse(_medqt.toString()),
          'medimage': _medimageUrl,
          'categorie_id': _categorie_id,
        })
        .then((value) => _alertPressed(context, "تم تحديث معلومات الدواء بنجاح",
            "الرئيسية", AlertType.success))
        .catchError((error) => print("Failed to add Med: $error"));
  }

  Future<void> removeMed(String id, String imgUrl) async {
    await medeicinsDoc.doc(id).delete();
    await FirebaseStorage.instance.refFromURL(imgUrl).delete();
    return;
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
