import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';

class OCR extends StatelessWidget {
  const OCR({Key? key, @required this.img}) : super(key: key);
  final img;
  // final image = File(img);
  // print(img);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(img),
            // Image.network(img),
            Image.file(File(img))
            // Container(
            //   padding: const EdgeInsets.all(1.0),
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       image: DecorationImage(
            //           image: Image.file(File(imagePath)),
            // )
          ],
        ),
      ),
    );
  }
}
