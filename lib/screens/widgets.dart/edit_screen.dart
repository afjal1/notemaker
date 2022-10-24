import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/firestore_db.dart';

class EditScreen extends StatefulWidget {
  final Notes? note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title!;
      _descriptionController.text = widget.note!.description!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            roundedButton(
                tag: 'back',
                path: 'assets/Icon ionic-ios-arrow-round-back.png',
                onPressed: () {
                  Navigator.pop(context);
                }),
            const Spacer(),
            roundedButton(
                tag: 'delete',
                path: 'assets/Icon material-delete.png',
                onPressed: () {
                  if (widget.note != null) {
                    FirestoreDb().deleteNotes(widget.note!.documentId!);
                    Get.snackbar('Note Deleted', 'Note Deleted Successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                }),
            roundedButton(
              tag: 'save',
              path: 'assets/Path 136.png',
              onPressed: () async {
                if (_titleController.text.isNotEmpty) {
                  await FirestoreDb.addNotes(Notes(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    date: DateTime.now().toIso8601String(),
                  ));

                  Get.snackbar('Note Added', 'Note Saved Successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Theme.of(context).primaryColor,
                      colorText: Colors.white);
                } else {
                  Get.snackbar('Warning!!', 'Note Title is Empty',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          //title
          TextField(
            autofocus: true,
            controller: _titleController,
            maxLines: null,
            style: const TextStyle(
                color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              fillColor: Colors.white,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Title',
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //ENTER TEXT
          TextField(
            controller: _descriptionController,
            maxLines: null,
            style: const TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              fillColor: Colors.white,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Enter Your Text Here',
              hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          )
        ]),
      ),
    );
  }

  Padding roundedButton({String? tag, VoidCallback? onPressed, String? path}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        height: 40,
        width: 40,
        child: FloatingActionButton(
            heroTag: tag,
            shape: const CircleBorder(),
            onPressed: () {
              onPressed!();
            },
            backgroundColor: Colors.white,
            child: Image.asset(path!)),
      ),
    );
  }
}
