import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibhub/views/home/utils/image_post.dart';
import 'package:vibhub/views/home/utils/text_post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController posttext = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.1),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: posttext,
                  decoration: const InputDecoration(
                    labelText: 'Post Something',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          var data = {
                            'time': DateTime.now(),
                            'content': posttext.text,
                            'type': 'text',
                            'uid': FirebaseAuth.instance.currentUser!.uid,
                          };
                          await FirebaseFirestore.instance
                              .collection('posts')
                              .add(data);
                          posttext.clear();
                        } catch (e) {
                          // Handle post error
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Post failed: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 7, 127, 225),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Post',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('timeline')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.data?.docs.isEmpty ?? true) {
                  return const Text('No posts for you');
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final postRef = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postRef['post'])
                          .get(),
                      builder: (context, postSnapshot) {
                        if (postSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${postSnapshot.error}'));
                        }
                        if (postSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        final postData = postSnapshot.data;
                        if (postData == null) {
                          return const Text('Post data not found');
                        }
                        switch (postData['type']) {
                          case 'text':
                            return TextPost(text: postData['content']);
                          case 'image':
                            return ImagePost(
                              text: postData['content'],
                              url: postData['url'],
                            );
                          default:
                            return TextPost(text: postData['content']);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
