// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_print

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idea_hunter/constants/size.dart';
import 'package:idea_hunter/models/global_finctions.dart';
import 'package:idea_hunter/models/ripple_animation.dart';
import 'package:idea_hunter/models/timer_wedgit.dart';
import 'package:idea_hunter/provider/is_recording_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:idea_hunter/provider/category_provider.dart';

class RecordSection extends StatefulWidget {
  const RecordSection({
    Key? key,
    required this.afterSave,
  }) : super(key: key);
  final Function afterSave;
  @override
  _RecordSectionState createState() => _RecordSectionState();
}

enum RecordingState { unset, set, recording, paused, stopped }
//
// //--------------Category DropDown -------
List<String> categoryProvider = ['General'];

class _RecordSectionState extends State<RecordSection> {
//-- variables ----------
  late FlutterAudioRecorder2 soundObj;
  final _textFieldcontroller = TextEditingController();
  TimerController timerController = TimerController();
  RecordingState recordingState = RecordingState.unset;
  double recordBtnSize = 70.0;
  IconData recordBtnIcon = Icons.mic;
  String recordingStateText = 'Hi :) ';

//-- Defaults ----------

  //String? defaultCategoryNames = 'General'; // for value
  String defaultRecordName = kNoName; // for value
  String renameRecordPath = '';
  String finalFilePath = "";
  bool isRenamed = false;
  bool isExistBeforeRecord = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    FlutterAudioRecorder2.hasPermissions.then(
      (hasPermissionValue) {
        if (hasPermissionValue!) {
          recordingState = RecordingState.set;
          recordBtnIcon = Icons.mic;
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timerController.dispose();
    recordingState = RecordingState.unset;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    // ---* Providers *----
    categoryProvider =
        Provider.of<IdeaCategory>(context, listen: true).getCategoryNames();
    bool isRecording =
        Provider.of<IsRecording>(context, listen: true).getIsRecordingState();

    // List<DropdownMenuItem<String>> categoryDropDownItems = categoryProvider
    //     .map(
    //       (String value) => DropdownMenuItem<String>(
    //         value: value,
    //         child: Text(value),
    //       ),
    //     )
    //     .toList();
//--------------Old Category DropDown end-------

    return Column(
      children: [
        isRecording
            ? Padding(
                padding: EdgeInsets.only(bottom: 200),
                child: TimerWidget(
                  controller: timerController,
                ),
              )
            : Container(),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: h / 2.0,
              height: 1,
              child: isRecording
                  ? RippleAnimatedButton(
                      child: Container(),
                    )
                  : Container(),
            ),
            MaterialButton(
              onPressed: () async {
                await _onRecordButtonPressed();
                setState(() {});
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Container(
                height: h / 6,
                width: h / 6,
                child: CircleAvatar(
                  backgroundColor: Color(0xffffda11),
                  child: Icon(
                    recordBtnIcon,
                    size: recordBtnSize,
                    color: Color(0xFF1F1300),
                  ),
                  radius: recordBtnSize,
                ),
              ),
            ),
          ],
        ),

        // ListTile(
        //   title: const Text('Idea Category :'),
        //   trailing: DropdownButton<String>(
        //     value: defaultCategoryNames,
        //     onChanged: (newValue) {
        //       setState(() {
        //         defaultCategoryNames = newValue;
        //         //print(defaultCategoryNames);
        //       });
        //     },
        //     items: categoryDropDownItems,
        //   ),
        // ),
        SizedBox(height: isRecording ? h / 8 : h / 32),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: w / 1.8,
                  child: Focus(
                    onFocusChange: (focus) {
                      // use it if you want to clear the text input if unFocused
                      //_textFieldcontroller.clear();
                    },
                    child: TextField(
                      controller: _textFieldcontroller,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _textFieldcontroller.clear();
                          },
                        ),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        // ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: " Name your Idea ?",
                        hintStyle: kHintStyle,
                        //labelText: " name your Idea ?",
                        //errorText: _numberInputIsValid ? null : 'Please enter an integer!',
                        alignLabelWithHint: false,
                        fillColor: Colors.black.withOpacity(0.1),
                        //labelStyle: kTextInputStyle,
                        filled: false,
                      ),
                      style: kTextInputStyle,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (val) {
                        //Fluttertoast.showToast(msg: 'You entered: ${int.parse(val)}')
                        defaultRecordName = val;
                      },
                      onChanged: (String val) {
                        // final v = int.tryParse(val);
                        // debugPrint('parsed value = $v');
                        // if (v == null) {
                        //   setState(() => _numberInputIsValid = false);
                        // } else {
                        //   setState(() => _numberInputIsValid = true);
                        // }
                        defaultRecordName = val;
                      },
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text("Discard", style: kDiscardButtonStyle),
                    onPressed: () async {
                      if (recordingState == RecordingState.stopped) {
                        await _discardRecording();
                        _textFieldcontroller.clear();
                        setState(() {});
                      }
                      _textFieldcontroller.clear();
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    child: Text(
                      "Save",
                      style: kSaveButtonStyle,
                    ),
                    onPressed: () async{
                      if (recordingState == RecordingState.stopped) {
                        await _saveRecording();
                        _textFieldcontroller.clear();
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
    );
  }

  // Used to rename files in the given path
  Future<void> renameFile() async {
    try {
      final file = File(finalFilePath);
      String compare1 = finalFilePath;
      String compare2 = renameRecordPath + defaultRecordName + '.aac';
      File newNamefile = File(compare2);
      if (await file.exists()) {
        // if user did't rename the record after stop recording
        if (compare1 == compare2) {
          print("User didn't Name the Record");
          isRenamed = true;
          return;
          //if user give name and delete it again
        } else if (defaultRecordName == '') {
          print("User change defaultRecordName to empty '' ");
          isRenamed = true;
          return;
          //if user give the record a name ...
        } else if (compare1 != compare2) {
          print("User change Name of the Record so Renamed it done ");
          print(compare2);
          if (await newNamefile.exists()) {
            showMySnackBar("This Name Exist, Try different name", context);
          } else {
            await file.rename(renameRecordPath + defaultRecordName + '.aac');
            isRenamed = true;
          }
        }
      }
    } catch (error) {
      print("Error from renameFile()" + error.toString());
    }
  }

  Future _onRecordButtonPressed() async {
    if (recordingState == RecordingState.set) {
      await _startRecording();
      timerController.startTimer();
      print('_startRecording is called 1');
    } else if (recordingState == RecordingState.recording) {
      await _stoppedRecording();
      timerController.stopTimer();
      print('_stoppedRecording is called 2');
      } else if (recordingState == RecordingState.stopped) {
      await _saveRecording();
          _textFieldcontroller.clear();
          setState(() {});
    } else if (recordingState == RecordingState.unset) {
      showMySnackBar('Allow Mic Permission form settings.', context);
    }
  }

// initialize the StoragePath and get permissions
  _initRecorderAndStorageCategory() async {
    Directory? storageDirectory;
    try {
      if (await requestPermission(Permission.storage)) {
        print('storage permission grated ');
        storageDirectory = await getExternalStorageDirectory();
        String folderPath = "";
        List<String> subFolders = storageDirectory!.path.split("/");
        for (int x = 1; x < subFolders.length; x++) {
          String folder = subFolders[x];
          if (folder != "Android") {
            folderPath += "/" + folder;
          } else {
            break;
          }
        }
        // Here we can choose storage location by category
        folderPath = folderPath +
            "/Idea Hunter/${Provider.of<IdeaCategory>(context, listen: false).defaultCategoryNames}";
        storageDirectory = Directory(folderPath);
      } else {
        showMySnackBar('Please allow Storage Permission settings.', context);
      }
      // create the storage folders
      if (!await storageDirectory!.exists()) {
        await storageDirectory.create(recursive: true);
      }
      if (await storageDirectory.exists()) {
        if (defaultRecordName == kNoName || defaultRecordName == '') {
          defaultRecordName = getDateTimeFormated();
        }
        renameRecordPath = storageDirectory.path + '/';
        finalFilePath =
            storageDirectory.path + '/' + defaultRecordName + '.aac';
        if (await File(finalFilePath).exists()) {
          showMySnackBar("Name Exist, Try different name ", context);
          isExistBeforeRecord = true;
        } else {
          soundObj = FlutterAudioRecorder2(finalFilePath,
              audioFormat: AudioFormat.AAC);
          await soundObj.initialized;
          isInitialized = true;
        }
      }
    } catch (e) {
      print('Error from Initialize to Record : $e');
      return false;
    }
  }

  // Start Record
  Future<void> _startRecording() async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      await _initRecorderAndStorageCategory();
      if (isInitialized) {
        await soundObj.start();
        //await soundObj.current(channel: 0);
        recordingState = RecordingState.recording;
        recordBtnIcon = Icons.stop;
        recordingStateText = 'Recording now ';
        Provider.of<IsRecording>(context, listen: false)
            .checkIsRecording(); // to tell recording is true
      }
    } else {
      showMySnackBar('Please allow Mic Permission settings.', context);
    }
  }

  // Stop Record
  _stoppedRecording() async {
    await soundObj.stop();
    recordingState = RecordingState.stopped;
    recordBtnIcon = Icons.save;
    recordingStateText = 'Idea Saved';
    Provider.of<IsRecording>(context, listen: false).checkIsRecording();
  }

  // discard record
  Future<void> _discardRecording() async {
    await deleteFile(finalFilePath);
    recordingState = RecordingState.set;
    recordBtnIcon = Icons.mic;
    defaultRecordName = kNoName;
    widget.afterSave();
  }

// Save Record
  Future<void> _saveRecording() async {
    await renameFile();
    if (isRenamed) {
      print("after Idea Renamed");
      defaultRecordName = kNoName;
      recordingState = RecordingState.set;
      recordBtnIcon = Icons.mic;
      showMySnackBar("Idea saved", context);
    }
    isRenamed = false;
    widget.afterSave();
  }
}
