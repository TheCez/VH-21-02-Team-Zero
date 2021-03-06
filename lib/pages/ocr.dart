import 'dart:collection';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:image_picker/image_picker.dart';
import 'FirebaseApi.dart';

import 'dart:io';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> fetchData(String file_url) async {
  List<String> categories = [
    "Office Expense",
    "Meals & Entertainment",
    "Utilities",
    "Auto"
  ];
  // String ext = '.jpeg';
  // String image_path = '3' + ext;
  String file_name = basename(file_url.replaceAll('https://', ''));
  Map payload = new Map<String, dynamic>();
  payload = {
    "file_name": file_name,
    'file_url': file_url,
    'categories': categories
  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient
      .postUrl(Uri.parse('https://api.veryfi.com/api/v7/partner/documents/'));
  request.headers.set('content-type', 'application/json');
  request.headers.set('Accept', 'application/json');
  request.headers.set('CLIENT-ID', 'vrf0CTYwLUThSGf3gdwR82ediDePN5ieWc3PL2f');
  request.headers.set(
      'AUTHORIZATION', 'apikey jmane7738:66cb382e7f017dda471cc36deae7cf2f');
  request.add(utf8.encode(json.encode(payload)));
  HttpClientResponse response = await request.close();
  // todo - you should check the response.statusCode
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

dynamic _scanResults;
final TextRecognizer _recognizer = GoogleVision.instance.textRecognizer();

Future<void> scanImage(File imageFile) async {
  final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(imageFile);
  dynamic results;
  var c = 0;
  results = await _recognizer.processImage(visionImage);
  // print(results.blocks);
  for (final TextBlock block in results.blocks) {
    for (final TextLine line in block.lines) {
      // print(line.elements[0].text);
      for (final TextElement element in line.elements) {
        c += 1;
        print(element.text);
      }
      print(c);
      print('***************************************');
      c = 0;
      // stdout.write('\n');
    }
  }
}

Future<String> uploadFile(File image) async {
  String url;
  Reference ref =
      FirebaseStorage.instance.ref().child("images").child("xyz.jpg");
  await ref.putFile(image);

  url = await ref.getDownloadURL();
  return url;
}

Future<void> uploadData(var data) async {
  dynamic month = {
    '01': '01Janauary',
    '02': '02February',
    '03': '03March',
    '04': '04April',
    '05': '05May',
    '06': '06June',
    '07': '07July',
    '08': '08August',
    '09': '09September',
    '10': '10October',
    '11': '11November',
    '12': '12December'
  };
  var user = FirebaseAuth.instance.currentUser!.uid;
  var date = data["date"] == "" ? data["created"] : data["date"];
  //  await FirebaseFirestore.instance
  //               .collection(user).doc(month[date.substring(5,7)] + date.substring(0,5));
  for (int i = 0; i < data["line_items"].length; i++) {
    await FirebaseFirestore.instance
        .collection(user)
        .doc(month[date.substring(5, 7)] + date.substring(0, 5))
        .collection("categories")
        .doc(data["line_items"][i]["type"])
        .collection("items")
        .doc(data["line_items"][i]["description"])
        .set({
      'id': data["line_items"][i]["id"],
      'tax': data["line_items"][i]["tax"],
      'total': data["line_items"][i]["total"],
      'discount': data["line_items"][i]["discount"],
      'vendor': data["vendor"]["name"],
      'currency_code': data["currency_code"]
    });

    await FirebaseFirestore.instance
        .collection("category")
        .doc(data["line_items"][i]["type"]);
  }
}

Future<void> monthlyAnalysis() async {
  var user = FirebaseAuth.instance.currentUser!.uid;

  FirebaseFirestore.instance
      .collection(user)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc);
    });
  });
}

// Future<void> analysis() async {

// }




// import 'dart:collection';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_ml_vision/google_ml_vision.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:image_picker/image_picker.dart';
// import 'FirebaseApi.dart';

