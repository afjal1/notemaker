import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notemaker/configs/config.dart';
import 'package:notemaker/screens/login_screen.dart';

import '../configs/firestore_db.dart';
import 'widgets.dart/edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  fetchNotes() async {
    return FirestoreDb().fetchAlarmStream();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.08, left: size.width * 0.05),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    child: FloatingActionButton(
                        heroTag: 'btn1',
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditScreen()));
                        },
                        child: const Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.black,
                        )),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Welcome to Note Maker \nHave a nice day',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: FloatingActionButton(
                          heroTag: 'btn2',
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Get.to(() => const LoginScreen());
                          },
                          child: const Icon(
                            Icons.logout,
                            size: 30,
                            color: Colors.black,
                          )),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 20),
          //Grid View
          Expanded(
            child: StreamBuilder<List<Notes>>(
                stream: FirestoreDb().fetchAlarmStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Notes> notes = snapshot.data!;
                    return notes.isEmpty
                        ? Center(
                            child: Image.asset(
                            'assets/Group 468@2x.png',
                          ))
                        : GridView.builder(
                            itemCount: notes.length,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.8),
                            itemBuilder: ((context, index) {
                              Notes note = notes[index];
                              return Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            blurRadius: 1,
                                            spreadRadius: 1,
                                          )
                                        ]),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 8,
                                          right: 1,
                                          child: SizedBox(
                                            height: 40,
                                            child: FloatingActionButton(
                                              heroTag: 'btnBlue$index',
                                              shape: const CircleBorder(),
                                              onPressed: () {
                                                FirestoreDb().deleteNotes(
                                                    note.documentId!);
                                                Get.snackbar('Note Deleted',
                                                    'Note Deleted Successfully',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white);
                                              },
                                              backgroundColor:
                                                  const Color(0xff01bff9),
                                              child: const Icon(
                                                Icons.delete_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 8,
                                          right: 1,
                                          child: SizedBox(
                                            height: 40,
                                            child: FloatingActionButton(
                                              heroTag: 'btnRed$index',
                                              shape: const CircleBorder(),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditScreen(
                                                              note: note,
                                                            )));
                                              },
                                              backgroundColor:
                                                  const Color(0xffff5858),
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 18,
                                          left: 10,
                                          child: Text(
                                            note.title!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              note.description!,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              maxLines: 4,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 20,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 18.0),
                                            child: Text(
                                              NoteMakerApp()
                                                  .formattedDate(note.date!),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            }));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          )
        ],
      ),
    );
  }
}
