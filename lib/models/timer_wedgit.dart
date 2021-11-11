// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//This is Value Notifier .. used to notify controller Listener
//If TimerController change his value
class TimerController extends ValueNotifier<bool>{
  TimerController({bool isPlaying = true }) : super(isPlaying);

  void startTimer() {
    value = true;
  }

  void stopTimer() {
    value = false;
  }
}

class TimerWidget extends StatefulWidget {
   const TimerWidget({Key? key,required this.controller}) : super(key: key);

   final TimerController controller;

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = const Duration();
  Timer? timer;
  bool isCountdown = true;
  //static const countdownDuration = Duration(minutes: 10);
  // --------
  @override
  void initState() {
    super.initState();
    // i commented this Listener as not listen to value of the controller if used Ternary Operator to show/hide the Timer Widget in RecordSection

    // widget.controller.addListener(() {
    //   if(widget.controller.value){startTimer();
    //   }else{stopTimer();}
    // });
    print('from initState() : Timer Start !! ');
    startTimer();
  }

  @override
  void dispose() {
    print('from dispose() : Timer Stopped !!');
    super.dispose();
    stopTimer();
  }

  void addTime() {
  const addSeconds = 1;
  setState(() {
    final seconds = duration.inSeconds + addSeconds;
    if (seconds < 0 ){timer?.cancel();} // if timer is count down
    duration = Duration(seconds: seconds);
  });
  }

  void startTimer({bool resets = true}){
    if(!mounted) return ;
    if (resets){
      reset();
    } // to reset timer every time
    timer = Timer.periodic(const Duration(seconds: 1),(_)=> addTime());
  }

  void stopTimer({bool resets = true}){
    if(!mounted) return ;
    if (resets){
      reset();
    } // to reset timer every time
    // setState(() {
    //   timer?.cancel();
    // }); used setState here to update ui and reset to 00:00
    timer?.cancel();

  }

  void reset(){
    // if (isCountdown){
    //   setState(() {
    //     duration =countdownDuration;
    //   });
    // }else{
    //   setState(() {
        duration = const Duration();
    //   });
    // }

  }

  @override
  Widget build(BuildContext context) {
    return buildTime();
  }

  Widget buildTime() {
    // make text 9 >>> 09 && 11 >> 11
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      '$minutes:$seconds',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 50,
        fontWeight: FontWeight.bold
      ),
    );
  }
}
