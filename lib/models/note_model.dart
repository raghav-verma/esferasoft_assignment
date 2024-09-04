import 'dart:convert';

class NoteModel {
  String title;
  String description;
  List<String> categories;
  DateTime createdAt;
  int color;

  NoteModel({
    required this.title,
    required this.description,
    required this.categories,
    required this.createdAt,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'categories': categories,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      title: json['title'],
      description: json['description'],
      categories: List<String>.from(json['categories']),
      createdAt: DateTime.parse(json['createdAt']),
      color: json['color'],
    );
  }

  static String encode(List<NoteModel> notes) => json.encode(
    notes.map<Map<String, dynamic>>((note) => note.toJson()).toList(),
  );

  static List<NoteModel> decode(String notes) =>
      (json.decode(notes) as List<dynamic>)
          .map<NoteModel>((item) => NoteModel.fromJson(item))
          .toList();
}
