import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_vp/utils/textstyles.dart';
import 'package:the_vp/utils/tools.dart';

class InfoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tools.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headingCover(context),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 16),
              child: Text(
                "نحن هنا من أجلك :)",
                style: threeTS,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            infoCard(Tools.aboutapp, " حول التطبيق", 4),
            SizedBox(
              height: 25,
            ),
            socialMedia(),
          ],
        ),
      ),
    );
  }

  Widget headingCover(context) {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Tools.greenColor1.withOpacity(0.7),
            )),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Text(
              "معلومات حول التطبيق",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget infoCard(String infoText, String title, imageIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: oneTS,
            ),
          ),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    infoText,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget socialMedia() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "إتصل بي  على",
              style: oneTS,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FaIcon(
                FontAwesomeIcons.facebook,
                color: Tools.greenColor2,
              ),
              FaIcon(
                FontAwesomeIcons.twitter,
                color: Tools.greenColor2,
              ),
              FaIcon(
                FontAwesomeIcons.instagram,
                color: Tools.greenColor2,
              ),
              FaIcon(
                FontAwesomeIcons.globe,
                color: Tools.greenColor2,
              ),
            ],
          )
        ],
      ),
    );
  }
}
