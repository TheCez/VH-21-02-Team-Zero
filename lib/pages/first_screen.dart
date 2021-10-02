// Copyright (c) 2019 Souvik Biswas

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
import 'package:buck_tracker/pages/login_page.dart';
import 'package:buck_tracker/pages/scanner.dart';
import 'package:buck_tracker/pages/sign_in.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import 'indicator.dart';
import 'ocr.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          color: Colors.black87,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        // SvgPicture.asset(
        //   'assets/background.svg',
        //   alignment: Alignment.center,
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height,
        // ),
        Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topRight,
          //     end: Alignment.bottomLeft,
          //     colors: [Colors.blue[100], Colors.blue[400]],
          //   ),
          // ),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 40),
                Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                imageUrl,
                              ),
                              radius: 20,
                              backgroundColor: Colors.transparent,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.exit_to_app_rounded,
                                ),
                                iconSize: 40,
                                color: Colors.green,
                                splashColor: Colors.purple,
                                onPressed: () {
                                  signOutGoogle();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) {
                                    return LoginPage();
                                  }), ModalRoute.withName('/'));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      // Text(
                      //   'NAME',
                      //   style: TextStyle(
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.black54),
                      // ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Welcome Back,\n' + name,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 20),
                // Text(
                //   'EMAIL',
                //   style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black54),
                // ),
                // Text(
                //   email,
                //   style: TextStyle(
                //       fontSize: 25,
                //       color: Colors.deepPurple,
                //       fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 40),
                // RaisedButton(
                //   onPressed: () {
                //     signOutGoogle();
                //     Navigator.of(context).pushAndRemoveUntil(
                //         MaterialPageRoute(builder: (context) {
                //       return LoginPage();
                //     }), ModalRoute.withName('/'));
                //   },
                //   color: Colors.deepPurple,
                //   child: Padding(
                //     padding: const EdgeInsets.all(0.0),
                //     child: Text(
                //       'Sign Out',
                //       style: TextStyle(fontSize: 25, color: Colors.white),
                //     ),
                //   ),
                //   elevation: 5,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(40)),
                // ),
                // SizedBox(height : 300),

                AspectRatio(
                  aspectRatio: 1.3,
                  child: Card(
                    color: Color(0x00000000),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // const SizedBox(
                        //   height: 18,
                        // ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return DashBoard();
                                  },
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                        pieTouchData: PieTouchData(
                                            touchCallback: (FlTouchEvent event,
                                                pieTouchResponse) {
                                          setState(() {
                                            if (!event
                                                    .isInterestedForInteractions ||
                                                pieTouchResponse == null ||
                                                pieTouchResponse
                                                        .touchedSection ==
                                                    null) {
                                              touchedIndex = -1;
                                              return;
                                            }
                                            touchedIndex = pieTouchResponse
                                                .touchedSection!
                                                .touchedSectionIndex;
                                          });
                                        }),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 30,
                                        sections: showingSections()),
                                  ),
                                ),
                                Text(
                                  "Monthly Expenses",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      letterSpacing: 8,
                                      // wordSpacing: 20,
                                      // backgroundColor: Colors.yellow,
                                      shadows: [
                                        Shadow(
                                            color: Colors.blueAccent,
                                            offset: Offset(2, 1),
                                            blurRadius: 10)
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return DashBoard();
                                  },
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                        pieTouchData: PieTouchData(
                                            touchCallback: (FlTouchEvent event,
                                                pieTouchResponse) {
                                          setState(() {
                                            if (!event
                                                    .isInterestedForInteractions ||
                                                pieTouchResponse == null ||
                                                pieTouchResponse
                                                        .touchedSection ==
                                                    null) {
                                              touchedIndex = -1;
                                              return;
                                            }
                                            touchedIndex = pieTouchResponse
                                                .touchedSection!
                                                .touchedSectionIndex;
                                          });
                                        }),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 30,
                                        sections: showingSections()),
                                  ),
                                ),
                                // Text("Quarterly Expense"),
                                Text(
                                  "Quarterly Expenses",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      letterSpacing: 8,
                                      // wordSpacing: 20,
                                      // backgroundColor: Colors.yellow,
                                      shadows: [
                                        Shadow(
                                            color: Colors.blueAccent,
                                            offset: Offset(2, 1),
                                            blurRadius: 10)
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Column(
                        //   mainAxisSize: MainAxisSize.max,
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: const <Widget>[
                        //     Indicator(
                        //       color: Color(0xff0293ee),
                        //       text: 'First',
                        //       isSquare: true,
                        //     ),
                        //     SizedBox(
                        //       height: 4,
                        //     ),
                        //     Indicator(
                        //       color: Color(0xfff8b250),
                        //       text: 'Second',
                        //       isSquare: true,
                        //     ),
                        //     SizedBox(
                        //       height: 4,
                        //     ),
                        //     Indicator(
                        //       color: Color(0xff845bef),
                        //       text: 'Third',
                        //       isSquare: true,
                        //     ),
                        //     SizedBox(
                        //       height: 4,
                        //     ),
                        //     Indicator(
                        //       color: Color(0xff13d38e),
                        //       text: 'Fourth',
                        //       isSquare: true,
                        //     ),
                        //     SizedBox(
                        //       height: 18,
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   width: 28,
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Scanner()),
                            );
                          },
                          child: Text("Scan the bill")),
                    ),

                    // ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => PieChartSample3()),
                    //       );
                    //     },
                    //     child: Text("Dashboard")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  List<PieChartSectionData> showingSections() {
    
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}