// import 'dart:io';
// import 'dart:io' as io;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_core/firebase_core.dart' as firebase_core;
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';
// Future<String> fetchData(String file_url) async {
//   // final response = await http.get(
//   //   Uri.parse('https://api.veryfi.com/api/v7/partner/documents/'),
//   //   // Send authorization headers to the backend.
//   //   headers: {
//   //     // HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
//   //     // HttpHeaders.clie
//   //     "Content-Type": "application/json",
//   //     "Accept": "application/json",
//   //     "CLIENT-ID": 'vrf0CTYwLUThSGf3gdwR82ediDePN5ieWc3PL2f',
//   //     "AUTHORIZATION": "apikey jmane7738:66cb382e7f017dda471cc36deae7cf2f"
//   //   },
//   // );

//   List<String> categories = [
//     "Office Expense",
//     "Meals & Entertainment",
//     "Utilities",
//     "Auto"
//   ];
//   // String ext = '.jpeg';
//   // String image_path = '3' + ext;
//   String file_name =basename(file_url.replaceAll('https://', ''));
//   Map payload = new Map<String, dynamic>();
//   payload = {
//     "file_name": file_name,
//     'file_url': file_url,
//     'categories': categories
//   };
//   HttpClient httpClient = new HttpClient();
//   HttpClientRequest request = await httpClient.postUrl(Uri.parse('https://api.veryfi.com/api/v7/partner/documents/'));
//   request.headers.set('content-type', 'application/json');
//   request.headers.set('Accept', 'application/json');
//   request.headers.set('CLIENT-ID', 'vrf0CTYwLUThSGf3gdwR82ediDePN5ieWc3PL2f');
//   request.headers.set('AUTHORIZATION', 'apikey jmane7738:66cb382e7f017dda471cc36deae7cf2f');
//   request.add(utf8.encode(json.encode(payload)));
//   HttpClientResponse response = await request.close();
//   // todo - you should check the response.statusCode
//   String reply = await response.transform(utf8.decoder).join();
//   httpClient.close();
//   return reply;
// }

// // firebase_storage.FirebaseStorage storage =
// //   firebase_storage.FirebaseStorage.instance;
// // firebase_storage.Reference ref =
// //   firebase_storage.FirebaseStorage.instance.ref('/notes.txt');

// // import 'package:open_file/open_file.dart';

// dynamic _scanResults;
// final TextRecognizer _recognizer = GoogleVision.instance.textRecognizer();

// Future<void> scanImage(File imageFile) async {
//   // final byteData = await rootBundle.load('images/1.jpeg');
//   // File file=File()
//   // setState(() {
//   //   _scanResults = null;
//   // });
//   // final file = File('${(await getTemporaryDirectory()).path}/images/1.jpeg');
//   // await file.writeAsBytes(byteData.buffer
//   //     .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

//   final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(imageFile);
//   dynamic results;
//   var c = 0;
//   results = await _recognizer.processImage(visionImage);
//   // print(results.blocks);
//   for (final TextBlock block in results.blocks) {
//     for (final TextLine line in block.lines) {
//       // print(line.elements[0].text);
//       for (final TextElement element in line.elements) {
//         c += 1;
//         print(element.text);
//       }
//       print(c);
//       print('***************************************');
//       c = 0;
//       // stdout.write('\n');
//     }
//   }
// }
// // var task;
// // Future uploadFile(File file) async {
// //     if (file == null) return;

// //     final fileName = basename(file!.path);
// //     final destination = 'files/$fileName';

// //     task = FirebaseApi.uploadFile(destination, file!);

// //     if (task == null) return;

// //     final snapshot = await task!.whenComplete(() {});
// //     final urlDownload = await snapshot.ref.getDownloadURL();

// //     print('Download-Link: $urlDownload');
// //   }

// Future<String> uploadFile(File image) async {
//   String url;
//   Reference ref =
//       FirebaseStorage.instance.ref().child("images").child("xyz.jpg");
//   await ref.putFile(image);

//   url = await ref.getDownloadURL();
//   return url;
// }




// // Future uploadImageToFirebase(File imageFile) async {
// //   String fileName = basename(imageFile.path);
// //   firebase_storage.Reference firebaseStorageRef =
// //       FirebaseStorage.instance.ref().child('uploads/$fileName');
// //   firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
// //   firebase_storage.TaskSnapshot taskSnapshot = await uploadTask.;
// //   taskSnapshot.ref.getDownloadURL().then(
// //         (value) => print("Done: $value"),
// //       );
// // }
// // var fileUrl = "";
// // var dowurl = "";

