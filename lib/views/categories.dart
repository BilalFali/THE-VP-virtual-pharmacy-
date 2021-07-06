import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_vp/services/category.dart';
import 'package:the_vp/utils/tools.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final categP = Provider.of<MedicineCategoryProvider>(context);
    return Scaffold(
        backgroundColor: Tools.whiteColor,
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          headingCover(context),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: categP.fetchCategories(),
              builder: (context, snapshot) {
                return GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics:
                        ScrollPhysics(), // You won't see infinite size error
                    children:
                        List.generate(categP.medCategoriesList.length, (index) {
                      return category_Card(
                          categP.medCategoriesList[index].nameCateg,
                          categP.medCategoriesList[index].imageCateg);
                    }));
              },
            ),
          )
        ])));
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
        Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  " أصناف الأدويـة",
                  style: TextStyle(
                      color: Tools.whiteColor,
                      fontSize: 20,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget category_Card(String categ_name, String categ_icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Tools.greenColor1.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Tools.whiteColor,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    categ_icon,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              categ_name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
