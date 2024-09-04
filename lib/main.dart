import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view_models/view_models.dart';
import 'views/views.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<NoteViewModel>(() => NoteViewModel());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Esferasoft Note',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NoteListScreen(),
    );
  }
}
