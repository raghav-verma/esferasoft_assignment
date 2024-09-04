import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NoteViewModel extends GetxController {
  RxList<NoteModel> notes = <NoteModel>[].obs;
  RxList<NoteModel> filteredNotes = <NoteModel>[].obs;

  RxList<String> categories = ["All Notes", "Work", "Home"].obs;

  List<String> get creationCategories => categories.where((category) => category != "All Notes").toList();

  RxList<String> selectedCategories = <String>[].obs;
  RxString searchQuery = ''.obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  SharedPreferences? _prefs;

  NoteModel? currentNote;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> loadNotes() async {
    _prefs = await SharedPreferences.getInstance();
    final String? savedNotes = _prefs?.getString('notes');

    if (savedNotes != null) {
      notes.value = NoteModel.decode(savedNotes);
      filteredNotes.value = notes;
    }
  }

  Future<void> saveNotes() async {
    final String encodedData = NoteModel.encode(notes);
    await _prefs?.setString('notes', encodedData);
  }

  void addNote(NoteModel note) {
    notes.add(note);
    saveNotes();
    filterNotes();
  }

  void editNote(NoteModel oldNote, NoteModel newNote) {
    int index = notes.indexOf(oldNote);
    notes[index] = newNote;
    saveNotes();
    filterNotes();
  }

  void deleteNote(NoteModel note) {
    notes.remove(note);
    saveNotes();
    filterNotes();
  }

  void filterNotes() {
    filteredNotes.value = notes.where((note) {
      final titleMatches = note.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      final descriptionMatches = note.description.toLowerCase().contains(searchQuery.value.toLowerCase());
      final categoryMatches = selectedCategories.isEmpty ||
          selectedCategories.any((category) => note.categories.contains(category));

      return (titleMatches || descriptionMatches) && categoryMatches;
    }).toList();
  }

  void searchNotes(String query) {
    searchQuery.value = query;
    filterNotes();
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    filterNotes();
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    selectedCategories.clear();
  }

  void initializeFields(NoteModel? note) {
    if (note != null) {
      titleController.text = note.title;
      descriptionController.text = note.description;
      selectedCategories.value = note.categories;
      currentNote = note;
    } else {
      clearFields();
    }
  }
}
