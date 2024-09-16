import 'dart:developer';
import 'dart:io';

import 'package:eventmanagement/features/business/bloc/business_bloc.dart';
import 'package:eventmanagement/features/business/models/business_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as Gl;
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class CreateNewBusinessScreen extends StatefulWidget {
  const CreateNewBusinessScreen({super.key});

  @override
  State<CreateNewBusinessScreen> createState() =>
      _CreateNewBusinessScreenState();
}

class _CreateNewBusinessScreenState extends State<CreateNewBusinessScreen> {
  File? banner;
  final TextEditingController _businessName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _alternativecontactNumber =
      TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  List<double> coordinates = [];
  List<Placemark> addresses = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _businessName.dispose();
    _description.dispose();
    _contactNumber.dispose();
    _alternativecontactNumber.dispose();
    _category.dispose();
    _locationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void getLocation() async {
    Gl.LocationPermission geolocationStatus =
        await Gl.Geolocator.checkPermission();

    if (await ph.Permission.location.request() == ph.PermissionStatus.granted) {
      Gl.Position position = await Gl.Geolocator.getCurrentPosition(
          desiredAccuracy: Gl.LocationAccuracy.best);
      debugPrint('location: ${position.latitude}');

      coordinates = [position.latitude, position.longitude];
      log('coordinates is: $coordinates');

      addresses =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      log('${addresses.length}');
      setState(() {});
    } else {
      log('open app settings');
      if (await ph.Permission.location.isPermanentlyDenied ||
          await ph.Permission.location.isRestricted) {
        ph.openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Create New Business',
            style: style.titleMedium,
          ),
          actions: [
            BlocConsumer<BusinessBloc, BusinessState>(
              listener: (context, state) {
                if (state.businessStatus == BusinessStatus.updateSuccess) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Success")));
                  Future.delayed(const Duration(seconds: 3),
                      () => {Navigator.pop(context)});
                }
                if (state.businessStatus == BusinessStatus.updateFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: color.error,
                      content: const Text("Upload / creation failed")));
                }
              },
              builder: (context, state) {
                return OutlinedButton(
                    onPressed:
                        //  state.businessStatus == BusinessStatus.loading
                        //     ? null
                        //     :
                        () {
                      // log("${BusinessModel(
                      //   address: Address(coordinates: coordinates),
                      //   alternativeContactNumber:
                      //       _alternativecontactNumber.text,
                      //   businessName: _businessName.text,
                      //   description: _description.text,
                      //   contactNumber: _contactNumber.text,
                      //   category: _category.text,
                      // ).toJson()}");
                      // return;
                      context.read<BusinessBloc>().add(CreateMyNewBusinessEvent(
                          BusinessModel(
                            address: Address(
                                coordinates: coordinates, type: 'Point'),
                            alternativeContactNumber:
                                _alternativecontactNumber.text,
                            businessName: _businessName.text,
                            description: _description.text,
                            contactNumber: _contactNumber.text,
                            category: _category.text,
                          ),
                          banner));
                    },
                    child: (state.businessStatus == BusinessStatus.loading)
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Uploading'),
                              if (state.businessStatus !=
                                  BusinessStatus.loading)
                                const SizedBox(width: 5),
                              if (state.businessStatus !=
                                  BusinessStatus.loading)
                                const SizedBox(
                                  height: 12,
                                  width: 12,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 1),
                                )
                            ],
                          )
                        : const Text("Create"));
              },
            ),
            const SizedBox(width: 10)
          ],
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          child: ListView(
            children: [
              _bannerBuilder(context),
              const SizedBox(height: 15),
              _inputFieldBuilder(
                  controller: _businessName, label: 'Business Name'),
              const SizedBox(height: 15),
              _inputFieldBuilder(
                  controller: _contactNumber, label: 'Contact Number'),
              const SizedBox(height: 15),
              _inputFieldBuilder(
                  controller: _alternativecontactNumber,
                  label: 'Alternative Number'),
              const SizedBox(height: 15),
              _buildDropDown(
                  context, _category, 'Select your business category'),
              const SizedBox(height: 15),
              _buildDropDown(
                  context, _locationController, 'Select your location',
                  entries: addresses
                      .map((address) => DropdownMenuEntry(
                          value:
                              ' ${address.name} ${address.locality},${address.subLocality},  ${address.street} ${address.postalCode}',
                          label:
                              ' ${address.name} ${address.locality} ,${address.postalCode}'))
                      .toList()),
              const SizedBox(height: 15),
              _inputFieldBuilder(
                  controller: _description,
                  label: 'About Business',
                  maxLines: 10,
                  minLines: 5),
            ],
          ),
        ));
  }

  _inputFieldBuilder({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    int? minLines,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        maxLines: maxLines,
        minLines: minLines,
        controller: controller,
        decoration: InputDecoration(
          label: Text(label),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  _bannerBuilder(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 0.2)),
        child: AspectRatio(
            aspectRatio: 21 / 9,
            child: banner == null
                ? Center(
                    child: TextButton(
                      child: const Text("Pick an Banner image"),
                      onPressed: () async {
                        XFile? img = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (img != null) {
                          setState(() {
                            banner = File(img.path);
                          });
                        }
                      },
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      banner!,
                      fit: BoxFit.cover,
                    ),
                  )));
  }

  _buildDropDown(
      BuildContext context, TextEditingController controller, String hint,
      {List<DropdownMenuEntry>? entries}) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 0.2)),
      child: DropdownMenu(
          controller: controller,
          expandedInsets: EdgeInsets.zero,
          hintText: hint,
          dropdownMenuEntries: entries ??
              [
                const DropdownMenuEntry(
                    value: 'Event Management', label: 'Event Management'),
                const DropdownMenuEntry(
                    value: 'Audio Management', label: 'Audio Management'),
              ]),
    );
  }
}
