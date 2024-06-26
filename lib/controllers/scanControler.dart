import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:irefighter/modules/DatabaseManeger.dart';
import 'package:irefighter/modules/Report.dart';
import 'package:permission_handler/permission_handler.dart';





class ScanControler extends GetxController {
  late CameraController cameraController;
  bool isCameraInitialised = false,
      flashOn = false,
      isPictureMode = true,
      isVocalRecording = false,
      isVideoRecording = false,
      detect = false;
  int cameraCount = 0, timer = 0;
  double x = 0, y = 0, w = 0, h = 00;
  String label = "";
  final recorder = FlutterSoundRecorder();

  late FlutterVision vision;
  late Report report;
  late DatabaseManeger db;
  double currentZoomLevel = 1.0, maxZoomLevel = 1.0;

  @override
  onInit() {
    super.onInit();
    _initCamera();
    _initTFLite();
    _initVocalRecorder();
    report = Report();
    db = DatabaseManeger();
  }

  @override
  dispose() {
    cameraController.dispose();
    vision.closeYoloModel();
    recorder.closeRecorder();
    super.dispose();
  }

  flashController() {
    flashOn = !flashOn;
    if (flashOn)
      cameraController.setFlashMode(FlashMode.torch);
    else
      cameraController.setFlashMode(FlashMode.off);
    update(["CameraControls"]);
  }

  modeController() {
    isPictureMode = !isPictureMode;
    isVideoRecording = false;

    update(["CameraControls"]);
  }

  void focusOnPoint(Offset point, BoxConstraints constraints) async {
    if (cameraController != null) {
      double x = point.dx / constraints.maxWidth;
      double y = point.dy / constraints.maxHeight;
      await cameraController!.setFocusPoint(Offset(x, y));
    }
  }
  void setZoomLevel(double zoomLevel) async {
    if (cameraController != null) {
      double newZoomLevel = zoomLevel.clamp(1.0, maxZoomLevel);
      await cameraController!.setZoomLevel(newZoomLevel);
      currentZoomLevel = newZoomLevel;
      update(['CameraControls']); // Update the UI
    }
  }

  startVideoRecord() async {
    await cameraController.startVideoRecording();
    isVideoRecording = true;

    update(["CameraControls"]);
  }

  stopVideoRecord() async {
    isVideoRecording = false;

    XFile vid = await cameraController.stopVideoRecording();
    report.setResourcePath(vid.path);
    report.setResourceType("video");
    //File(mediaPath).delete();
    update(["audioRecorder"]);
  }

  startVocalRecord() async {
    await recorder.startRecorder(toFile: 'audio');
    isVocalRecording = true;

    update(["audioRecorder"]);
  }

  stopVocalRecord() async {
    isVocalRecording = false;

    final path = await recorder.stopRecorder();
    report.setAudioPath(path);
    update(["audioRecorder"]);
  }

  takePicture() async {
    XFile f = await cameraController.takePicture();
    report.setResourcePath(f.path);
    report.setResourceType("image");
  }

  Future<String> sendReport() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == "denied" || locationPermission == "deniedForever")
      await Geolocator.requestPermission();

    Position currentPossion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    db.latLongToCity(currentPossion.latitude, currentPossion.longitude);
    Map<String, dynamic> locdata = await db.latLongToCity(
        currentPossion.latitude, currentPossion.longitude);
    report.setCity(locdata["city"]);
    report.setAddr(locdata["addr"]);
    report.setPositionLat(currentPossion.latitude);
    report.setPositionLong(currentPossion.longitude);
    report.setReportDate(DateTime.now());
    await db.sendReport(report);
    await report.deleteFiles();

    return "Success";
  }

  //Initialisations
  //camera
  Future<void> _initCamera() async {
    if (await Permission.camera.request().isGranted) {
      List<CameraDescription> cameras = await availableCameras();
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
      );

      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 2 == 0) {
            cameraCount = 0;

            fireDetector(image);
          }
          ;
        });
      });
      cameraController.setFlashMode(FlashMode.off);
      maxZoomLevel = await cameraController.getMaxZoomLevel() ;
      isCameraInitialised = true;
      update();
    } else
      print("Permission Denied");
  }

  //model
  Future<void> _initTFLite() async {
    vision = FlutterVision();
    await vision.loadYoloModel(
        modelPath: "assets/firesmoke32.tflite",
        labels: "assets/firesmoke.txt",
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 1,
        useGpu: false);
  }


  //vocalRecorder
  Future<void> _initVocalRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted)
      throw ("microphon permission not granted");

    await recorder.openRecorder();
    recorder.setSubscriptionDuration(Duration(minutes: 1));
  }

  //detection logic
  fireDetector(CameraImage image) async {
    var detector = await vision.yoloOnFrame(
        bytesList: image.planes.map((plane) => plane.bytes).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        iouThreshold: 0.4,
        confThreshold: 0.1,
        classThreshold: 0.1);

    if (detector != null) {
      if (detector.length != 0 && detector.first["box"][4] * 100 > 10) {
        var firstValue = detector.first;
        label = detector.first["tag"].toString();
        timer = 0;
        detect = true;
        report.setConfidence((firstValue["box"][4]*100).round());
        double x1 = double.parse(firstValue['box'][0].toString());
        double x2 = double.parse(firstValue['box'][1].toString());
        double y1 = double.parse(firstValue['box'][2].toString());
        double y2 = double.parse(firstValue['box'][3].toString());
        if (x - x1 + y - x2 > 20)


        h = 100; //y2-y1;
        w = 100; //x2-x1;
        x = x1;
        y = x2;

      } else {
        timer++;
      }

      if (timer >= 25) {
        timer = 0;
        detect = false;

      }

      update(["CameraBorder","CameraControls"]);
    }
  }
}
