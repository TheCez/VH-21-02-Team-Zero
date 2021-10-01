import 'dart:io';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';


dynamic _scanResults;
final TextRecognizer _recognizer = GoogleVision.instance.textRecognizer();


Future<void> scanImage(File imageFile) async {
  // final byteData = await rootBundle.load('images/1.jpeg');
  // File file=File()
  // setState(() {
  //   _scanResults = null;
  // });
  // final file = File('${(await getTemporaryDirectory()).path}/images/1.jpeg');
  // await file.writeAsBytes(byteData.buffer
  //     .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

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

// class OCR extends StatelessWidget {
//   const OCR({Key? key, @required this.img}) : super(key: key);
//   final img;
//   // final image = File(img);
//   // print(img);


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(img),
//             // Image.network(img),
//             Image.file(File(img))
//             // Container(
//             //   padding: const EdgeInsets.all(1.0),
//             //   decoration: BoxDecoration(
//             //       color: Colors.white,
//             //       image: DecorationImage(
//             //           image: Image.file(File(imagePath)),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
// }
