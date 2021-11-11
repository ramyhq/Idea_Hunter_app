// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:extended_tabs/extended_tabs.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:idea_hunter/models/dismiss_keyboard.dart';
import 'package:idea_hunter/provider/category_provider.dart';
import 'package:idea_hunter/provider/files_provder.dart';
import 'package:idea_hunter/provider/is_recording_provider.dart';
import 'package:idea_hunter/ui/home_screen.dart';
import 'package:idea_hunter/helpers/ads_manger.dart';
import 'package:idea_hunter/ui/mini_screens/listen_category_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async{

  //------- AdMobAds -----------
  WidgetsFlutterBinding.ensureInitialized();
  final adInitialize = MobileAds.instance.initialize();
  final adManger = AdsManager(initialization: adInitialize);
  // ------ Adding Firebase ------
  FirebaseApp app = await Firebase.initializeApp();
  print(app.name);
  //------- Firebase Crashlytics ------
  bool kDebugMode = false; //Toggle Crashlytics collection
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(false);
  }
 // to disable landscape rotate
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<IdeaCategory>(
          create: (BuildContext context) => IdeaCategory(),
        ),
        ChangeNotifierProvider<IsRecording>(
          create: (BuildContext context) => IsRecording(),
        ),
        ChangeNotifierProvider<GetIdeas>(
          create: (BuildContext context) => GetIdeas(),
        ),
        Provider.value(value: adManger), //------- AdMobAds -----------
      ],
      child: Main(),
    ),
  );

}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);
  @override
  State<Main> createState() => _MainState();
}
class _MainState extends State<Main> {
  //------- AdMobAds -----------
  BannerAd? _bottomBannerAd;
  bool isLoaded = false;
  late AdsManager adManager;

  void getBottomBannerAd(AdsManager adManager) {
    _bottomBannerAd = BannerAd(
      adUnitId: adManager.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isLoaded = true;
            print('Ad loaded to load: $isLoaded !!!!!!');
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          //ad.dispose();
          print('Ad failed to load: $error');
        },
      ),
    )..load();
  }

  Widget showAd() {
    return isLoaded
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffffda11), ),
              color: Color(0xffffda11),
            ),
            alignment: Alignment.center,
            height: _bottomBannerAd!.size.height.toDouble() ,
            width: _bottomBannerAd!.size.width.toDouble(),
            child: AdWidget(ad: _bottomBannerAd!),
          )
        : Container(
            color: Colors.black87,
            alignment: Alignment.center,
            width: double.infinity,
            height: 50,
          );
  }
//------- AdMobAds -----------

  @override
  void initState() {
    super.initState();
    getExternalStorageDirectory().then((value) {
      Provider.of<GetIdeas>(context, listen: false)
          .setIdeaHunterDirectory(value);
      //setState(() {});
    });
    //this was Crashlytics code for test ( not needed )
    //FirebaseCrashlytics.instance.crash();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//------- AdMobAds -----------
    adManager = Provider.of<AdsManager>(context);
    adManager.initialization.then((value) {
      getBottomBannerAd(adManager);
    });
    //------- AdMobAds -----------
  }

  @override
  void dispose() {
    super.dispose();
     Provider.of<GetIdeas>(context).ideaHunterDirectory!.delete();
     _bottomBannerAd!.dispose(); //------- AdMobAds -----------
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            bottomNavigationBar: showAd(),
            //drawerEnableOpenDragGesture: false, // this to prevent the default sliding behaviour
            // drawer: myDrawer(context),
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.black87,
              //shadowColor: Colors.white,
              title: TabBar(
                onTap: (index) {
                  // used cuz if cst was typing and KB is open and after clicked on tabs >> dismiss focus
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                isScrollable: false,
                unselectedLabelColor: Colors.white,
                labelColor: Color(0xFFffda11),
                indicatorColor: Color(0xFFffda11),
                tabs: [
                  Tab(text: 'Record'),
                  Tab(text: 'Ideas'),
                ],
              ),
            ),
            body: ExtendedTabBarView(
              dragStartBehavior: DragStartBehavior.down,
              physics: AlwaysScrollableScrollPhysics(),
              //physics: NeverScrollableScrollPhysics(),
              cacheExtent: 2,
              children: [
                RecordScreen(
                    afterSave: Provider.of<GetIdeas>(context).onRecordComplete),
                ListenCategory(),
                // IdeaListSection(
                //   ideas: ideas,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
