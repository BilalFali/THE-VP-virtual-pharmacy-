import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_vp/utils/tools.dart';

class MedOfCategory extends StatelessWidget {
  final String categ_id;
  final String categ_name;

  MedOfCategory({Key key, this.categ_id, this.categ_name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizew = MediaQuery.of(context).size.width;
    final sizeh = MediaQuery.of(context).size.height;

    Query<Map<String, dynamic>> doc_ref = FirebaseFirestore.instance
        .collection("medicines")
        .where("categorie_id", isEqualTo: categ_id);

    return Scaffold(
        backgroundColor: Tools.whiteColor,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              headingCover(sizeh),
              SizedBox(
                height: 3,
              ),
              StreamBuilder(
                  stream: doc_ref.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (!streamSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (streamSnapshot.hasError) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: streamSnapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return medCard(
                            streamSnapshot.data.docs[index]['medname'],
                            streamSnapshot.data.docs[index]['meddescription'],
                            streamSnapshot.data.docs[index]['medqt'],
                            streamSnapshot.data.docs[index]['medimage'],
                            sizew,
                            sizeh,
                          );
                        });
                  }),
            ])));
  }

  Widget headingCover(double sizeh) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: sizeh * 0.18,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: Tools.greenColor1,
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 80, right: 20),
            child: Text(
              categ_name,
              //textAlign: TextAlign.center,
              style: TextStyle(
                  color: Tools.whiteColor,
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold),
            ))
      ],
    );
  }

  Widget medCard(String medname, String meddescription, int medqt,
      String medimage, double sizew, double sizeh) {
    return InkWell(
        onTap: () {
          // Navigator.push(
          //    context,
          //MaterialPageRoute(
          // builder: (context) => RecipeDetails(),
          // ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: EdgeInsets.only(right: 8),
            width: sizew - 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Tools.greenColor2.withOpacity(0.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      medimage,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, right: 8, left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        medname,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        meddescription,
                        style: TextStyle(
                          color: Tools.secondColor,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Text(
                        medqt.toString(),
                        style: TextStyle(
                          color: Tools.secondColor,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget show_info(IconData icon, String info, Color c, double fz) {
    return Row(children: [
      Icon(
        icon,
        color: c,
        size: fz,
      ),
      SizedBox(
        width: 5,
      ),
      Text(
        info,
        style: TextStyle(
            color: c,
            fontSize: fz,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold),
      ),
    ]);
  }
}
