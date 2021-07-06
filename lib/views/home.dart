import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_vp/models/category.dart';
import 'package:the_vp/models/medicine.dart';
import 'package:the_vp/services/category.dart';
import 'package:the_vp/services/google_signin.dart';
import 'package:the_vp/services/medcine.dart';
import 'package:the_vp/utils/textstyles.dart';
import 'package:the_vp/utils/tools.dart';

import 'MedicineDetails.dart';
import 'medicinesOfCategory.dart';
import 'categories.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<MedicineCategory> categories;
    final mcp = Provider.of<MedicineCategoryProvider>(context, listen: false);
    List<Medicine> medicines;
    final mp = Provider.of<MedicineProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: Tools.whiteColor,
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          headingCover(),
          Divider(
            color: Tools.secondColor.withOpacity(0.2),
            height: 3,
            thickness: 1,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 5, right: 10, bottom: 5, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "التصنيفات",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Cairo',
                    color: Tools.secondColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoriesPage(),
                      ),
                    );
                  },
                  child: Text(
                    "مشاهدة الكل",
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Cairo',
                      color: Tools.secondColor.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.only(right: 10),
              height: MediaQuery.of(context).size.height * 0.15,
              child: StreamBuilder(
                  stream: mcp.streamfetchCategories(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      categories = snapshot.data.docs
                          .map((doc) =>
                              MedicineCategory.fromMap(doc.data(), doc.id))
                          .toList();
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return medicineCategory(
                              categories[index].nameCateg,
                              categories[index].nameCateg,
                              categories[index].imageCateg,
                            );
                          });
                    } else {
                      return CircularProgressIndicator();
                    }
                  })),
          Divider(
            color: Tools.secondColor.withOpacity(0.2),
            height: 2,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Text(
              " أدوية أضيفت حديثا",
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'Cairo',
                color: Tools.secondColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: StreamBuilder(
                    stream: mp.fetchnewMedicines(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        medicines = snapshot.data.docs
                            .map((doc) => Medicine.fromMap(doc.data(), doc.id))
                            .toList();
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: medicines.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MedDetails(
                                          medDetails: medicines[index]),
                                    ),
                                  );
                                },
                                child: medCard(
                                  medicines[index].medid,
                                  medicines[index].medname.toUpperCase(),
                                  medicines[index].categorie_uid,
                                  medicines[index].medimage,
                                  medicines[index].medqt,
                                ),
                              );
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Text(
              "أدوية متنوعة",
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'Cairo',
                color: Tools.secondColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: StreamBuilder(
                    stream: mp.fetchMedicines(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        medicines = snapshot.data.docs
                            .map((doc) => Medicine.fromMap(doc.data(), doc.id))
                            .toList();
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: medicines.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MedDetails(
                                          medDetails: medicines[index]),
                                    ),
                                  );
                                },
                                child: medCard(
                                  medicines[index].medid,
                                  medicines[index].medname.toUpperCase(),
                                  medicines[index].categorie_uid,
                                  medicines[index].medimage,
                                  medicines[index].medqt,
                                ),
                              );
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })),
          )
        ])));
  }

  Widget headingCover() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 70, 8, 2),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: Text("إمنح دواء و ساهم في علاج المرضى", style: oneTS)),
            IconButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              color: Tools.redColor,
              iconSize: 30,
              icon: Icon(Icons.exit_to_app),
            )
          ],
        ),
      ),
    );
  }

  Widget medicineCategory(String id, String categname, String categimage) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MedOfCategory(categ_id: id, categ_name: categname),
                    ),
                  );
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: Tools.greenColor2,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Tools.whiteColor,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.network(
                              categimage,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        categname,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold),
                      ),
                    ])),
          )
        ],
      ),
    );
  }

  Widget medCard(
      String medid, String medname, String medCateg, String img, int medqt) {
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
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.height * 0.2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.height * 0.2,
                child: Image.network(
                  img,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: Text(medname, style: oneTS, textAlign: TextAlign.center),
              ),
              Text(
                medCateg,
                style: TextStyle(
                    color: Tools.secondColor.withOpacity(0.8),
                    fontSize: 11,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
