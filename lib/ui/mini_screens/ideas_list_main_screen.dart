// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:idea_hunter/helpers/ads_manger.dart';
import 'package:idea_hunter/models/global_finctions.dart';
import 'package:provider/provider.dart';

class IdeaListSection extends StatefulWidget {
  IdeaListSection({
    Key? key,
    required this.ideas,
    this.title = 'Ideas',
  }) : super(key: key);

  List<String> ideas;
  final String title;

  @override
  _IdeaListSectionState createState() => _IdeaListSectionState();
}

enum ButtonAction {
  cancel,
  agree,
}

class _IdeaListSectionState extends State<IdeaListSection> {
  AudioPlayer audioPlayer = AudioPlayer();

  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  bool isPlayed = false ;
  int _selectedIndex = -1;
  int _currentIndex = -1;
  String ideaName = '';

  //------- AdMobAds -----------
  late List<Object> ideasWithAds;
  bool isLoaded = false;
  late AdsManager adManager ;

  void insertAdsInList(AdsManager adManger) {
    setState(() {
      for (int i = ideasWithAds.length; i >= 1; i -= 10) {
        ideasWithAds.insert(
          i,
          BannerAd(
            adUnitId: adManger.bannerAdUnitId,
            size: AdSize.fullBanner,
            request: AdRequest(),
            listener: BannerAdListener(
              onAdLoaded: (_) {
                setState(() {
                  isLoaded = true;
                  print('Ad loaded to load: $isLoaded !!!!!!');
                });
              },
              onAdFailedToLoad: (Ad ad, LoadAdError error) {
                ad.dispose();
                print('Ad failed to load: $error');
              },
            ),
          )..load(),
        );
      }
    });
  }

