import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeedsHomeScreen extends StatefulWidget {
  const FeedsHomeScreen({super.key});

  @override
  State<FeedsHomeScreen> createState() => _FeedsHomeScreenState();
}

class _FeedsHomeScreenState extends State<FeedsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPostsSection(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('createPost');
        },
        child: const Icon(Icons.create),
      ),
    );
  }

  Widget _buildPostsSection() {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration:
                const BoxDecoration(border: Border(bottom: BorderSide(width: 0.2))),
            child: Column(
              children: [
                const ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  leading: CircleAvatar(
                    radius: 20,
                  ),
                  title: Text("Mavi"),
                  subtitle: Text('1 year ago'),
                  trailing: Icon(Icons.more_vert_rounded),
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: Text(
                      'Some random text about this post so we can style accoringly . this text need to be long also....'),
                ),
                SizedBox(
                    width: double.maxFinite,
                    child: CachedNetworkImage(
                        imageUrl:
                            'https://placehold.co/600x400/000000/FFFFFF/png')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.thumb_up_outlined)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.share_outlined)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.chat_outlined)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
