import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'api_config.dart';

class UpdateShowPage extends StatefulWidget {
  final String showId;
  final String title;
  final String description;
  final String category;
  final String imageUrl;

  const UpdateShowPage({super.key, required this.showId, required this.title, required this.description, required this.category, required this.imageUrl});

  @override
  _UpdateShowPageState createState() => _UpdateShowPageState();
}

class _UpdateShowPageState extends State<UpdateShowPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  File? _imageFile;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _selectedCategory = widget.category;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateShow() async {
    setState(() => _isUpdating = true);
    var request = http.MultipartRequest('PUT', Uri.parse('${ApiConfig.baseUrl}/shows/${widget.showId}'));
    request.fields['title'] = _titleController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['category'] = _selectedCategory;
    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
    }
    var response = await request.send();
    setState(() => _isUpdating = false);
    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Show"), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: _descriptionController, maxLines: 3, decoration: const InputDecoration(labelText: "Description")),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: const [
                DropdownMenuItem(value: "movie", child: Text("Movie")),
                DropdownMenuItem(value: "anime", child: Text("Anime")),
                DropdownMenuItem(value: "serie", child: Text("Series")),
              ],
              onChanged: (value) => setState(() => _selectedCategory = value!),
              decoration: const InputDecoration(labelText: "Category"),
            ),
            ElevatedButton(onPressed: _updateShow, child: const Text("Update Show")),
          ],
        ),
      ),
    );
  }
}
