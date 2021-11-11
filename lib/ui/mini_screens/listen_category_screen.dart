// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors


import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:idea_hunter/models/expandable_header.dart';
import 'package:idea_hunter/provider/category_provider.dart';
import 'package:idea_hunter/provider/files_provder.dart';
import 'package:idea_hunter/ui/mini_screens/ideas_list_main_screen.dart';
import 'package:provider/provider.dart';


class ListenCategory extends StatefulWidget {
  const ListenCategory({Key? key}) : super(key: key);

  @override
  _ListenCategoryState createState() => _ListenCategoryState();
}

List<String> categoryProvider = [];

enum ButtonAction {
  cancel,
  agree,
}

class _ListenCategoryState extends State<ListenCategory> {
  final ScrollController _gridController = ScrollController();
  bool isBottom = false;

  @override
  void initState() {
    super.initState();

    
    //  controller Listener to check whether the page is
    //  at the bottom or top
    _gridController.addListener(
      () {
        // when scroll reached bottom
        if (_gridController.offset >=
                _gridController.position.maxScrollExtent &&
            !_gridController.position.outOfRange) {
          setState(() => isBottom = true);
        }

        // when scroll REACHED TOP
        if (_gridController.offset <=
                _gridController.position.minScrollExtent &&
            !_gridController.position.outOfRange) {
          setState(() => isBottom = false);
        }

        //IS SCROLLING
        // if (_gridController.offset >=
        //         _gridController.position.minScrollExtent &&
        //     _gridController.offset < _gridController.position.maxScrollExtent &&
        //     !_gridController.position.outOfRange) {
        //   setState(() {
        //     isBottom = false;
        //   });
        // }
      },
    );
  }


  @override
  void dispose() {
    super.dispose();
    _gridController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    categoryProvider =
        Provider.of<IdeaCategory>(context, listen: true).getCategoryNames();

    return DefaultBottomBarController(
      child: ExpandableHeader(
        body: Stack(
          children: [
            GridView.count(
              controller: _gridController,
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: List.generate(
                categoryProvider.length,
                (index) {
                  return Padding(
                    padding: EdgeInsets.all(11),
                    child: GestureDetector(
                      onTap: () async {
                        print('user tab on ${categoryProvider[index]}');
                          List<String> ideas = await Provider.of<GetIdeas>(context, listen: false).initIdeas2(categoryProvider[index]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IdeaListSection(
                                ideas: ideas,
                                title: categoryProvider[index],
                              ),
                            ),
                          );
                          //setState(() {});
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.black87,
                            content: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Text(
                                'Do you want to delete ?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                //  style: dialogTextStyle,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Color(0xffffda11),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, ButtonAction.cancel);
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  'Agree',
                                  style: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                                onPressed: () {
                                  Provider.of<IdeaCategory>(context,
                                          listen: false).deleteCategory(categoryProvider[index]);
                                  Navigator.pop(context, ButtonAction.agree);
                                  // setState(() {});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        color: Colors.pink,
                        elevation: 7,
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              categoryProvider[index],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            // ListTile(
                            //   title:
                            //   onLongPress: (){print('ddd');},
                            // ),
                            // ButtonBar(
                            //   children: <Widget>[
                            //     TextButton(
                            //       child: Text('Edit',
                            //           style: TextStyle(color: Colors.white)),
                            //       onPressed: () {},
                            //     ),
                            //     TextButton(
                            //       child: Text('Delete',
                            //           style: TextStyle(color: Colors.white)),
                            //       onPressed: () {},
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            isBottom
                ? Positioned(
                    bottom: 20,
                    left: MediaQuery.of(context).size.width / 2.5,
                    right: MediaQuery.of(context).size.width / 2.5,
                    child: Container(
                      //alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xffffda11),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: GestureDetector(
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 42,
                          ),
                          onPressed: () {
                            controller.swap();
                            isDown = !isDown;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

//  Container(
//   height: 400,
//   width: 300,
//   decoration: BoxDecoration(
//       color: Color(0xffFF5050),
//       borderRadius: BorderRadius.all(
//         Radius.circular(20),
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.2),
//           blurRadius: 20,
//           offset: Offset(0, 10),
//         )
//       ]),
//   child: Center(
//     child: Text(
//       'Card',
//       style: TextStyle(color: Colors.white, fontSize: 100),
//     ),
//   ),
// ),
