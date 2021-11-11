
// ignore_for_file: avoid_unnecessary_containers, avoid_print, sized_box_for_whitespace

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:idea_hunter/provider/category_provider.dart';
import 'package:provider/provider.dart';


class CategorySlidCards extends StatefulWidget {
  const CategorySlidCards({Key? key}) : super(key: key);
  @override
  State<CategorySlidCards> createState() => _CategorySlidCardsState();
}
class _CategorySlidCardsState extends State<CategorySlidCards> {

  List<String> categoryProvider = [];
  int checkedIndex = 0;

  @override
  Widget build(BuildContext context) {
    categoryProvider = Provider.of<IdeaCategory>(context,listen: true).getCategoryNames();

    List<Widget> itemSliders = List.generate(
      categoryProvider.length,
          (index) {
        return categoryCard(index);
      },
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Column(
           mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height / 4,
                onPageChanged:(i , reason){
                  setState(() {
                    checkedIndex = i;
                    Provider.of<IdeaCategory>(context,listen: false).defaultCategoryNames = categoryProvider[i];
                  });
                },
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                scrollPhysics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                ),
              items: itemSliders,
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryCard(int i){
    bool isSelected = checkedIndex == i;
    return GestureDetector(
      onTap: ()  {
        print('user tab on ${categoryProvider[i]}');
        setState(() {
          checkedIndex = i;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // padding: EdgeInsets.all(5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: isSelected ? Colors.pink : const Color(0xffffda11),
          elevation: 7,
          child: Center(
            child: Text(
              categoryProvider[i],
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
