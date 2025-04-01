import 'package:flutter/material.dart';
import 'add_show_page.dart';
import 'show_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Show Manager"), backgroundColor: Colors.blueAccent),
      body: const ShowList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddShowPage())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