  Widget showAd(int listIndex) {
    BannerAd ad = ideasWithAds[listIndex] as BannerAd;
      return isLoaded
          ? Container(
        alignment: Alignment.center,
        child: Container(
            height: ad.size.height.toDouble() ,
            width: ad.size.width.toDouble() ,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffffda11), width: 3),
              color: Color(0xffffda11),
            ),
            child: AdWidget(ad: ad),
        ),
      )
          : Container(
        color: Colors.transparent,
        width: double.infinity,
        height: 60,
      );
  }
  //end------- Ads -----------

  //old method not working with inLine Ads
  // String getIdeaName(int i) {
  //   String ideaPath = widget.ideas[i];
  //   List<String> subFolders = ideaPath.split("/");
  //   for (int x = 1; x < subFolders.length; x++) {
  //     String folder = subFolders[x];
  //     if (folder.contains('.aac')) {
  //       ideaName = folder;
  //       break;
  //     }
  //   }
  //   return ideaName;
  // }

  String getIdeaName2(int i) {
    List<String> ideasNames = [];
    ideasWithAds.map((e) {
      ideasNames.add(e.toString());
    }).toList();

    String ideaPath = ideasNames[i];
    List<String> subFolders = ideaPath.split("/");
    for (int x = 1; x < subFolders.length; x++) {
      String folder = subFolders[x];
      if (folder.contains('.aac')) {
        ideaName = folder;
        break;
      }
    }
    return ideaName;
  }

  @override
  void initState() {
    super.initState();
    //------- Ads -----------
    ideasWithAds = List.from(widget.ideas);
    //end------- Ads -----------
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adManager = Provider.of<AdsManager>(context);
    adManager.initialization.then((value) {
      insertAdsInList(adManager);
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }


  Widget waiting(){
      Timer(Duration(seconds: 3),(){
      });
      return Column(
        children: [
          CircularProgressIndicator(),
          TextButton(
            child: Text('Back'),
            onPressed: (){
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return widget.ideas.isEmpty
        ? Center(child: waiting(),)
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.black87,
              automaticallyImplyLeading: true,
              title: Text(widget.title),
            ),
            backgroundColor: Colors.black87,
            body: SafeArea(
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: EdgeInsets.all(_w / 25),
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: ideasWithAds.length, // old : widget.ideas.length, -----------------
                  itemBuilder: (BuildContext context, int listIndex) {
                     if(ideasWithAds[listIndex] is String){
                      return AnimationConfiguration.staggeredList(
                        position: listIndex,
                        delay: Duration(milliseconds: 100),
                        child: SlideAnimation(
                          duration: Duration(milliseconds: 2500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: FadeInAnimation(
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: Duration(milliseconds: 2500),
                            child: Container(
                              margin:
                              EdgeInsets.symmetric(vertical: (_w / 22) / 2),
                              height: _w / 4.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(18)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 2.0,
                                    bottom: 2.0,
                                    left: 16.0,
                                    right: 2.0),
                                child: Card(
                                  elevation: 0.0,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(right: 10),
                                    title: Text(
                                      getIdeaName2(listIndex), // old : getIdeaName(listIndex)-----------------
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    trailing: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          color: Colors.pink,
                                          highlightColor: Color(0xffffda11),
                                          iconSize: 28,
                                          onPressed: () {
                                            _selectedIndex = listIndex;
                                            print(_selectedIndex);
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: Colors.black87,
                                                content: Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1),
                                                  child: Text(
                                                    'Do you want to delete ?',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                    //  style: dialogTextStyle,
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color:
                                                          Color(0xffffda11),
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                      'Agree',
                                                      style: TextStyle(
                                                          color: Colors.pink,
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.w800),
                                                    ),
                                                    onPressed: () {
                                                      deleteFile(widget.ideas[listIndex]);
                                                      widget.ideas.removeAt(listIndex);
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: _selectedIndex == listIndex
                                              ? _isPlaying
                                              ? Icon(Icons.stop)
                                              : Icon(Icons.play_arrow)
                                              : Icon(Icons.play_arrow),
                                          color: Colors.green, // if user listen to his idea will be grey
                                          highlightColor: Color(0xffffda11),
                                          iconSize: 22,
                                          onPressed: () {
                                            setState(() {
                                              _selectedIndex = listIndex;
                                            });
                                            // if no play
                                            if (!_isPlaying) {
                                              _onPlay(
                                                  filePath:
                                                  widget.ideas[listIndex],
                                                  index: listIndex);
                                              // if user press stop on same file
                                            } else if (_isPlaying &&
                                                _selectedIndex == _currentIndex) {
                                              _onStop();
                                              //if user press play on other file
                                            } else if (_isPlaying &&
                                                _selectedIndex != _currentIndex) {
                                              _onStop().then((value) {
                                                _onPlay(
                                                    filePath: widget.ideas
                                                        .elementAt(listIndex),
                                                    index: listIndex);
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    subtitle: Container(
                                      margin: EdgeInsets.only(top: 5.0),
                                      child: LinearProgressIndicator(
                                        minHeight: 5,
                                        backgroundColor: Colors.black,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.pink),
                                        value: _selectedIndex == listIndex
                                            ? _completedPercentage
                                            : 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }else {
                       return showAd(listIndex);
                     }
                  },
                ),
              ),
            ));
  }

  Future<void> _onStop() async {
    await audioPlayer.stop();
    await audioPlayer.release();
    setState(() {
      _selectedIndex = -1;
      _completedPercentage = 0.0;
      _isPlaying = false;
    });
  }

  Future<void> _onPlay({required String filePath, required int index}) async {
    if (!_isPlaying) {
      audioPlayer.play(filePath, isLocal: true);
      setState(() {
        _selectedIndex = index;
        _currentIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerCompletion.listen((_) {
        setState(() {
          _selectedIndex = -1;
          _currentIndex = -1;
          _completedPercentage = 0.0;
          _isPlaying = false;

        });
        //audioPlayer.release();
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

  // String _getDateFromFilePatah({required String filePath}) {
  //   String fromEpoch = filePath.substring(
  //       filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));
  //
  //   DateTime recordedDate =
  //   DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
  //   int year = recordedDate.year;
  //   int month = recordedDate.month;
  //   int day = recordedDate.day;
  //
  //   return ('$year-$month-$day');
  // }

}
