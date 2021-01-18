import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();

  File _image;
  List<ImageLabel> _labels;

  Future<void> _getImageAndDetectLabels() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
      final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
      final List<ImageLabel> labels = await labeler.processImage(visionImage);

      setState(() {
        _image = image;
        _labels = labels;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Image Labeling Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (_image == null || _labels == null)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Wanna check image labels?\nLet\'s select a photo!',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Image.file(
                        _image,
                        height: 240.0,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Detected labels: ',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        _labels
                            .map((label) => '${label.text}'
                                'with confidence ${label.confidence.toStringAsFixed(2)}')
                            .join('\n'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(height: 16.0),
                      Text('Want to check next image?'),
                    ],
                  ),
            SizedBox(height: 16.0),
            RaisedButton(
              onPressed: _getImageAndDetectLabels,
              child: Text(
                'OPEN IMAGE',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue[500],
            ),
          ],
        ),
      ),
    );
  }
}
