import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_vp/models/medicine.dart';
import 'package:the_vp/utils/textstyles.dart';
import 'package:the_vp/utils/tools.dart';

import 'MedicineDetails.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";
  List<Medicine> medicines;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            headingCover(),
            Container(
              width: MediaQuery.of(context).size.width - 25,
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<QuerySnapshot>(
                stream: (name != "" && name != null)
                    ? FirebaseFirestore.instance
                        .collection('medicines')
                        .where("medname", isGreaterThanOrEqualTo: name)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("medicines")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    medicines = snapshot.data.docs
                        .map((doc) => Medicine.fromMap(doc.data(), doc.id))
                        .toList();
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot data = snapshot.data.docs[index];
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width: MediaQuery.of(context).size.width - 25,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    color: Tools.greenColor1.withOpacity(0.5),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          data['medimage'],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(
                                        data['medname'],
                                        textScaleFactor: 1.5,
                                        style: oneTS,
                                      ),
                                      trailing: Text(
                                        data['medqt'].toString(),
                                        style: TextStyle(
                                            color: Tools.secondColor
                                                .withOpacity(0.8),
                                            fontSize: 20,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        data['categorie_id'],
                                        style: TextStyle(
                                            color: Tools.secondColor
                                                .withOpacity(0.8),
                                            fontSize: 11,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      selected: true,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MedDetails(
                                                medDetails: medicines[index]),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headingCover() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 70, 8, 2),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                ],
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x4437474F),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: "إبحث هنا",
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    right: 20,
                    top: 14,
                    bottom: 14,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
