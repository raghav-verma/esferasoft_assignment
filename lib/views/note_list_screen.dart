import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../view_models/note_view_model.dart';
import 'views.dart';

class NoteListScreen extends GetView<NoteViewModel> {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 48,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Good Morning,\nAditya!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[600],
                      radius: 28,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (query) {
                  controller.searchNotes(query);
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Obx(() {
                return SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: controller.categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: controller.selectedCategories.contains(category),
                          onSelected: (isSelected) {
                            if (isSelected) {
                              controller.selectedCategories.add(category);
                            } else {
                              controller.selectedCategories.remove(category);
                            }
                            controller.filterNotes();
                          },
                          selectedColor: Colors.green,
                          backgroundColor: Colors.grey[800],
                          labelStyle: TextStyle(
                            color: controller.selectedCategories.contains(category)
                                ? Colors.white
                                : Colors.grey[400],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  if (controller.filteredNotes.isEmpty) {
                    return Center(
                      child: Text(
                        'No notes available',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: controller.filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = controller.filteredNotes[index];
                      final formattedDate =
                      DateFormat('MMM dd, yyyy').format(note.createdAt);
                      return GestureDetector(
                        onTap: () {
                          Get.to(NoteViewScreen(note: note));
                        },
                        child: Card(
                          color: Color(note.color), // Use assigned color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  note.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CircleAvatar(
                                  backgroundColor: Colors.grey[600],
                                  radius: 16,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[900],
              radius: 24,
              child: const Icon(
                Icons.home,
                color: Colors.white,
                size: 24,
              ),
            ),
            InkWell(
              onTap: () {
                controller.clearFields();
                Get.to(const NoteCreationScreen());
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[900],
                radius: 24,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Icon(Icons.person, color: Colors.grey[800], size: 28),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
