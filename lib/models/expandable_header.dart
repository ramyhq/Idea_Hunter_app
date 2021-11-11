// ignore_for_file: prefer_const_constructors

import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:idea_hunter/constants/size.dart';
import 'package:idea_hunter/helpers/ads_manger.dart';
import 'package:idea_hunter/provider/category_provider.dart';
import 'package:provider/provider.dart';

late final BottomBarController controller;
final _textFieldcontroller = TextEditingController();
bool isDown = false;
String newIdeaCategoryName = kNoName;

class ExpandableHeader extends StatefulWidget {
  const ExpandableHeader({Key? key, required this.body}) : super(key: key);
  final Widget body;
  @override
  _ExpandableHeaderState createState() => _ExpandableHeaderState();
}

class _ExpandableHeaderState extends State<ExpandableHeader>
    with SingleTickerProviderStateMixin {

  // ----------- Start Admob Ads in Add Category section -----------
  BannerAd? _bottomBannerAd;
  bool isLoaded = false;
  late AdsManager adManager ;

  void getBottomBannerAd(AdsManager adManager) {
    _bottomBannerAd = BannerAd(
      adUnitId: adManager.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (_) {
          setState(() {
            isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _bottomBannerAd!.dispose();
          print('Ad failed to load: $error');
        },
      ),
    )..load();
  }

  Widget? showAd() {
    return isLoaded
        ? Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 2),
      ),
      //alignment: Alignment.center,
      height: _bottomBannerAd!.size.height.toDouble(),
      width: _bottomBannerAd!.size.width.toDouble() ,
      child: AdWidget(ad: _bottomBannerAd!),
    )
        : Container(
      width: double.infinity,
      height: 50,
    );
  }
// ----------- End Admob Ads in Add Category section -----------

  @override
  void initState() {
    super.initState();
    controller = BottomBarController(vsync: this, dragLength: 550, snap: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adManager = Provider.of<AdsManager>(context);
    adManager.initialization.then((value) {
      getBottomBannerAd(adManager);
    });
  }
  @override
  void dispose() {
    super.dispose();
    _textFieldcontroller.dispose();
    controller.dispose();
    _bottomBannerAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      /// Set to true for bottom appbar overlap body content
      extendBody: true,
      /// appBar: AppBar(
      /// title: Text("Panel Showcase"),
      ///  backgroundColor: Theme.of(context).bottomAppBarColor,
      /// ),
      /// Lets use docked FAB for handling state of sheet
      // floatingActionButton: GestureDetector(
      //   /// Set onVerticalDrag event to drag handlers of controller for swipe effect
      //   onVerticalDragUpdate: controller.onDrag,
      //   onVerticalDragEnd: controller.onDragEnd,
      //   child: FloatingActionButton.extended(
      //     label: Text("Pull up"),
      //     elevation: 2,
      //     backgroundColor: Colors.deepOrange,
      //     foregroundColor: Colors.white,
      //
      //     /// Set onPressed event to swap state of bottom bar
      //     onPressed: () => controller.swap(),
      //   ),
      // ),
      body: widget.body,
      /// Actual expandable bottom bar
      /// bottomNavigationBar: PreferredSize(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(controller.dragLength!),

        /// Size.fromHeight(controller.state.value * controller.dragLength),
        child: BottomExpandableAppBar(
          /// Provide the bar controller in build method or default controller as ancestor in a tree
          controller: controller,
          expandedHeight: MediaQuery.of(context).size.height / 3,
          horizontalMargin: 16,
          attachSide: Side.Top,
          expandedBackColor: Colors.pink,

          /// Your bottom sheet code here
          expandedBody: Consumer<IdeaCategory>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                reverse: true,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        child: showAd(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          controller: _textFieldcontroller,
                          decoration: const InputDecoration(
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            // ),
                            enabledBorder: InputBorder.none,
                            hintText: " New Category ... ",
                            //labelText: " name your Idea ?",

                            //errorText: _numberInputIsValid ? null : 'Please enter an integer!',
                            alignLabelWithHint: false,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.black87),
                            filled: true,
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (val) {
                            //Fluttertoast.showToast(msg: 'You entered: ${int.parse(val)}')
                            newIdeaCategoryName = val;
                          },
                          onChanged: (String val) {

                            newIdeaCategoryName = val;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonBar(
                              children: [
                                TextButton(
                                  child: const Text('Cancel',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                  onPressed: () {
                                    _textFieldcontroller.clear();
                                    controller.swap();
                                    FocusManager.instance.primaryFocus!
                                        .unfocus(); //to close KB
                                    isDown = !isDown;
                                    setState(() {});
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    'Add',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if(newIdeaCategoryName == kNoName){
                                      showMySnackBar('Enter name first ... ', context);
                                    }else{
                                      provider.addCategory(newIdeaCategoryName);
                                      _textFieldcontroller.clear();
                                      controller.swap();
                                      FocusManager.instance.primaryFocus!
                                          .unfocus(); //to close KB
                                      isDown = !isDown;
                                      setState(() {});
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          bottomAppBarBody: Padding(
            padding: const EdgeInsets.all(0.0),
            child: GestureDetector(
              child: Container(
                  width: double.infinity,
                  color: Colors.black87,
                  child: IconButton(
                    icon: isDown
                        ? Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                            size: 28,
                          )
                        : Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 28,
                          ),
                    onPressed: () {
                      controller.swap();
                      isDown = !isDown;
                      setState(() {});
                    },
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
