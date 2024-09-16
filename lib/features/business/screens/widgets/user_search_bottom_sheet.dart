import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/features/profile/models/profile_model.dart';
import 'package:eventmanagement/main.dart';
import 'package:flutter/material.dart';

class UserSearchBottomSheet extends StatefulWidget {
  const UserSearchBottomSheet({super.key});

  @override
  _UserSearchBottomSheetState createState() => _UserSearchBottomSheetState();
}

class _UserSearchBottomSheetState extends State<UserSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  ApiResponse<List<UserModel>>? apiResponse;
  bool _isLoading = false;

  Future<void> _searchUsers(String query) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> qparams = {};
    if (query.contains('@')) {
      qparams.addAll({'email': query});
    } else if (query.startsWith(RegExp(r'[0-9]'))) {
      qparams.addAll({'phone_number': query});
    } else {
      qparams.addAll({'name': query});
    }
    final response =
        await Dio().get('$baseUrl/users', queryParameters: qparams);

    if (response.statusCode == 200) {
      print(response.data);
      setState(() {
        apiResponse = ApiResponse.fromMap(
            response.data,
            (p0) => (p0 as List<dynamic>)
                .map((user) => UserModel.fromJson(
                    {...(user as Map<String, dynamic>), 'address': null}))
                .toList());
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Enter name, email or phone number',
                      border: const OutlineInputBorder(),
                      suffixIcon: TextButton(
                        onPressed: () {
                          _searchUsers(_searchController.text);
                        },
                        child: const Text('Search'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: apiResponse?.data.length ?? 0,
                      itemBuilder: (context, index) {
                        final user = apiResponse?.data[index];
                        return ListTile(
                          onTap: () {
                            Navigator.pop(context, user);
                          },
                          leading: user?.photoUrlModel.secureUrl != null
                              ? CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      user?.photoUrlModel.secureUrl ?? ""),
                                )
                              : const Icon(Icons.person),
                          title: Text('${user?.firstName} ${user?.lastName}'),
                          subtitle: Text("${user?.email}"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
