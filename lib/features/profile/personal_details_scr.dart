import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController =
      TextEditingController(text: 'Leyla');
  final TextEditingController _lastNameController =
      TextEditingController(text: 'Smith');
  final TextEditingController _phoneContryCodeController =
      TextEditingController(text: '+91');
  final TextEditingController _phoneController =
      TextEditingController(text: '8888277777');
  final TextEditingController _emailController =
      TextEditingController(text: 'leyla.smith@gmail.com');
  final TextEditingController _addressController =
      TextEditingController(text: '123 Main St., Chandigarh');
  final TextEditingController _cityController =
      TextEditingController(text: 'Chandigarh');
  final TextEditingController _stateController =
      TextEditingController(text: 'Andhra pradesh');
  final TextEditingController _zipcodeController =
      TextEditingController(text: '160055');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildProfilePhoto(),
              const SizedBox(height: 20),
              _buildGeneralInfo(context),
              const SizedBox(height: 20),
              _buildAddressDetails(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Center(
      child: Stack(
        children: [
          Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                      'https://res.cloudinary.com/deiiy8ytx/image/upload/v1716836053/ecom/user/profile.png-1716836051653.png.png'),
                ),
              )),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton.small(
              onPressed: () {},
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfo(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Information',
            style: style.titleMedium,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First name',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _phoneContryCodeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 8,
                child: TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressDetails(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address Information',
            style: style.titleMedium,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _stateController,
            decoration: const InputDecoration(
              labelText: 'State',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _zipcodeController,
            decoration: const InputDecoration(
              labelText: 'Zipcode',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
