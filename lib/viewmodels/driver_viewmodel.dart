import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../components/custom_widgets.dart';
import '../database/db_handler.dart';
import '../models/driver_model.dart';

class DriverViewModel extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      this.image = imageTemp;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> showAddDriverDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          title: const Text('Add Driver'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    pickImage();
                  },
                  child: const Text('Choose Image'),
                ),
                Consumer<DriverViewModel>(
                  builder: (context, vehicleProvider, child) {
                    if (vehicleProvider.image != null) {
                      return Text(vehicleProvider.image!.path.split('/').last);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomWidgets().customTextField(
                    controller: nameController,
                    labelText: 'Name',
                    keyboardType: TextInputType.text),
                CustomWidgets().customTextField(
                    controller: licenseNumberController,
                    labelText: 'License Number',
                    keyboardType: TextInputType.number),
                CustomWidgets().customTextField(
                    controller: phoneNumberController,
                    labelText: 'Phone Number',
                    keyboardType: TextInputType.number),
                CustomWidgets().customTextField(
                  controller: cityController,
                  labelText: 'City',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameController.clear();
                licenseNumberController.clear();
                phoneNumberController.clear();
                cityController.clear();
                image = null;
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xff7A77FF),
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => const Color(0xff7A77FF)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    phoneNumberController.text.isEmpty ||
                    cityController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fields can\'t be empty'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  Driver newDriver = Driver(
                    name: nameController.text,
                    licenseNumber: licenseNumberController.text,
                    phoneNumber: phoneNumberController.text,
                    city: cityController.text,
                    image: image!.path,
                  );
                  int result = await DBHandler().insertDriver(newDriver);
                  if (result != -1) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Driver Added'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to add Driver'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  Navigator.pop(context);
                  nameController.clear();
                  licenseNumberController.clear();
                  phoneNumberController.clear();
                  cityController.clear();
                  image = null;
                  notifyListeners();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