// class FirstScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         // decoration: BoxDecoration(
//         //   gradient: LinearGradient(
//         //     begin: Alignment.topRight,
//         //     end: Alignment.bottomLeft,
//         //     colors: [Colors.blue[100], Colors.blue[400]],
//         //   ),
//         // ),
//         child: Center(
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               SizedBox(height: 40),
//               Container(
//                 child: Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CircleAvatar(
//                             backgroundImage: NetworkImage(
//                               imageUrl,
//                             ),
//                             radius: 20,
//                             backgroundColor: Colors.transparent,
//                           ),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: IconButton(
//                               icon: Icon(
//                                 Icons.exit_to_app_rounded,
//                               ),
//                               iconSize: 40,
//                               color: Colors.green,
//                               splashColor: Colors.purple,
//                               onPressed: () {
//                                 signOutGoogle();
//                   Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) {
//                     return LoginPage();
//                   }), ModalRoute.withName('/'));
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                     // Text(
//                     //   'NAME',
//                     //   style: TextStyle(
//                     //       fontSize: 15,
//                     //       fontWeight: FontWeight.bold,
//                     //       color: Colors.black54),
//                     // ),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Welcome Back,\n' + name,
//                         style: TextStyle(
//                             fontSize: 25,
//                             color: Colors.deepPurple,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // SizedBox(height: 20),
//               // Text(
//               //   'EMAIL',
//               //   style: TextStyle(
//               //       fontSize: 15,
//               //       fontWeight: FontWeight.bold,
//               //       color: Colors.black54),
//               // ),
//               // Text(
//               //   email,
//               //   style: TextStyle(
//               //       fontSize: 25,
//               //       color: Colors.deepPurple,
//               //       fontWeight: FontWeight.bold),
//               // ),
//               // SizedBox(height: 40),
//               // RaisedButton(
//               //   onPressed: () {
//               //     signOutGoogle();
//               //     Navigator.of(context).pushAndRemoveUntil(
//               //         MaterialPageRoute(builder: (context) {
//               //       return LoginPage();
//               //     }), ModalRoute.withName('/'));
//               //   },
//               //   color: Colors.deepPurple,
//               //   child: Padding(
//               //     padding: const EdgeInsets.all(0.0),
//               //     child: Text(
//               //       'Sign Out',
//               //       style: TextStyle(fontSize: 25, color: Colors.white),
//               //     ),
//               //   ),
//               //   elevation: 5,
//               //   shape: RoundedRectangleBorder(
//               //       borderRadius: BorderRadius.circular(40)),
//               // ),
//               SizedBox(height : 300),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0,0,60,0),
//                     child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => Scanner()),
//                           );
//                         },
//                         child: Text("Scan the bill")),
//                   ),

//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => PieChartSample3()),
//                     );
//                   },
//                   child: Text("Dashboard")),
//                   ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
