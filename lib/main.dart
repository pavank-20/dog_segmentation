import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as https;
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: App(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _App();
}

class _App extends State<App> {
  bool isimageloading = false;
  List labels = [];
  Uint8List? imagebytes;
  File? filepath;
  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    //  implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  pickimagegallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        filepath = File(image.path);
      });
      await sendimage(filepath!);
    }
  }

  pickimagecamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        filepath = File(image.path);
      });
      await sendimage(filepath!);
    }
  }

  sendimage(File image) async {
    Map<String, String> headers = {'Content-type': 'multipart/form-data'};
    var request = https.MultipartRequest('POST',
        Uri.https("APresults4.pythonanywhere.com", "/image_segment"));
    request.files.add(https.MultipartFile(
      "image",
      image.readAsBytes().asStream(),
      image.lengthSync(),
      filename: "handwritten.jpeg",
      contentType: MediaType('image', 'jpeg'),
    ));
    request.headers.addAll(headers);
    var res = await request.send();
    if (res.statusCode == 200) {
      var bytes = await res.stream.toBytes();
      setState(() {
        imagebytes = bytes;
        isimageloading = false;
      });
    } else {}
  }

  // classifyimage(XFile path) async {
  //   var output1 = await Tflite.runSegmentationOnImage(
  //     path: path.path,
  //   );
  //   print(output1);
  //   setState(() {
  //     imagebytes = output1!;
  //     print(labels);
  //     isimageloading = false;
  //   });
  // }

  Widget text(e) {
    return Text(e['label']);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Segmentation"),
          backgroundColor: Color.fromARGB(255, 146, 154, 199),
          leading: Container(
            width: 80,
            height: 80,
          // leading: Padding(
            // padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/images/aiproffai.png', // Replace with the path to your image
              fit: BoxFit.contain,
            ),
          ),
        ),
        //   leading: Image.asset(
        //     'E:\\AiProff Projects\\aiproffai.jpg', // Replace with the path to your image
        //     fit: BoxFit.contain,
        //   ),
        // ),
        body: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: filepath != null
                ? (isimageloading
                    ? const Text(
                        "Please wait while we are loading your image",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : Image.memory(imagebytes!))
                : const Text(
                    "No image to show",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  isimageloading = true;
                });
                pickimagegallery();
              },
              child: const Text("Image from gallery")),
          ElevatedButton(
              onPressed: () {
                if (!isimageloading) {
                  setState(() {
                    isimageloading = true;
                  });
                  pickimagecamera();
                }
              },
              child: const Text("Image from camera")),
          const SizedBox(
            height: 20,
          ),
          labels.length > 0
              ? Text(
                  labels[0]['label'],
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.33),
                )
              : SizedBox.shrink()
        ]),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(10),
          color: Color.fromARGB(255, 132, 139, 189),
          child: Text(
            " AiProff.ai 2023",
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }
}




























// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as https;
// import 'package:http_parser/http_parser.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: App(),
//     );
//   }
// }

// class App extends StatefulWidget {
//   @override
//   State<App> createState() => _App();
// }

// class _App extends State<App> {
//   bool isimageloading = false;
//   List labels = [];
//   Uint8List? imagebytes;
//   File? filepath;
//   ImagePicker picker = ImagePicker();

//   @override
//   void initState() {
//     //  implement initState
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   pickimagegallery() async {
//     var image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         filepath = File(image.path);
//       });
//       await sendimage(filepath!);
//     }
//   }

//   pickimagecamera() async {
//     var image = await picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       setState(() {
//         filepath = File(image.path);
//       });
//       await sendimage(filepath!);
//     }
//   }

//   sendimage(File image) async {
//     Map<String, String> headers = {'Content-type': 'multipart/form-data'};
//     var request = https.MultipartRequest('POST',
//         Uri.https("APresults4.pythonanywhere.com", "/image_segment"));
//     request.files.add(https.MultipartFile(
//       "image",
//       image.readAsBytes().asStream(),
//       image.lengthSync(),
//       filename: "handwritten.jpeg",
//       contentType: MediaType('image', 'jpeg'),
//     ));
//     request.headers.addAll(headers);
//     var res = await request.send();
//     if (res.statusCode == 200) {
//       var bytes = await res.stream.toBytes();
//       setState(() {
//         imagebytes = bytes;
//         isimageloading = false;
//       });
//     } else {}
//   }

//   // classifyimage(XFile path) async {
//   //   var output1 = await Tflite.runSegmentationOnImage(
//   //     path: path.path,
//   //   );
//   //   print(output1);
//   //   setState(() {
//   //     imagebytes = output1!;
//   //     print(labels);
//   //     isimageloading = false;
//   //   });
//   // }

//   Widget text(e) {
//     return Text(e['label']);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text("Segmentation"),
//           backgroundColor: Colors.indigo[400],
//         ),
//         body: Column(children: [
//           const SizedBox(
//             height: 20,
//           ),
//           Container(
//             height: MediaQuery.of(context).size.height * 0.4,
//             width: double.infinity,
//             child: filepath != null
//                 ? (isimageloading
//                     ? const Text(
//                         "Please wait while we are loading your image",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       )
//                     : Image.memory(imagebytes!))
//                 : const Text(
//                     "No image to show",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   isimageloading = true;
//                 });
//                 pickimagegallery();
//               },
//               child: const Text("Image from gallery")),
//           ElevatedButton(
//               onPressed: () {
//                 if (!isimageloading) {
//                   setState(() {
//                     isimageloading = true;
//                   });
//                   pickimagecamera();
//                 }
//               },
//               child: const Text("Image from camera")),
//           const SizedBox(
//             height: 20,
//           ),
//           labels.length > 0
//               ? Text(
//                   labels[0]['label'],
//                   style: TextStyle(fontWeight: FontWeight.bold, height: 1.33),
//                 )
//               : SizedBox.shrink()
//         ]),
//       );
//     });
//   }
// }
