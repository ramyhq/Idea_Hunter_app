// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:idea_hunter/models/category_slid_cards.dart';
import 'package:idea_hunter/provider/is_recording_provider.dart';
import 'package:idea_hunter/ui/mini_screens/record_main_screen.dart';
import 'package:provider/provider.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key, required this.afterSave}) : super(key: key);
  final Function afterSave;

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    bool isRecording =
        Provider.of<IsRecording>(context, listen: true).getIsRecordingState();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
          hasScrollBody: false,
                child: Container(
                  decoration:  BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black87,
                          Colors.black87,
                        ],
                        begin: FractionalOffset(0.0, 1.0),
                        end: FractionalOffset(0.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: h / 16,),
                      SizedBox(
                        height: isRecording ? 0 : h / 4,
                        child: isRecording ? Container(height: 0,) : CategorySlidCards(),
                      ),
                      SizedBox(height: h / 32,),
                      RecordSection(
                        afterSave: widget.afterSave,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
