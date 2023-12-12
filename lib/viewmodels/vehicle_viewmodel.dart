import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../components/custom_widgets.dart';
import '../database/db_handler.dart';
import '../models/vehicle_model.dart';

class VehicleViewModel extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController modelController = TextEditingController();

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

  Future<void> showAddVehicleDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          title: const Text('Add Vehicle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Consumer<VehicleViewModel>(
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
                    controller: vehicleNoController,
                    labelText: 'Vehicle No.',
                    keyboardType: TextInputType.text),
                CustomWidgets().customTextField(
                  controller: modelController,
                  labelText: 'Model',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameController.clear();
                vehicleNoController.clear();
                modelController.clear();
                image = null;
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xff7A77FF)),
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
                    modelController.text.isEmpty ||
                    vehicleNoController.text.isEmpty ||
                    image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fields can\'t be empty'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  Vehicle newVehicle = Vehicle(
                    name: nameController.text,
                    vehicleNo: vehicleNoController.text,
                    model: modelController.text,
                    image: image!.uri.toString(),
                  );
                  int result = await DBHandler().insertVehicle(newVehicle);
                  if (result != -1) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vehicle Added'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to add Vehicle'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  nameController.clear();
                  vehicleNoController.clear();
                  modelController.clear();
                  image = null;
                  notifyListeners();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    ).whenComplete(() {
      notifyListeners();
    });
  }
}
