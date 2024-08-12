import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibhub/views/auth/login.dart';
import 'package:vibhub/views/home/homepage.dart';
import 'package:vibhub/views/home/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //APPBAR
        appBar: AppBar(
          title: const Text('HomePage'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),

        //DRAWER
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false,
                    );
                  } catch (e) {
                    // Handle sign out error
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign out failed: $e')),
                    );
                  }
                },
                title: const Text('Sign Out'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (i) {
              setState(() {
                index = i;
              });
            },
            currentIndex: index,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.live_tv_rounded), label: 'Live'),
            ]),
        body: IndexedStack(
          index: index,
          children: [
            const Home(),
            Container(),
            Container(),
          ],
        ));
  }
}
