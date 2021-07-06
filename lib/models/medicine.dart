import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Medicine {
  final String meduid;
  final String medid;
  final String medname;
  final String meddescription;
  final int medqt;
  final String medimage;
  final String categorie_uid;

  Medicine({
    @required this.meduid,
    @required this.medid,
    @required this.medname,
    @required this.meddescription,
    @required this.medqt,
    @required this.medimage,
    @required this.categorie_uid,
  });

  Medicine.fromMap(Map snapshot, String id)
      : meduid = snapshot['meduid'] ?? '',
        medid = snapshot['medid'] ?? '',
        medname = snapshot['medname'] ?? '',
        meddescription = snapshot['meddescription'] ?? '',
        medqt = snapshot['medqt'] ?? '',
        medimage = snapshot['medimage'] ?? '',
        categorie_uid = snapshot['categorie_id'] ?? '';

  toJson() {
    return {
      meduid: meduid,
      medid: medid,
      medname: medname,
      meddescription: meddescription,
      medqt: medqt,
      medimage: medimage,
      categorie_uid: categorie_uid,
    };
  }
}
