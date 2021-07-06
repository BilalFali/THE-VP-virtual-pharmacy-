import 'package:flutter/material.dart';
import 'package:the_vp/models/medicine.dart';
import 'package:the_vp/utils/textstyles.dart';
import 'package:the_vp/utils/tools.dart';

class MedDetails extends StatelessWidget {
  final Medicine medDetails;

  MedDetails({@required this.medDetails});

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Tools.secondColor, //change your color here
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: sizew,
                height: sizeh * 0.3,
                child: Image.network(
                  medDetails.medimage,
                  fit: BoxFit.fitWidth,
                )),
            SizedBox(
              height: 5,
            ),
            new Padding(
              padding: new EdgeInsets.only(top: sizeh / 20),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  infoChild(
                      sizew, "إسم الدواء :", medDetails.medname.toUpperCase()),
                  SizedBox(
                    height: 10,
                  ),
                  infoChild(sizew, "التصنيف :", medDetails.categorie_uid),
                  SizedBox(
                    height: 10,
                  ),
                  infoChild(sizew, "الكمية :", medDetails.medqt.toString()),
                  SizedBox(
                    height: 10,
                  ),
                  infoChild(sizew, "رقم الهاتف  :", "0555616312"),
                  new Padding(
                    padding: new EdgeInsets.only(top: sizeh / 30),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget infoChild(double width, String label, data) => Container(
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
        width: width * 0.8,
        height: 60,
        child: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Row(
            children: <Widget>[
              new SizedBox(
                width: width / 10,
              ),
              new Text(
                label,
                style: threeTS,
              ),
              new SizedBox(
                width: width / 20,
              ),
              new Text(
                data,
                style: oneTS,
              )
            ],
          ),
        ),
      );
}