// // Future<void> uploadImageToFirebase(String filePath) async {
// //   File file = File(filePath);

// //   try {
// //     await firebase_storage.FirebaseStorage.instance
// //         .ref('uploads/file-to-upload.png')
// //         .putFile(file);
// //   } on firebase_core.FirebaseException catch (e) {
// //     // e.g, e.code == 'canceled'
// //   }
// //   // String downloadURL = await firebase_storage.FirebaseStorage.instance
// //   //     .ref('uploads/file-to-upload.png')
// //   //     .getDownloadURL();
// //   // print(downloadURL);
// // }

// // Future<void> downloadURLExample() async {
// //   String downloadURL = await firebase_storage.FirebaseStorage.instance
// //       .ref('uploads/file-to-upload.png')
// //       .getDownloadURL().then((value) => value.toString());

// //   // Within your widgets:
// //   // Image.network(downloadURL);
// // }

// //downloadURLExample(File file) async {
//   //print("sad1"+fileUrl);
//   // final _firebaseStorage = FirebaseStorage.instance;
//   //   var snapshot = await _firebaseStorage
//   //       .ref()
//   //       .child(
//   //           'patients/${FirebaseAuth.instance.currentUser!.uid}/${Path.basename(file.path)}')
//   //       .putFile(file);
//   //   fileUrl = await snapshot.ref.getDownloadURL();
//   //   print(fileUrl);

// //

// // Future uploadFile() async {
// //   final filename = basename(file!.path);
// //   final destination = 'files/'
// // }

// // uploadImageToFirebase(String imagePath) async {
// //  await FirebaseStorage.instance
// //   .ref(imagePath)
// //   .putFile(File(imagePath))
// //   .then((taskSnapshot) {
// // print("task done");

// // // download url when it is uploaded
// // if (taskSnapshot.state == TaskState.success) {
// //   FirebaseStorage.instance
// //       .ref(imagePath)
// //       .getDownloadURL()
// //       .then((url) {
// //     print("Here is the URL of Image $url");
// //     return url;
// //   }).catchError((onError) {
// //     print("Got Error $onError");
// //   });
// // }
// // });
// // }

// //  void uploadImageToFirebase(File imageFile) {
// //   FirebaseStorage storage = FirebaseStorage.instance;
// //   Reference ref = storage.ref().child("image1" + DateTime.now().toString());
// //   UploadTask uploadTask = ref.putFile(imageFile);
// //   uploadTask.then((res) {
// //     res.ref.getDownloadURL();
// //   print(res);
// //   });
// // }

// // Future uploadImageToFirebase(File imageFile) async {
// //   String fileName = basename(imageFile!.path);
// //   firebase_storage.Reference ref =
// //   firebase_storage.FirebaseStorage.instance
// //       .ref().child('uploads').child('/$fileName');

// //   final metadata = firebase_storage.SettableMetadata(
// //       contentType: 'image/jpeg',
// //       customMetadata: {'picked-file-path': fileName});
// //   firebase_storage.UploadTask uploadTask;
// //   //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
// //   uploadTask = ref.putFile(io.File(imageFile!.path)!, metadata);

// //   firebase_storage.UploadTask task= await Future.value(uploadTask);
// //   Future.value(uploadTask).then((value) async =>  {
// //     // fileUrl = await value.ref.getDownloadURL(),
// //     // print(fileUrl),

// //     //  dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
// //     // url = dowurl.toString();
// //      //fileUrl = await snapshot.ref.getDownloadURL();
// //   print("Upload file path ${value.ref.fullPath}")
// //   }).onError((error, stackTrace) => {
// //     print("Upload file path error ${error.toString()} ")
// //   });

// // }

// // class OCR extends StatelessWidget {
// //   const OCR({Key? key, @required this.img}) : super(key: key);
// //   final img;
// //   // final image = File(img);
// //   // print(img);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Text(img),
// //             // Image.network(img),
// //             Image.file(File(img))
// //             // Container(
// //             //   padding: const EdgeInsets.all(1.0),
// //             //   decoration: BoxDecoration(
// //             //       color: Colors.white,
// //             //       image: DecorationImage(
// //             //           image: Image.file(File(imagePath)),
// //             // )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

