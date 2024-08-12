import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Search for an user'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Search user',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
              onChanged: (val) {
                username = val;
                setState(() {});
              },
            ),
          ),

          ///
          if (username != null)
            if (username!.length > 3)
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isEqualTo: username)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.docs.isEmpty ?? false) {
                      return const Text('No User found');
                    }
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data?.docs.length ?? 0,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            return ListTile(
                              title: Text(doc['username']),
                              trailing: FutureBuilder<DocumentSnapshot>(
                                  future: doc.reference
                                      .collection('followers')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data?.exists ?? false) {
                                        return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 28, 146, 242)),
                                            onPressed: () async {
                                              await doc.reference
                                                  .collection('followers')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .delete();
                                              setState(() {});
                                            },
                                            child: const Text(
                                              'Unfollow',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins'),
                                            ));
                                      }
                                      return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 16, 142, 245)),
                                          onPressed: () async {
                                            await doc.reference
                                                .collection('followers')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .set({
                                              'time': DateTime.now(),
                                            });
                                            setState(() {});
                                          },
                                          child: const Text(
                                            'Follow',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ));
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  }),
                            );
                          }),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
        ],
      ),
    );
  }
}
