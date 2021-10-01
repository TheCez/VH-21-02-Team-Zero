import 'package:buck_tracker/pages/ocr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'dart:io';

// import 'package:open_file/open_file.dart';
// import 'package:native_pdf_renderer/native_pdf_renderer.dart';

class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('GS SDK Flutter Demo'),
          ),
          body: MyScaffoldBody()),
    );
  }
}

class MyScaffoldBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      onPressed: () {
        FlutterGeniusScan.scanWithConfiguration({
          'source': 'camera',
          'multiPage': false,
        }).then((result) async {
          // String pdfUrl = result['pdfUrl'];
          print('Ajay');
          print(File(result['scans'][0]['enhancedUrl']));
          //scanImage(File(result['scans'][0]['enhancedUrl'].replaceAll("file://", '')));
          //uploadImageToFirebase(result['scans'][0]['enhancedUrl'].replaceAll("file://", ''));
          final ans = await uploadFile(File(result['scans'][0]['enhancedUrl'].replaceAll("file://", '')));
          print(ans.toString()+" abhishek ");
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => OCR(
          //         img: result['scans'][0]['enhancedUrl'].replaceAll("file://", ''),
          //       ),
          //     ));

          // pdfUrl.replaceAll("file://", '');
          // try {
          //   final document = await PdfDocument.openAsset(pdfUrl.replaceAll("file://", ''));
          //   final page = await document.getPage(1);
          //   final pageImage = await page.render(
          //       width: page.width,
          //       height: page.height,
          //       format: PdfPageFormat.JPEG);
          //   await page.close();
          //   print(pageImage);
          // } on PlatformException catch (error) {
          //   print(error);
          // }
          // print(pageImage);

          //   OpenFile.open(pdfUrl.replaceAll("file://", '')).then(
          //       (result) => debugPrint(pdfUrl),
          //       onError: (error) => displayError(context, error));
          // }, onError: (error) => displayError(context, error));
        });
      },
      child: Text("START SCANNING"),
    ));
  }

  void displayError(BuildContext context, PlatformException error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.message!)));
  }
}
