import 'dart:io';
//this is Global file for reusable Methods
import 'package:permission_handler/permission_handler.dart';


// to access file in path and delete it if exist
Future<void> deleteFile(String FilePath) async {
  try {
    final file = File(FilePath);
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    print(e);
  }
}

// this gets DateTime (Format)
String getDateTimeFormated() {
  DateTime recordedDate = DateTime.now();
  int year = recordedDate.year;
  int month = recordedDate.month;
  int day = recordedDate.day;
  int hour = recordedDate.hour;
  int minute = recordedDate.minute;
  int second = recordedDate.second;
  return ("$day-$month-$year(h${hour}m${minute}s${second})");
}


// Used To Ask for any kind of permissions (Global Usage)
Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    // var result = await permission.request(); REFACTOR>>
    if (await permission.request() == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}
