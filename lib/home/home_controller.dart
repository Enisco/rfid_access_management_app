// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rfid_access_management_app/home/home_model.dart';

class HomepageController extends GetxController {
  static HomepageController get to => Get.find();

  bool loading = false;

  List<AccessDataModel> accessDataList = [];

  TextEditingController rfidController = TextEditingController();
  TextEditingController holderNameController = TextEditingController();

  getAccessData() {
    loading = true;
    update();
    refreshData();
    update();
  }

  Future<void> refreshData() async {
    final accessDataRef = FirebaseDatabase.instance.ref("access_data");
    accessDataList = [];

    accessDataRef.onChildAdded.listen(
      (event) {
        AccessDataModel retrievedAccessData = accessDataModelFromJson(
            jsonEncode(event.snapshot.value).toString());
        accessDataList.add(retrievedAccessData);
        print("Going again");
      },
    );
    loading = false;
    update();
  }

  uploadAccessData() async {
    loading = true;
    update();
    String rfId = rfidController.text.trim();
    String holderName = holderNameController.text.trim();

    AccessDataModel accessData = AccessDataModel(
      id: rfId,
      holderName: holderName,
      isTimed: false,
      grantAccess: true,
      endTime: int.parse(
        DateTime.now().microsecondsSinceEpoch.toString().substring(0, 10),
      ),
    );
    DatabaseReference ref = FirebaseDatabase.instance.ref("access_data/$rfId");

    print(accessData.toJson());

    await ref.set(accessData.toJson()).whenComplete(() async {
      print("Data uploaded");
      // Fluttertoast.showToast(msg: "Data Uploaded");
    });
    rfidController.clear();
    holderNameController.clear();
    loading = false;
    update();
  }

  updateAccessData(AccessDataModel updatedAccessData) async {
    String rfId = updatedAccessData.id!;

    DatabaseReference ref = FirebaseDatabase.instance.ref("access_data/$rfId");

    print(updatedAccessData.toJson());

    await ref.update(updatedAccessData.toJson()).whenComplete(() async {
      print("Data updated");
      // Fluttertoast.showToast(msg: "Data updated");
    });
    refreshData();
    loading = false;
    update();
  }
}
