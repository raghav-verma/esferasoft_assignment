import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/note_model.dart';
import '../view_models/note_view_model.dart';
import 'note_creation_screen.dart';
import 'package:intl/intl.dart';

class NoteViewScreen extends StatelessWidget {
  final NoteModel note;

  const NoteViewScreen({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final NoteViewModel controller = Get.find();
    final formattedDate = DateFormat('MMM dd, yyyy').format(note.createdAt);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Note Details',
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              controller.initializeFields(note);
              Get.to(NoteCreationScreen(note: note));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              controller.deleteNote(note);
              Get.back();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              note.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: note.categories.map((category) {
                return Chip(
                  label: Text(category),
                  backgroundColor: Colors.grey[800],
                  labelStyle: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Last Updated: $formattedDate',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}
