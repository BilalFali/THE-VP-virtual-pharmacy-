import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:the_vp/models/category.dart';

class MedicineCategoryProvider extends ChangeNotifier {
  final Query<Map<String, dynamic>> medCategoryDoc =
      FirebaseFirestore.instance.collection('mcategories').orderBy('nameCateg');
  List<MedicineCategory> medCategoriesList = [];

  Future<List<MedicineCategory>> fetchCategories() async {
    var result = await medCategoryDoc.get();
    medCategoriesList = result.docs
        .map((doc) => MedicineCategory.fromMap(doc.data(), doc.id))
        .toList();
    return medCategoriesList;
  }

  Stream<QuerySnapshot> streamfetchCategories() {
    return medCategoryDoc.limit(8).snapshots();
  }

  Stream<QuerySnapshot> streamfetchAllCategories() {
    return medCategoryDoc.snapshots();
  }
}
