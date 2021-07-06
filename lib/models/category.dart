import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicineCategory {
  final String categ_id;
  final String nameCateg;
  final String imageCateg;

  MedicineCategory({
    @required this.categ_id,
    @required this.nameCateg,
    @required this.imageCateg,
  });
  MedicineCategory.fromMap(Map snapshot, String id)
      : categ_id = snapshot['id'] ?? '',
        nameCateg = snapshot['nameCateg'] ?? '',
        imageCateg = snapshot['imageCateg'] ?? '';

  toJson() {
    return {
      "id": categ_id,
      "nameCateg": nameCateg,
      "imageCateg": imageCateg,
    };
  }
}
