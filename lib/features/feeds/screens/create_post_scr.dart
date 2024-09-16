import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  List<File> images = [];
  void handlePickAnImage() async {
    List<XFile> imgs = await ImagePicker().pickMultiImage();
    for (var img in imgs) {
      images.add(File(img.path));
    }
    setState(() {});
  }

  void handleRemoveAnImage(int idx) async {
    images.removeAt(idx);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Create post'),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'Post',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://res.cloudinary.com/deiiy8ytx/image/upload/v1716836053/ecom/user/profile.png-1716836051653.png.png',
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Pavan Kumar',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _captionController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Share an image to start a caption contest',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                width: double.maxFinite,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index == images.length) {
                      return Card(
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: handlePickAnImage,
                            ),
                          ),
                        ),
                      );
                    }
                    return Card(
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.file(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  itemCount: images.length + 1,
                ),
              )
            ],
          ),
        ));
  }
}
